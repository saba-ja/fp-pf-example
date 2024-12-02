#include "Queue.hpp"

namespace Os {

    // Constructor: Initialize queue handle and message size to default values
    Queue::Queue() :
        m_handle(NULL),
        m_msgSize(0) { // Initialize m_msgSize to 0 which is needed to support msgSize function
    }

    // CreateInternal method: Creates a FreeRTOS queue
    // - name: The name of the queue
    // - depth: The maximum number of messages the queue can hold
    // - msgSize: The size of each message
    // Returns the status of queue creation
    Queue::QueueStatus Queue::createInternal(const Fw::StringBase &name, NATIVE_INT_TYPE depth, NATIVE_INT_TYPE msgSize) {
        this->m_name = "/QP_"; // Prefix queue name with "/QP_"
        this->m_name += name; // Append the given name
        QueueHandle_t xQueue;
        UBaseType_t uxQueueLength = depth; // Set queue length
        UBaseType_t uxItemSize = msgSize; // Set item size

        // Create FreeRTOS queue
        xQueue = xQueueCreate(uxQueueLength, uxItemSize);
        
        if (NULL == xQueue) {
            return QUEUE_UNINITIALIZED; // Return if queue creation failed
        }
        this->m_handle = xQueue; // Store the queue handle
        this->m_msgSize = msgSize; // Store message size to support msgSize F' function
        
        Queue::s_numQueues++; // Increment the number of queues

        return QUEUE_OK; // Return success
    }

    // Destructor: Deletes the FreeRTOS queue
    Queue::~Queue() {
        vQueueDelete(this->m_handle);
    }

    // Send method: Sends a message to the queue
    // - buffer: Pointer to the message buffer
    // - size: Size of the message
    // - priority: Priority of the message (not used in FreeRTOS)
    // - block: Whether the send should block if the queue is full
    // Returns the status of the send operation
    Queue::QueueStatus Queue::send(const U8* buffer, NATIVE_INT_TYPE size, NATIVE_INT_TYPE priority, QueueBlocking block) {
        QueueHandle_t queueHandle = this->m_handle;

        if (NULL == queueHandle) {
            return QUEUE_UNINITIALIZED;
        }
        
        if (NULL == buffer) {
            return QUEUE_EMPTY_BUFFER;
        }

        // Attempt to send the message to the queue, using portMAX_DELAY if blocking, otherwise a timeout of 0
        BaseType_t stat = xQueueSend(queueHandle, buffer, block == QUEUE_BLOCKING ? portMAX_DELAY : 0);
        if (stat != pdPASS) {
            return QUEUE_FULL; // Return if the queue is full
        }
       
        return QUEUE_OK; // Return success
    }

    // Receive method: Receives a message from the queue
    // - buffer: Pointer to the buffer to store the received message
    // - capacity: Capacity of the buffer
    // - actualSize: Actual size of the received message
    // - priority: Priority of the message (not used in FreeRTOS)
    // - block: Whether the receive should block if the queue is empty
    // Returns the status of the receive operation
    Queue::QueueStatus Queue::receive(U8* buffer, NATIVE_INT_TYPE capacity, NATIVE_INT_TYPE &actualSize, NATIVE_INT_TYPE &priority, QueueBlocking block) {
        QueueHandle_t queueHandle = this->m_handle;

        if (NULL == queueHandle) {
            return QUEUE_UNINITIALIZED;
        }

        // Attempt to receive the message
        BaseType_t stat = xQueueReceive(queueHandle, buffer, block == QUEUE_BLOCKING ? portMAX_DELAY : 0);
        if (stat != pdPASS) {
            return (block == QUEUE_NONBLOCKING) ? QUEUE_NO_MORE_MSGS : QUEUE_UNKNOWN_ERROR;
        }

        actualSize = this->m_msgSize; // Set actual size
        return QUEUE_OK; // Return success
    }

    // Get the number of messages in the queue
    // Returns the number of messages currently in the queue
    NATIVE_INT_TYPE Queue::getNumMsgs(void) const {
        QueueHandle_t queueHandle = this->m_handle;
        UBaseType_t numMsg = uxQueueMessagesWaiting(queueHandle);

        return (NATIVE_INT_TYPE) numMsg;
    }

    // Implementing the maximum number of messages the queue can hold
    // Returns the total capacity of the queue (number of messages it can hold)
    NATIVE_INT_TYPE Queue::getMaxMsgs(void) const {
        QueueHandle_t queueHandle = this->m_handle;
        // The maximum number of messages is the sum of messages waiting and spaces available
        return (NATIVE_INT_TYPE) (uxQueueSpacesAvailable(queueHandle) + uxQueueMessagesWaiting(queueHandle));
    }

    // Get the queue size (maximum number of messages queue can hold)
    // Returns the current total number of messages and available spaces in the queue
    NATIVE_INT_TYPE Queue::getQueueSize(void) const {
        QueueHandle_t queueHandle = this->m_handle;
        return (NATIVE_INT_TYPE)(uxQueueMessagesWaiting(queueHandle) + uxQueueSpacesAvailable(queueHandle));
    }

    // Implementing the message size for the queue
    // Returns the size of each message in the queue
    // Not a native FreeRTOS API function
    NATIVE_INT_TYPE Queue::getMsgSize(void) const {
        return this->m_msgSize; // Return stored message size
    }

}
