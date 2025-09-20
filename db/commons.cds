namespace anubhav.commons;
using { Currency } from '@sap/cds/common';

// Domain fixed values
type Gender : String(1) enum { 
    Male = 'M';
    Female = 'F';
    Undisclosed = 'U';
};
// when we put Amount in SAP, we always provide  a reference field - CurrencyCode
// When we put Quantity, we provide a reference field - UnitCode UOM
// @ - annotation
type AmountT: Decimal(10,2) @(
    Semantic.amount.currencyCode : 'CURRENCY_code',
    sap.unit: 'CURRENCY_code'
);

// aspects - reusable structures
aspect Amount {
    CURRENCY: Currency @title : '{i18n>XLBL_CURR}';
    GROSS_AMOUNT:AmountT @title : '{i18n>XLBL_GROSS}';
    NET_AMOUNT:AmountT @title : '{i18n>XLBL_NET}';
    TAX_AMOUNT:AmountT @title : '{i18n>XLBL_TAX}';
};


    // reusable types: which can refer in all tables
    // like a data element in SAP ABAP
    type Guid : String(32);

    // adding regular expression for validation
    // https://www.w3schools.com/js/js_regexp.asp
    // add phone number and email type with validation
    type PhoneNumber:String(30)@assert.format : '/^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{3,4}[-\s.]?[0-9]{0,4}$/';
    type EmailAddress: String(255); // @assert.format : '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    

// type UUID : String(36);
// type Email : String(255);
// type Phone : String(30);
// // type Currency : String(3);
// type Country : String(2);

// aspect Timestamps {
//     createdAt : Timestamp;
//     createdBy : String(100);
//     modifiedAt : Timestamp;
//     modifiedBy : String(100);
// }

// aspect IsActive {
//     isActive : Boolean default true;
// }