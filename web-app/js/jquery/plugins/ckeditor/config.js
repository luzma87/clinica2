/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function (config) {
    // Define changes to default configuration here.
    // For the complete reference:
    // http://docs.ckeditor.com/#!/api/CKEDITOR.config

    config.language = 'es';
    config.contentsLanguage = 'es';

//    config.uiColor = '#3CA9E8';
    config.uiColor = '#9AB8F3';

    config.skin = 'moono_blue';

    config.toolbar = [
        [ 'Undo', 'Redo' ],
        [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript' ],
        [ 'NumberedList', 'BulletedList' , 'ListStyle', 'Outdent', 'Indent' ],
        [ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ],
        [ 'Find', 'Replace', 'SelectAll' ],
        [ 'TextColor', 'BGColor' ],
        '/',
        [ 'Format', 'Font', 'FontSize' ]
    ];
};
