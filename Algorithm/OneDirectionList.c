//
//  OneDirectionList.c
//  Algorithm
//
//  Created by 谭智康 on 2017/5/15.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#include "OneDirectionList.h"
#include <string.h>
#include <stdlib.h>

void list_init(List *list, void (*destory)(void *data)) {
    list -> size = 0;
    list -> destory = destory;
    list -> head = NULL;
    list -> tail = NULL;
    return;
}

int list_rem_list(List *list, ListNode *node, void **data) {
    if(list->size == 0) {
        return -1;
    }
    
    ListNode *oldNode;
    if(node == NULL) {
        *data = list->head->data;
        oldNode = list->head;
        list->head = oldNode->next;
        if(list->size == 1) {
            list->tail = NULL;
        }
    } else {
        *data = node->next->data;
        oldNode = node->next;
        node->next = node->next->next;
        if(node->next == NULL) {
            list->tail = node;
        }
    }
    
    free(oldNode);
    list->size--;
    return 0;
}

void list_destory(List *list) {
    while (list -> size > 0) {
        void **data;
        if(list_rem_list(list, NULL, (void **)&data) == 0 || list->destory != NULL) {
            list->destory(data);
        }
    }
    memset(list, 0, sizeof(List));
    return;
}

int list_ins_list(List *list, ListNode *node, const void *data) {
    ListNode *newNode;
    if((newNode = (ListNode *)malloc(sizeof(ListNode))) == NULL) {
        return -1;
    }
    
    newNode -> data = (void *)data;
    if(node == NULL) {
        if(list_size(list) == 0) {
            // 头节点
            list->tail = newNode;
        }
        
        newNode->next = list->head;
        list->head = newNode;
    } else {
        if(node->next == NULL) {
            // 尾节点
            list->tail = newNode;
        }
        newNode->next = node->next;
        node->next = newNode;
    }
    list->size++;
    return 0;
}



