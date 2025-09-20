using CatalogService as service from '../../srv/CatalogService';

annotate service.POs with @(
    UI.SelectionFields      : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        CURRENCY_code,
        OVERALL_STATUS
    ],
    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'boost',
            Inline: true,
            Action: 'CatalogService.boost'
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type      : 'UI.DataField',
            Criticality: IconColor,
            Value      : OverAllStatusText
        }
    ],
    UI.HeaderInfo           : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://64.media.tumblr.com/2dc0b0b510beda32eac86345f2e6039a/7dd1841e2a59bb74-39/s1280x1920/fcc67d9413345016c35f98dc459b051c6a93a30b.jpg'
    },
    UI.Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Order Details',
                    Target: '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Configuration Details',
                    Target: '@UI.FieldGroup#Spiderman',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target: '@UI.FieldGroup#Superman',
                },
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            Target: 'Items/@UI.LineItem',
        },
    ],
    UI.Identification       : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: LIFECYCLE_STATUS
        },
        {
            $Type: 'UI.DataFieldForAction',
            Label: 'BD Submit',
            Action: 'CatalogService.setDelivered'
        },
    ],
    UI.FieldGroup #Spiderman: {
        Label: 'Pricing',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT,
            },
        ],
    },
    UI.FieldGroup #Superman : {
        Label: 'Status Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code
            },
            {
                $Type: 'UI.DataField',
                Value: OVERALL_STATUS,
            },
        ],
    }

);

annotate service.POItems with @(
    UI.LineItem      : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
    ],
    UI.HeaderInfo: {
        TypeName: 'Order Item',
        TypeNamePlural: 'Order Items',
        Title: {Value:PO_ITEM_POS},
        Description: {Value:PRODUCT_GUID.ProductName}
    },
    UI.Facets: [
        {
            $Type:'UI.ReferenceFacet',
            Label: 'Item Details',
            Target:'@UI.Identification',
        },
        {
            $Type:'UI.ReferenceFacet',
            Label:'Product Details',
            Target:'@UI.FieldGroup#ProdInfo',
        },
    ],
    UI.Identification: [
        {
        $Type: 'UI.DataField',
        Value: PO_ITEM_POS,
        },
        {
        $Type: 'UI.DataField',
        Value: PRODUCT_GUID_NODE_KEY,
        },
        {
        $Type: 'UI.DataField',
        Value: GROSS_AMOUNT,
        },
        {
        $Type: 'UI.DataField',
        Value: NET_AMOUNT,
        },
        {
        $Type: 'UI.DataField',
        Value: TAX_AMOUNT,
        },
        {
        $Type: 'UI.DataField',
        Value: CURRENCY_code,
        },
     ],
     UI.FieldGroup#ProdInfo:{
        Label:'Product Info',
        Data:[
            {
                $Type:'UI.DataField',
                Value: PRODUCT_GUID.ProductId,
            },
            {
                $Type:'UI.DataField',
                Value: PRODUCT_GUID.ProductName,
            },
            {
                $Type:'UI.DataField',
                Value: PRODUCT_GUID.Category,
            },
            {
                $Type:'UI.DataField',
                Value: PRODUCT_GUID.SupplierName,
            },
        ]
     }
);

annotate service.POs with {
    PARTNER_GUID @(
        Common.Text:PARTNER_GUID.COMPANY_NAME,
        ValueList.entity:service.BusinessPartnerSet
    );
    OVERALL_STATUS @(
        Common.Text:OverAllStatusText
    )
    
};

annotate service.POItems with {
    PRODUCT_GUID @(
        Common.Text:PRODUCT_GUID.ProductName,
        ValueList.entity:service.ProductSet
    )   
};

// Define a value help from an entity
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[
        {
            $Type:'UI.DataField',
            Value: COMPANY_NAME
        }
    ]
);

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[
        {
            $Type:'UI.DataField',
            Value: ProductName
        }
    ]
);
