// Augment Retry Wrapper
// This script adds automatic retry functionality to network requests in the Augment extension

(function() {
    console.log('[Augment Retry] Initializing retry wrapper');

    // Store original fetch function
    const originalFetch = window.fetch;

    // Maximum delay between retries (in milliseconds)
    const MAX_DELAY = 30000; // 30 seconds

    // Delay between retries (in milliseconds) - exponential backoff with a cap
    const getRetryDelay = (attempt) => Math.min(Math.pow(2, attempt) * 1000, MAX_DELAY);

    // Wrapper function with retry logic
    window.fetch = async function(...args) {
        let attempt = 0;

        while (true) { // Retry indefinitely
            try {
                console.log(`[Augment Retry] Request attempt ${attempt + 1}`);
                const response = await originalFetch.apply(this, args);

                // If response is not ok (status outside 200-299 range), throw an error to trigger retry
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }

                // If we get here, the request was successful
                if (attempt > 0) {
                    console.log(`[Augment Retry] Request succeeded after ${attempt + 1} attempts`);
                }
                return response;
            } catch (error) {
                console.error(`[Augment Retry] Attempt ${attempt + 1} failed:`, error);

                // Calculate delay with exponential backoff (capped)
                const delay = getRetryDelay(Math.min(attempt, 10)); // Cap the exponent to avoid extremely long delays
                console.log(`[Augment Retry] Retrying in ${delay}ms...`);
                await new Promise(resolve => setTimeout(resolve, delay));

                // Increment attempt counter for the next try
                attempt++;
            }
        }
    };

    // Also wrap XMLHttpRequest for completeness
    const originalXHROpen = XMLHttpRequest.prototype.open;
    const originalXHRSend = XMLHttpRequest.prototype.send;

    XMLHttpRequest.prototype.open = function(...args) {
        this._augmentRetryUrl = args[1]; // Store the URL for logging
        this._augmentRetryMethod = args[0]; // Store the method
        return originalXHROpen.apply(this, args);
    };

    XMLHttpRequest.prototype.send = function(...args) {
        const xhr = this;
        const originalOnError = xhr.onerror;
        const originalOnLoad = xhr.onload;

        let retryCount = 0;

        function setupRetry() {
            xhr.onerror = function(e) {
                // Always retry on error
                console.error(`[Augment Retry] XHR request failed (${xhr._augmentRetryMethod} ${xhr._augmentRetryUrl}), retrying (attempt ${retryCount + 1})...`);
                retryCount++;

                // Use exponential backoff with a cap
                const delay = getRetryDelay(Math.min(retryCount - 1, 10)); // Cap the exponent to avoid extremely long delays
                setTimeout(() => {
                    try {
                        originalXHROpen.call(xhr, xhr._augmentRetryMethod, xhr._augmentRetryUrl, true);
                        setupRetry();
                        originalXHRSend.apply(xhr, args);
                    } catch (err) {
                        console.error('[Augment Retry] Error during XHR retry:', err);
                        // Even if there's an error during retry setup, we'll try again
                        setTimeout(() => {
                            try {
                                originalXHROpen.call(xhr, xhr._augmentRetryMethod, xhr._augmentRetryUrl, true);
                                setupRetry();
                                originalXHRSend.apply(xhr, args);
                            } catch (innerErr) {
                                console.error('[Augment Retry] Second error during XHR retry:', innerErr);
                                // Still don't give up, just wait longer
                                setTimeout(() => xhr.onerror(e), delay * 2);
                            }
                        }, delay);
                    }
                }, delay);
            };

            xhr.onload = function(e) {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // Success! Call the original handler
                    if (retryCount > 0) {
                        console.log(`[Augment Retry] XHR request succeeded after ${retryCount + 1} attempts`);
                    }
                    if (originalOnLoad) originalOnLoad.call(xhr, e);
                } else {
                    // Non-2xx status code, retry
                    console.error(`[Augment Retry] XHR request returned error status ${xhr.status} (${xhr._augmentRetryMethod} ${xhr._augmentRetryUrl}), retrying (attempt ${retryCount + 1})...`);
                    retryCount++;

                    // Use exponential backoff with a cap
                    const delay = getRetryDelay(Math.min(retryCount - 1, 10)); // Cap the exponent to avoid extremely long delays
                    setTimeout(() => {
                        try {
                            originalXHROpen.call(xhr, xhr._augmentRetryMethod, xhr._augmentRetryUrl, true);
                            setupRetry();
                            originalXHRSend.apply(xhr, args);
                        } catch (err) {
                            console.error('[Augment Retry] Error during XHR retry:', err);
                            // Even if there's an error during retry setup, we'll try again
                            setTimeout(() => {
                                try {
                                    originalXHROpen.call(xhr, xhr._augmentRetryMethod, xhr._augmentRetryUrl, true);
                                    setupRetry();
                                    originalXHRSend.apply(xhr, args);
                                } catch (innerErr) {
                                    console.error('[Augment Retry] Second error during XHR retry:', innerErr);
                                    // Still don't give up, just wait longer
                                    setTimeout(() => xhr.onload(e), delay * 2);
                                }
                            }, delay);
                        }
                    }, delay);
                }
            };
        }

        setupRetry();
        return originalXHRSend.apply(this, args);
    };

    console.log('[Augment Retry] Retry wrapper initialized successfully');
})();
