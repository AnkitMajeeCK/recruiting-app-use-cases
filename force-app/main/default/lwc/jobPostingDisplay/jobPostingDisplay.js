import { LightningElement, wire, track } from 'lwc';
import getActiveJobPostings from '@salesforce/apex/JobPostingController.getActiveJobPostings';

export default class JobPostings extends LightningElement {
    @track jobPostings = [];
    @track filteredJobPostings = [];
    @track displayedJobPostings = [];
    @track selectedDepartment = ''; // Default value for filter
    @track sortBy = 'Name'; // Default sort field
    @track sortDirection = 'asc'; // Default sort direction
    @track recordsToShow = 5; // Number of records to show initially

    departmentOptions = [
        { label: 'All Departments', value: '' },
        { label: 'Information technology', value: 'Information technology' },
        { label: 'Finance', value: 'Finance' },
        { label: 'Human Resources', value: 'Human Resources' },
        { label: 'Miscellaneous', value: 'Miscellaneous' },
        { label: 'Retail Operation', value: 'Retail Operations' },
        { label: 'Warehouseing', value: 'Warehouseing' }
    ];

    columns = [
        { 
            label: 'Job Title', 
            fieldName: 'Name', 
            sortable: true, 
            type: 'text', 
            initialWidth: 200, 
            typeAttributes: { 
                label: { fieldName: 'Name' }, 
                target: '_blank' 
            }
        },
        { label: 'Location', fieldName: 'Location__c', type: 'text' },
        { label: 'Department', fieldName: 'Functional_Area__c', type: 'text' },
        { label: 'Open Positions', fieldName: 'Number_of_Open_Position__c', type: 'number' },
        { label: 'Posting Date', fieldName: 'Open_Date__c', type: 'date', sortable: true }
    ];

    @wire(getActiveJobPostings)
    wiredJobPostings({ error, data }) {
        if (data) {
            this.jobPostings = data;
            this.applyFilters();
        } else if (error) {
            console.error('Error fetching job postings', error);
        }
    }

    handleDepartmentChange(event) {
        this.selectedDepartment = event.target.value;
        this.recordsToShow = 5;  // Reset count on filter change
        this.applyFilters();
    }

    handleSort(event) {
        const field = event.detail.fieldName;  // Correct way to get sorted field
        const direction = event.detail.sortDirection;
        this.sortBy = field;
        this.sortDirection = direction;

        this.recordsToShow = 5; // Reset count on sort change
        this.applyFilters();
    }

    applyFilters() {
        let filteredData = this.jobPostings;

        if (this.selectedDepartment) {
            filteredData = filteredData.filter(job => job.Functional_Area__c === this.selectedDepartment);
        }

        // Sort filtered data
        filteredData = this.sortData(filteredData);

        this.filteredJobPostings = filteredData;

        // Limit displayed data based on recordsToShow
        this.displayedJobPostings = this.filteredJobPostings.slice(0, this.recordsToShow);
    }

    sortData(data) {
        const sortedData = [...data];

        sortedData.sort((a, b) => {
            let fieldA = this.sortBy === 'Name' ? a.Name : a.Open_Date__c;
            let fieldB = this.sortBy === 'Name' ? b.Name : b.Open_Date__c;

            // For dates, parse to date objects to ensure correct sorting
            if (this.sortBy === 'Open_Date__c') {
                fieldA = new Date(fieldA);
                fieldB = new Date(fieldB);
            }

            if (this.sortDirection === 'asc') {
                return fieldA > fieldB ? 1 : (fieldA < fieldB ? -1 : 0);
            } else {
                return fieldA < fieldB ? 1 : (fieldA > fieldB ? -1 : 0);
            }
        });

        return sortedData;
    }

    handleShowMore() {
        this.recordsToShow += 5;
        this.displayedJobPostings = this.filteredJobPostings.slice(0, this.recordsToShow);
    }

    get showMoreButtonVisible() {
        return this.recordsToShow < this.filteredJobPostings.length;
    }
}
