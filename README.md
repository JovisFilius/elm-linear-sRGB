# elm-linear-sRGB

The standard RGB encoding
([sRGB](https://en.wikipedia.org/wiki/SRGB#The_forward_transformation_.28CIE_xyY_or_CIE_XYZ_to_sRGB.29))
is the colorspace currently in use by the vast majority of programs and
websites. This encoding is not linear with respect to the perceived lightness
of the resulting color by the human eye. One consequence of this is that
(linear) interpolations between two sRGB-encoded color values tend to produce
murky intermediary colors with varying perceived lightness, since the color
values have already been non-linearly transformed to sRGB.

In contrast, after decoding sRGB values back to the
[CIE RGB](https://en.wikipedia.org/wiki/CIE_1931_color_space) 
space, linearly interpolating between the red, green and blue components yields
colors that all share the same perceived brightness.

## Visual comparison

![](greenToBlue.png)

In the above screenshot, the upper interpolation is the current 'standard'
interpolation applied to the sRGB-encoded values. The lower interpolation is
the interpolation applied after decoding the sRGB to (linear) CIE-space.

## Documentation

This package currently exports a single utility function that performs the
respective decoding and re-encoding from and to sRGB internally and yields true
linear interpolations between the given sRGB-encoded colors. The integer
argument determines the number of colors to be produced between the given start
and endpoint.

```elm
linearInterpolation : SRGB -> SRGB -> Int -> List SRGB

type alias SRGB = (Float, Float, Float)
```
