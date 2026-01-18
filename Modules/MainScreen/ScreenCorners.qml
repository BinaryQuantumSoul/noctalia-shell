import QtQuick
import QtQuick.Shapes
import qs.Commons

/**
* ScreenCorners - Shape component for rendering screen corners
*
* Renders concave corners at the screen edges to create a rounded screen effect.
* Self-contained Shape component (no shadows).
*/
Item {
  id: root

  anchors.fill: parent

  // Wrapper with layer caching to reduce GPU tessellation overhead
  Item {
    anchors.fill: parent
    // Cache the Shape to a texture to prevent continuous re-tessellation
    layer.enabled: true

    Shape {
      id: cornersShape

      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      enabled: false // Disable mouse input

      ShapePath {
        id: cornersPath

        // Corner configuration
        readonly property bool shouldShow: Settings.data.general.showScreenCorners
        readonly property color cornerColor: Settings.data.general.forceBlackScreenCorners ? "black" : Color.mSurface
        readonly property real borderThickness: Style.screenBorder
        readonly property real cornerRadius: Style.screenRadius

        // ShapePath configuration
        strokeWidth: -1 // No stroke, fill only
        fillColor: shouldShow ? cornerColor : "transparent"

        // Smooth color animation
        Behavior on fillColor {
          ColorAnimation {
            duration: Style.animationFast
          }
        }

        // Path
        PathSvg {
          path: {
            var d = ""; // svg path data

            var w = cornersShape.width;
            var h = cornersShape.height;
            var r = cornersPath.cornerRadius;
            var b = cornersPath.borderThickness;

            // Outer rectangle (full screen)
            d += `M 0 0 L ${w} 0 L ${w} ${h} L 0 ${h} Z `;
            // Inner rectangle with rounded corners (hole)
            d += `M ${b + r} ${b} `;
            d += `L ${w - b - r} ${b} `;
            d += `A ${r} ${r} 0 0 1 ${w - b} ${b + r} `;
            d += `L ${w - b} ${h - b - r} `;
            d += `A ${r} ${r} 0 0 1 ${w - b - r} ${h - b} `;
            d += `L ${b + r} ${h - b} `;
            d += `A ${r} ${r} 0 0 1 ${b} ${h - b - r} `;
            d += `L ${b} ${b + r} `;
            d += `A ${r} ${r} 0 0 1 ${b + r} ${b} `;
            d += `Z`;

            return d;
          }
        }
      }
    }
  }
}
