// Displays the billing address and Current weather field on Account
// Handles the update of Current_Weather__c field if the billing address is changed

import { LightningElement, api, track, wire } from "lwc";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import BILLING_CITY from "@salesforce/schema/Account.BillingCity";
import BILLING_STREET from "@salesforce/schema/Account.BillingStreet";
import BILLING_STATE from "@salesforce/schema/Account.BillingState";
import BILLING_POSTAL_CODE from "@salesforce/schema/Account.BillingPostalCode";
import BILLING_COUNTRY from "@salesforce/schema/Account.BillingCountry";
import ID_FIELD from "@salesforce/schema/Account.Id";
import CURRENT_WEATHER from "@salesforce/schema/Account.Current_Weather__c";

const fields = [
  BILLING_CITY,
  BILLING_COUNTRY,
  BILLING_POSTAL_CODE,
  BILLING_STATE,
  BILLING_STREET
];

export default class Ac_weatherInfo extends LightningElement {
  @api recordId;
  @track billingCity;
  @track billingStreet;
  @track billingState;
  @track billingPostalCode;
  @track billingCountry;
  @track currentWeather;
  apiKey = "d283e155bc873b33808fdd07c0e65232";
  recordUpdated = false;

  @wire(getRecord, { recordId: "$recordId", fields })
  accountInfo({ error, data }) {
    if (data) {
      this.recordUpdated = false;
      this.billingCity = getFieldValue(data, BILLING_CITY);
      this.billingStreet = getFieldValue(data, BILLING_STREET);
      this.billingState = getFieldValue(data, BILLING_STATE);
      this.billingPostalCode = getFieldValue(data, BILLING_POSTAL_CODE);
      this.billingCountry = getFieldValue(data, BILLING_COUNTRY);

      // Set the request end point based on the BillingCity field
      let requestEndPoint =
        "https://api.openweathermap.org/data/2.5/weather?q=" +
        this.billingCity +
        "&appid=" +
        this.apiKey;

      // Fetch and update the weather description
      fetch(requestEndPoint, {
        method: "GET"
      })
        .then((response) => response.json())
        .then((weatherInfo) => {
          this.currentWeather = weatherInfo.weather[0].description;
        })
        .then(() => {
          if (!this.recordUpdated) {
            this.updateWeather(this.recordId, this.currentWeather);
            this.recordUpdated = true;
          }
        });
    } else if (error) {
      console.log("error: " + error);
    }
  }

  // Handles the update of the Current_Weather__c field
  updateWeather(id, currentWeather) {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = id;
    fields[CURRENT_WEATHER.fieldApiName] = currentWeather;
    const recordInput = {
      fields
    };
    updateRecord(recordInput)
      .then(() => {})
      .catch((error) => {
        console.log("error: " + error);
      });
  }
}
