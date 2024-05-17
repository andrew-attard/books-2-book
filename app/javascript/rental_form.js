document.addEventListener('DOMContentLoaded', () => {
  const startDateInput = document.querySelector("[data-flatpickr-target='startTime']");
  const endDateInput = document.querySelector("[data-flatpickr-target='endTime']");
  const submitButton = document.querySelector('.submit-btn');

  // Function to enable/disable the submit button based on date selection
  const toggleSubmitButton = () => {
    const startDate = new Date(startDateInput.value);
    const endDate = new Date(endDateInput.value);
    if (endDate < startDate) {
      submitButton.disabled = true; // Disable submit button for negative date range
    } else {
      submitButton.disabled = false; // Enable submit button
    }
  };

  // Event listeners for date inputs
  startDateInput.addEventListener('change', toggleSubmitButton);
  endDateInput.addEventListener('change', toggleSubmitButton);
});

document.addEventListener("DOMContentLoaded", function() {
  var rentedDates = <%= raw @rented_dates.to_json %>; // Convert Ruby array to JavaScript array

  flatpickr("#startTime", {
    // Other options
    disable: rentedDates
  });

  flatpickr("#endTime", {
    // Other options
    disable: rentedDates
  });
});
