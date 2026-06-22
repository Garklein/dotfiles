#include <stdlib.h>
#include <stdio.h>
#include <xcb/xcb.h>
#include <unistd.h>
#include <X11/Xutil.h>
#include <time.h>

xcb_screen_t *scr;
xcb_connection_t *c;

#define SCR_W 1920
#define SCR_H 1080
#define MARGIN 12  /* margin */
#define CORNER 35  /* margin in corners */
#define PERP 10    /* marker size */

// taken from lemonbar
xcb_visualid_t get_visual() { Display *dpy = XOpenDisplay(0); XVisualInfo xv;
	xv.depth = 32; int result = 0;
	return XGetVisualInfo(dpy, VisualDepthMask, &xv, &result)->visualid; }

void command(char *s, char *fmt, int *out) {
	FILE *fd = popen(s, "r"); fscanf(fd, fmt, out); pclose(fd); }

enum { CLOCK, VOL, BATT, LIGHT };
typedef struct bar { int x, y, w, h, l, id;
	xcb_drawable_t win; xcb_gcontext_t gc, cleargc; } B;
B bars[4] =
	{ (B){ .x=0, .y=0, .w=SCR_W, .h=2*MARGIN, .l=SCR_W-2*CORNER, .id=CLOCK }
	, (B){ .x=SCR_W-2*MARGIN, .y=0, .w=2*MARGIN, .h=SCR_H, .l=SCR_H-2*CORNER, .id=VOL }
	, (B){ .x=0, .y=SCR_H-2*MARGIN, .w=SCR_W, .h=2*MARGIN, .l=SCR_W-2*CORNER, .id=BATT }
	, (B){ .x=0, .y=0, .w=2*MARGIN, .h=SCR_H, .l=SCR_H-2*CORNER, .id=LIGHT }
	};

void line(B b,int x0, int y0, int dx, int dy) {
	xcb_poly_line(c, XCB_COORD_MODE_PREVIOUS, b.win,b.gc, 2,
		(const xcb_point_t []){ {x0,y0}, {dx,dy} }); }

void draw() { int percent;
	for (int i=0; i<4; i++) { B*b=&bars[i];
		xcb_poly_fill_rectangle(c, b->win, b->cleargc, 1, (const xcb_rectangle_t[]){ 0, 0, b->w, b->h });
		switch (b->id) {
		case CLOCK: line(*b,CORNER,MARGIN,b->l,0);
			time_t now; time(&now); int halfDay = (now + (24-4) * 60*60) % (12*60*60);
			int hour = now % (60*60);
			line(*b,CORNER+halfDay * b->l / (60*60*12), MARGIN-PERP/2, 0, PERP);
			line(*b,CORNER+hour * b->l / (60*60), MARGIN-(PERP+4)/2, 0, PERP+4);
			break;
		case VOL: line(*b,MARGIN,CORNER,0,b->l);
			int muted; command("sndioctl output.mute | sed 's/.*=//'","%d",&muted);
			if (!muted) { command("sndioctl output.level | sed 's/.*=//'", "0.%d", &percent);
				line(*b,MARGIN-PERP/2,CORNER+b->l - percent * b->l / 1000,PERP,0);}
			break;
		case BATT: line(*b,CORNER,MARGIN,b->l,0);
			command("apm -l", "%d", &percent);
			int status; command("apm -b", "%d", &status);
			int batteryX = percent * b->l / 100;
			int offsetX = status == 3 ? 5 : 0; // 3 = charging
			line(*b,CORNER+batteryX+offsetX,MARGIN-PERP/2, -2*offsetX, PERP);
			break;
		case LIGHT: line(*b,MARGIN,CORNER,0,b->l);
			command("xbacklight -get | sed 's/\\..*//'", "%d", &percent);
			line(*b,MARGIN-PERP/2,CORNER+b->l-b->l*percent/100,PERP,0);
		}
	}
}

int main() {
	c = xcb_connect(NULL, NULL);
	scr = xcb_setup_roots_iterator(xcb_get_setup(c)).data;

  // Try to get a RGBA visual and build the colormap for that (from lemonbar)
  xcb_visualid_t visual = get_visual();
  xcb_colormap_t colormap = xcb_generate_id(c);
  xcb_create_colormap(c, XCB_COLORMAP_ALLOC_NONE, colormap, scr->root, visual);

	for (int i=0; i<4; i++) { B*b=&bars[i];
		b->win = xcb_generate_id(c);
		xcb_create_window(c, 32, b->win, scr->root, b->x, b->y, b->w, b->h, 0, XCB_WINDOW_CLASS_INPUT_OUTPUT, visual,
			XCB_CW_BACK_PIXEL | XCB_CW_BORDER_PIXEL | XCB_CW_COLORMAP,
			(const uint32_t []) { 0, 0, colormap });
		xcb_map_window(c, b->win);
		xcb_configure_window(c, b->win, XCB_CONFIG_WINDOW_X | XCB_CONFIG_WINDOW_Y, (const uint32_t []){ b->x, b->y }); // make cwm listen to the position
		xcb_change_property(c, XCB_PROP_MODE_REPLACE, b->win, XCB_ATOM_WM_NAME, XCB_ATOM_STRING, 8, 4, "rice");

		b->gc = xcb_generate_id(c);
		xcb_create_gc(c, b->gc, b->win, XCB_GC_FOREGROUND | XCB_GC_LINE_WIDTH | XCB_GC_CAP_STYLE, (const uint32_t[]){ 0xff000000, 5, XCB_CAP_STYLE_ROUND });

		b->cleargc = xcb_generate_id(c);
		xcb_create_gc(c, b->cleargc, b->win, XCB_GC_FOREGROUND, (const uint32_t[]){ 0 });
	}

	struct timespec bruh = { .tv_sec=0, .tv_nsec=1e9 };
	while (1) { draw(); xcb_flush(c); nanosleep(&bruh,NULL); }
}
