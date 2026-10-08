import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  // Fixed slots: numbered 1-4, then the named workspaces bound in
  // ~/.config/hypr/bindings.lua, labelled with their SUPER+<key> letter.
  readonly property var slots: [
    { name: "1", label: "1" },
    { name: "2", label: "2" },
    { name: "3", label: "3" },
    { name: "4", label: "4" },
    { name: "dev", label: "D" },
    { name: "www", label: "W" },
    { name: "comms", label: "I" },
    { name: "music", label: "M" },
    { name: "notes", label: "N" }
  ]

  function workspaceByName(name) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].name === name) return values[i]
    }

    return null
  }

  function focusWorkspace(name) {
    if (!root.bar) return
    var selector = /^[0-9]+$/.test(name) ? name : "name:" + name
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + selector + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.slots.length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.slots

      WidgetButton {
        required property var modelData

        readonly property var workspace: root.workspaceByName(modelData.name)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.name === modelData.name

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : modelData.label
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData.name) }
      }
    }
  }
}
