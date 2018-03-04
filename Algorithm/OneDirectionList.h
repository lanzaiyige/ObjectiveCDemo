//
//  OneDirectionList.h
//  Algorithm
//
//  Created by 谭智康 on 2017/5/15.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#ifndef OneDirectionList_h
#define OneDirectionList_h

#include <stdio.h>

#endif /* OneDirectionList_h */

typedef struct ListNode {
    void *data;
    struct ListNode *next;
} ListNode;

typedef struct List {
    int size;
    int (*match)(const void *key1, const void *key2);
    
    void (*destory)(void *data);
    ListNode *head;
    ListNode *tail;
} List;

void list_init(List *list, void (*destory)(void *data));

void list_destory(List *list);

int list_ins_list(List *list, ListNode *node, const void *data);

int list_rem_list(List *list, ListNode *node, void **data);

#define list_size(list) ((list) -> size)

#define list_head(list) ((list) -> head)

#define list_tail(list) ((list) -> tail)

#define list_is_head(list,node) ((node) == (list)->head ? 1 : 0)

#define list_is_tail(list,node) ((node) == (list)->tail ? 1 : 0)

#define list_data(node) ((node)->data)

#define list_next(node) ((node)->next)
