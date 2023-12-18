# Alexandrie

There are two different computer graphics: vector and raster graphics. Raster
graphics represents images as a collection of pixels. Vector graphics is the use
of geometric primitives such as points, lines, curves, or polygons to represent
images. These primitives are created using mathematical equations.

Both types of computer graphics have advantages and disadvantages. The
advantages of vector graphics over raster are:

* smaller size,
* ability to zoom indefinitely,
* moving, scaling, filling, and rotating do not degrade the quality of an image.

    Ultimately, picture on a computer are displayed on a screen with a specific
    display dimension. However, while raster graphic doesn't scale very well
    when
    the resolution differ too much from the picture resolution, vector graphics
    are
    rasterized to fit the display they will appear on. Rasterization is the
    technique of taking an image described in a vector graphics format and
    transform
    it into a set of pixels for output on a screen.

    Enter Alexandrie, a vector based graphic API. Under the scene, it use the
    cairo
    graphic library for the rasterization phase.

    the surface is obviously the heavy object. The cairo context is just a
    storage
    for some info. Note that somecairo drawing callbacks get a cairo context as
    parameter, which is created by the lib.

    ## Example

    By the end of this chapter, you'll be able to understand the example bellow

    ```smalltalk

    ```

## Alexandrie drawing model

In order to explain the operations used by Alexandrie, we first delve into a
model of how Alexandrie models drawing. There are only a few concepts involved,
which are then applied over and over by the different methods. First I'll
describe the nouns: *destination*, *source*, *mask*, *path*, and *context*.
After that I'll describ the verbs which offer ways to manipulate the nouns and
draw the graphics you wish to create.

### Nouns

Cairo's nouns are somewhat abstract. To make them concrete I'm including
diagrams
that depict how they interact. The first three nouns are the three layers in the
diagrams you see in this section. The fourth noun, the path, is drawn on the
middle layer when it is relevant. The final noun, the context, isn't shown.

### Destination

The destination is the surface on which you're drawing. It may be tied to an
array of pixels like in this tutorial, or it might be tied to a SVG or PDF file,
or something else. This surface collects the elements of your graphic as you
apply
them, allowing you to build up a complex work as though painting on a canvas.

### Source

The source is the "paint" you're about to work with. I show this as it is—plain
black for several examples—but translucent to show lower layers. Unlike real
paint,
it doesn't have to be a single color; it can be a pattern or even a previously
created destination surface (see How do I paint from one surface to another?).
Also unlike real paint it can contain transparency information—the Alpha
channel.

### Path

The path is somewhere between part of the mask and part of the context. I will
show it as thin green lines on the mask layer. It is manipulated by path verbs,
then used by drawing verbs.

### Context

The context keeps track of everything that verbs affect. It tracks one source,
one destination, and one mask. It also tracks several helper variables like
your line width and style, your font face and size, and more. Most importantly
it tracks the path, which is turned into a mask by drawing verbs.

Before you can start to draw something with cairo, you need to create the
context.
The context is stored in cairo's central data type, called cairo_t. When you
create a cairo context, it must be tied to a specific surface—for example, an
image surface if you want to create a PNG file. There is also a data type for
the surface, called cairo_surface_t. You can initialize your cairo context
like this:

```smalltalk
surface := AeCairoImageSurface
extent: 120@120
format: AeCairoSurfaceFormat argb32.
context := surface newContext.
```

The cairo context in this example is tied to an image surface of dimension
120 x 120 and 32 bits per pixel to store RGB and Alpha information. Surfaces can
be created specific to most Alexandrie backends

### Verbs

The reason you are using cairo in a program is to draw. Cairo internally draws
with one fundamental drawing operation: the source and mask are freely placed
somewhere over the destination. Then the layers are all pressed together and the
paint from the source is transferred to the destination wherever the mask allows
it. To that extent the following five drawing verbs, or operations, are all
similar. They differ by how they construct the mask.

### Stroke

The cairo_stroke() operation takes a virtual pen along the path. It allows the
source to transfer through the mask in a thin (or thick) line around the path,
according to the pen's line width, dash style, and line caps.

Note: To see the code snippet in action, use the stroke.c file linked from the
figure to the right. Just pasting the snippet into the FAQ's hello.c might give
unexpected results due to different scaling. Read on; scaling is explained in
section Working with Transforms below.

cairo_set_line_width (cr, 0.1);
cairo_set_source_rgb (cr, 0, 0, 0);
cairo_rectangle (cr, 0.25, 0.25, 0.5, 0.5);
cairo_stroke (cr);

![line path](figures/linepath.png)

### Fill

The cairo_fill() operation instead uses the path like the lines of a coloring
book, and allows the source through the mask within the hole whose boundaries
are the path. For complex paths (paths with multiple closed sub-paths—like a
donut—or paths that self-intersect) this is influenced by the fill rule. Note
that while stroking the path transfers the source for half of the line width on
each side of the path, filling a path fills directly up to the edge of the path
and no further.

cairo_set_source_rgb (cr, 0, 0, 0);
cairo_rectangle (cr, 0.25, 0.25, 0.5, 0.5);
cairo_fill (cr);

![fill example](figures/fillpaint.png)

### Show Text / Glyphs

The cairo_show_text() operation forms the mask from text. It may be easier to
think of cairo_show_text() as a shortcut for creating a path with
cairo_text_path()
and then using cairo_fill() to transfer it. Be aware cairo_show_text() caches
glyphs so is much more efficient if you work with a lot of text.

cairo_text_extents_t te;
cairo_set_source_rgb (cr, 0.0, 0.0, 0.0);
cairo_select_font_face (cr, "Georgia",
CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
cairo_set_font_size (cr, 1.2);
cairo_text_extents (cr, "a", &te);
cairo_move_to (cr, 0.5 - te.width / 2 - te.x_bearing,
0.5 - te.height / 2 - te.y_bearing);
cairo_show_text (cr, "a");

### Paint

The cairo_paint() operation uses a mask that transfers the entire source to the
destination. Some people consider this an infinitely large mask, and others
consider it no mask; the result is the same. The related operation
cairo_paint_with_alpha() similarly allows transfer of the full source to
destination, but it transfers only the provided percentage of the color.

cairo_set_source_rgb (cr, 0.0, 0.0, 0.0);
cairo_paint_with_alpha (cr, 0.5);

### Mask

The mask is the most important piece: it controls where you apply the source to
the destination. I will show it as a yellow layer with holes where it lets the
source through. When you apply a drawing verb, it's like you stamp the source
to the destination. Anywhere the mask allows, the source is copied. Anywhere the
mask disallows, nothing happens.### Mask

The cairo_mask() and cairo_mask_surface() operations allow transfer according
to the transparency/opacity of a second source pattern or surface. Where the
pattern or surface is opaque, the current source is transferred to the
destination.
Where the pattern or surface is transparent, nothing is transferred.

cairo_pattern_t *linpat,*radpat;
linpat = cairo_pattern_create_linear (0, 0, 1, 1);
cairo_pattern_add_color_stop_rgb (linpat, 0, 0, 0.3, 0.8);
cairo_pattern_add_color_stop_rgb (linpat, 1, 0, 0.8, 0.3);

radpat = cairo_pattern_create_radial (0.5, 0.5, 0.25, 0.5, 0.5, 0.75);
cairo_pattern_add_color_stop_rgba (radpat, 0, 0, 0, 0, 1);
cairo_pattern_add_color_stop_rgba (radpat, 0.5, 0, 0, 0, 0);

cairo_set_source (cr, linpat);
cairo_mask (cr, radpat)
