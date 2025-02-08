import { LightningElement, track } from 'lwc';
import {subscribe, unsubscribe, onError, setDebugFlag} from 'lightning/empApi';


export default class MostPublishedBooks extends LightningElement {
    @track books = [];
    subscription = {} ;

    channelName = '/event/MostPublishedBooks__e';

    columns = [
        { label: 'Title', fieldName: 'title', type: 'text', sortable: true},
        { label: 'Author', fieldName: 'author', type: 'text', sortable: true},
        { label: 'Edition', fieldName: 'edition', type: 'number', sortable: true },
        { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: true } 
    ];

    sortedBy = 'edition';
    sortedDirection = 'desc';

    connectedCallback() {
        this.subscribeToEvent();
    }

    disconnectedCallback() {
        this.unsubscribeFromEvent();
    }

    subscribeToEvent() {
        const messageCallback = (response) => {
            console.log('New Event Received: ', JSON.stringify(response));

            const eventData = response.data.payload;

            const newBook = {
                title: eventData.Title__c,
                author: eventData.Author__c,
                edition: eventData.Edition__c,
                publisher: eventData.Publisher__c
            };

            this.books = [...this.books, newBook];
            this.sortData(this.sortedBy, this.sortedDirection);
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            this.subscription = response;
            console.log('Subscription to platform event successful:', response);
        }).catch((error) => {
            console.error('Error subscribing to event:', error);
        });

        onError((error) => {
            console.error('EMP API error:', error);
        });
    }

    unsubscribeFromEvent() {
        unsubscribe(this.subscription, () => {
            console.log('Unsubscribed from platform event');
        }).catch((error) => {
            console.error('Error unsubscribing:', error);
        });
    }

    handleSort(event) {
        const{ fieldName, sortDirection} = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        this.sortData(fieldName, sortDirection);
    }

    sortData(fieldName, sortDirection) {
        const sortedBooks = [...this.books];

        sortedBooks.sort((a, b) => {
            let valueA = a[fieldName] || '';
            let valueB = b[fieldName] || '';

            if (typeof valueA === 'string') valueA = valueA.toLowerCase();
            if (typeof valueB === 'string') valueB = valueB.toLowerCase();

            return sortDirection === 'asc'
                ? valueA > valueB ? 1 : -1
                : valueA < valueB ? 1 : -1;
        });

        this.books = sortedBooks;
    }



}