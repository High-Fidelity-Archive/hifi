//
//  TabletLoginDialog.qml
//
//  Created by Vlad Stelmahovsky on 15 Mar 2017
//  Copyright 2017 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

import Hifi 1.0
import QtQuick 2.5

import "qrc:////qml//controls-uit" as HifiControlsUit
import "qrc:////qml//styles-uit" as HifiStylesUit
import "../windows" as Windows

import "../LoginDialog"

FocusScope {
    id: root
    objectName: "LoginDialog"
    visible: true

    anchors.fill: parent
    width: parent.width
    height: parent.height

    signal sendToScript(var message);
    property bool isHMD: false
    property bool gotoPreviousApp: false;

    property bool keyboardEnabled: false
    property bool keyboardRaised: false
    property bool punctuationMode: false
    property bool isPassword: false
    property alias text: loginKeyboard.mirroredText

    readonly property bool isTablet: true

    property int titleWidth: 0
    property string iconText: hifi.glyphs.avatar
    property int iconSize: 35

    property var pane: QtObject {
        property real width: root.width
        property real height: root.height
    }

    function tryDestroy() {
        canceled()
    }

    MouseArea {
        width: root.width
        height: root.height
    }

    property bool keyboardOverride: true

    property var items;
    property string label: ""

    property alias bodyLoader: bodyLoader
    property alias loginDialog: loginDialog
    property alias hifi: hifi

    HifiStylesUit.HifiConstants { id: hifi }

    readonly property int frameMarginTop: hifi.dimensions.modalDialogMargin.y

    LoginDialog {
        id: loginDialog

        anchors.fill: parent
        Loader {
            id: bodyLoader
            anchors.fill: parent
        }
    }

    HifiControlsUit.Keyboard {
        id: loginKeyboard
        raised: root.keyboardEnabled && root.keyboardRaised
        numeric: root.punctuationMode
        password: root.isPassword
        anchors {
            left: bodyLoader.left
            right: bodyLoader.right
            top: bodyLoader.bottom
        }
    }

    Keys.onPressed: {
        if (!visible) {
            return
        }

        if (event.modifiers === Qt.ControlModifier)
            switch (event.key) {
            case Qt.Key_A:
                event.accepted = true
                detailedText.selectAll()
                break
            case Qt.Key_C:
                event.accepted = true
                detailedText.copy()
                break
            case Qt.Key_Period:
                if (Qt.platform.os === "osx") {
                    event.accepted = true
                    content.reject()
                }
                break
        } else switch (event.key) {
            case Qt.Key_Enter:
            case Qt.Key_Return:
                event.accepted = true
                break
        }
    }
    Component.onCompleted: {
        bodyLoader.setSource("../LoginDialog/LinkAccountBody.qml", { "loginDialog": loginDialog, "root": root, "bodyLoader": bodyLoader });
    }
}
