sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"bd/po/managepo/test/integration/pages/POsList",
	"bd/po/managepo/test/integration/pages/POsObjectPage",
	"bd/po/managepo/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, POsList, POsObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('bd/po/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThePOsList: POsList,
			onThePOsObjectPage: POsObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

