//
//  KKMemoryCache.m
//  Algorithm
//
//  Created by tanzhikang on 2018/1/23.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "KKMemoryCache.h"
#import <pthread.h>

@interface _KKLinkedMapNode : NSObject

@end

@implementation _KKLinkedMapNode {
    @package
    __unsafe_unretained _KKLinkedMapNode *prev;
    __unsafe_unretained _KKLinkedMapNode *next;
    id _key;
    id _value;
    NSUInteger _cost;
    NSTimeInterval _time;
}
@end

@interface _KKLinkedMap : NSObject {
    CFMutableDictionaryRef _dic;
    NSUInteger _totalCost;
    NSUInteger _totalCount;
    _KKLinkedMapNode *_head;
    _KKLinkedMapNode *_tail;
    BOOL _releaseOnMainThread;
    BOOL _releaseAsynchronously;
}

- (void)insertNodeAtHead:(_KKLinkedMapNode *)node;

- (void)bringNodeToHead:(_KKLinkedMapNode *)node;

- (void)removeNode:(_KKLinkedMapNode *)node;

- (_KKLinkedMapNode *)removeTailNode;

- (void)removeAll;
@end

@implementation _KKLinkedMap

- (instancetype)init {
    self = [super init];
    
    _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    return self;
}

- (void)dealloc {
    CFRelease(_dic);
}

- (void)insertNodeAtHead:(_KKLinkedMapNode *)node {
    CFDictionarySetValue(_dic, (__bridge const void *)node->_key, (__bridge const void *)node);
    
    _totalCost += node->_cost;
    _totalCount++;
    if(_head) {
        _head->prev = node;
        node->next = _head;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

- (void)bringNodeToHead:(_KKLinkedMapNode *)node {
    if(_head == node) return;
    
    if(_tail == node) {
        _tail = node->prev;
        _tail = nil;
    } else {
        node->prev->next = node->next;
        node->next->prev = node->prev;
    }
    
    node->prev = nil;
    node->next = _head;
    _head->prev = node;
    _head = node;
}

- (void)removeNode:(_KKLinkedMapNode *)node {
    CFDictionaryRemoveValue(_dic, (__bridge const void *)node->_key);
    _totalCount--;
    _totalCost -= node->_cost;
    
    if(node == _head) _head = node->next;
    if(node == _tail) _tail = node->prev;
    
    if(node->prev) node->prev->next = node->next;
    if(node->next) node->next->prev = node->prev;
}

- (_KKLinkedMapNode *)removeTailNode {
    if(!_head) return nil;
    CFDictionaryRemoveValue(_dic, (__bridge const void *)_tail->_key);
    
    _KKLinkedMapNode *node = _tail;
    if(_head == _tail) {
        _head = _tail = nil;
    } else {
        _tail = node->prev;
        _tail->next = nil;
    }
    
    return node;
}

- (void)removeAll {
    CFDictionaryRemoveAllValues(_dic);
    _totalCount = 0;
    _totalCost = 0;
    
    _head = nil;
    _tail = nil;
    
    if(CFDictionaryGetCount(_dic) > 0) {
        CFMutableDictionaryRef holder = _dic;
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        if(_releaseAsynchronously) {
            
        } else if(_releaseOnMainThread && !pthread_main_np()) {
            
        }
    }
}

@end

@implementation KKMemoryCache {
    pthread_mutex_t _lock;
    _KKLinkedMap *_lru;
    dispatch_queue_t _queue;
}

- (instancetype)init {
    self = [super init];
    pthread_mutex_init(&_lock, NULL);
    _queue = dispatch_queue_create("com.ibireme.cache.memory", DISPATCH_QUEUE_SERIAL);
    _lru = [_KKLinkedMap new];
    [self _trimRecursively];
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)_trimRecursively {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
        });
    });
}

- (void)_trimBackground {
    
}

@end
