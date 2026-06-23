#include <time.h>
#include <stdio.h>
#include <xcb/xcb.h>

#define SCR_W 1920
#define SCR_H 1080
#define MARG 12  /* margin */
#define CORN 60  /* margin in corners */
#define PERP 10  /* marker size */
#define FORB B*b; for (int i=0; b=&bars[i],i<4; i++)

#define SH(s,fmt,...) { FILE*fd=popen(s,"r"); fscanf(fd,fmt,__VA_ARGS__); pclose(fd); }

enum { CLOCK, VOL, BATT, LIGHT };
typedef struct bar { int x, y, w, h, l, id; xcb_drawable_t win; xcb_gcontext_t gc, cleargc; } B;
B bars[4] =
	{ (B){ .x=0,            .y=0,            .w=SCR_W,  .h=2*MARG, .l=SCR_W-2*CORN, .id=CLOCK }
	, (B){ .x=SCR_W-2*MARG, .y=0,            .w=2*MARG, .h=SCR_H,  .l=SCR_H-2*CORN, .id=VOL }
	, (B){ .x=0,            .y=SCR_H-2*MARG, .w=SCR_W,  .h=2*MARG, .l=SCR_W-2*CORN, .id=BATT }
	, (B){ .x=0,            .y=0,            .w=2*MARG, .h=SCR_H,  .l=SCR_H-2*CORN, .id=LIGHT }
	};

xcb_connection_t *c;
void line(B b,int x0, int y0, int dx, int dy) {
	xcb_poly_line(c,XCB_COORD_MODE_PREVIOUS,b.win,b.gc,2,(const xcb_point_t []){{x0,y0},{dx,dy}}); }

void draw() {
	FORB { xcb_poly_fill_rectangle(c,b->win,b->cleargc,1,(const xcb_rectangle_t[]){0,0,b->w,b->h});
		if (b->w>b->h) line(*b,CORN,MARG,b->l,0); else line(*b,MARG,CORN,0,b->l);
		int muted, percent, status, hh, mm, ss, now, hour=60*60, halfDay=hour*12; switch (b->id) {
		case CLOCK: SH("date +%H:%M:%S","%d:%d:%d",&hh,&mm,&ss); now=hh*hour+mm*60+ss;
			line(*b,CORN+now%halfDay*b->l/halfDay,MARG-PERP/2,0,PERP);
			line(*b,CORN+now%hour*b->l/hour,MARG-(PERP+4)/2,0,PERP+4); break;
		case VOL: SH("sndioctl -n output.mute","%d",&muted);
			if (!muted) { SH("sndioctl -n output.level","0.%d",&percent);
				line(*b,MARG-PERP/2,CORN+b->l-percent*b->l/1000,PERP,0); } break;
		case BATT: SH("apm -l","%d",&percent); SH("apm -b","%d",&status);
			int offsetX=status==3?5:0; // 3 = charging
			line(*b,CORN+(percent*b->l/100)+offsetX,MARG-PERP/2,-2*offsetX,PERP); break;
		case LIGHT: SH("xbacklight -get","%d",&percent);
			line(*b,MARG-PERP/2,CORN+b->l-b->l*percent/100,PERP,0);
		} } xcb_flush(c); }

int main() {
	c=xcb_connect(NULL,NULL); xcb_screen_t *scr=xcb_setup_roots_iterator(xcb_get_setup(c)).data;
	xcb_visualid_t visual; xcb_colormap_t colormap=xcb_generate_id(c);
	for (xcb_depth_iterator_t i=xcb_screen_allowed_depths_iterator(scr); i.rem; xcb_depth_next(&i))
		if (i.data->depth==32) visual=xcb_depth_visuals_iterator(i.data).data->visual_id; // 32 = alpha
  xcb_create_colormap(c,XCB_COLORMAP_ALLOC_NONE,colormap,scr->root,visual);

	FORB {
		b->win=xcb_generate_id(c); xcb_create_window(c,32,b->win,scr->root,b->x,b->y,b->w,b->h,0,
			XCB_WINDOW_CLASS_INPUT_OUTPUT,visual, XCB_CW_BACK_PIXEL|XCB_CW_BORDER_PIXEL|XCB_CW_COLORMAP,
			(const uint32_t[]){0,0,colormap});
		xcb_map_window(c, b->win); xcb_configure_window(c,b->win, // make cwm listen
			XCB_CONFIG_WINDOW_X|XCB_CONFIG_WINDOW_Y,(const uint32_t[]){b->x,b->y});
		xcb_change_property(c,XCB_PROP_MODE_REPLACE,b->win,XCB_ATOM_WM_NAME,XCB_ATOM_STRING,8,5,"rice");
		b->cleargc=xcb_generate_id(c); xcb_create_gc(c,b->cleargc,b->win,0,0); b->gc=xcb_generate_id(c);
		xcb_create_gc(c,b->gc,b->win,XCB_GC_FOREGROUND|XCB_GC_LINE_WIDTH|XCB_GC_CAP_STYLE,
			(const uint32_t[]){0xff504c45,5,XCB_CAP_STYLE_ROUND}); }

	for (struct timespec delay={.tv_nsec=1e9/4};;nanosleep(&delay,NULL)) draw(); }
