From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RFC][PATCH] radix_tree: radix_tree_gang_lookup_tag_slot may not
 return forever.
Date: Fri, 21 Jan 2011 15:34:31 +0900
Message-ID: <20110121153431.acd113d8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

I executed fsstress and then found that the system hung up.
At that time, I took the crash dump. Here is the backtrace of the process
which causes this hangup.

--- executed command -----------------------------------------------------
fsstress -d /mnt -n 600 -p 850
--------------------------------------------------------------------------

crash> bt
PID: 7947   TASK: ffff880160546a70  CPU: 0   COMMAND: "fsstress"
 #0 [ffff8800dfc07d00] machine_kexec at ffffffff81030db9
 #1 [ffff8800dfc07d70] crash_kexec at ffffffff810a7952
 #2 [ffff8800dfc07e40] oops_end at ffffffff814aa7c8
 #3 [ffff8800dfc07e70] die_nmi at ffffffff814aa969
 #4 [ffff8800dfc07ea0] do_nmi_callback at ffffffff8102b07b
 #5 [ffff8800dfc07f10] do_nmi at ffffffff814aa514
 #6 [ffff8800dfc07f50] nmi at ffffffff814a9d60
    [exception RIP: __lookup_tag+100]
    RIP: ffffffff812274b4  RSP: ffff88016056b998  RFLAGS: 00000287
    RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000006
    RDX: 000000000000001d  RSI: ffff88016056bb18  RDI: ffff8800c85366e0
    RBP: ffff88016056b9c8   R8: ffff88016056b9e8   R9: 0000000000000000
    R10: 000000000000000e  R11: ffff8800c8536908  R12: 0000000000000010
    R13: 0000000000000040  R14: ffffffffffffffc0  R15: ffff8800c85366e0
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #7 [ffff88016056b998] __lookup_tag at ffffffff812274b4
 #8 [ffff88016056b9d0] radix_tree_gang_lookup_tag_slot at ffffffff81227605
 #9 [ffff88016056ba20] find_get_pages_tag at ffffffff810fc110
#10 [ffff88016056ba80] pagevec_lookup_tag at ffffffff81105e85
#11 [ffff88016056baa0] write_cache_pages at ffffffff81104c47
#12 [ffff88016056bbd0] generic_writepages at ffffffff81105014
#13 [ffff88016056bbe0] do_writepages at ffffffff81105055
#14 [ffff88016056bbf0] __filemap_fdatawrite_range at ffffffff810fb2cb
#15 [ffff88016056bc40] filemap_write_and_wait_range at ffffffff810fb32a
#16 [ffff88016056bc70] generic_file_direct_write at ffffffff810fb3dc
#17 [ffff88016056bce0] __generic_file_aio_write at ffffffff810fcee5
#18 [ffff88016056bda0] generic_file_aio_write at ffffffff810fd085
#19 [ffff88016056bdf0] do_sync_write at ffffffff8114f9ea
#20 [ffff88016056bf00] vfs_write at ffffffff8114fcf8
#21 [ffff88016056bf30] sys_write at ffffffff81150691
#22 [ffff88016056bf80] system_call_fastpath at ffffffff8100c0b2

I think this root cause is the following:
 radix_tree_range_tag_if_tagged() always tags the root tag with settag
 if the root tag is set with iftag even if there are no iftag tags 
 in the specified range (Of course, there are some iftag tags 
 outside the specified range).

===============================================================================
[[[Detailed description]]]
----------------------------------------------------------------
(1) Why cannot radix_tree_gang_lookup_tag_slot() return forever?
----------------------------------------------------------------
__lookup_tag():
- Return with 0.
- Return with the index which is not bigger than the old one as the input 
  parameter.

Therefore the following "while" 
repeats forever because the above conditions cause "ret" not to be updated
and the cur_index cannot be changed into the bigger one.
(So, radix_tree_gang_lookup_tag_slot() cannot return forever.)
---
radix_tree_gang_lookup_tag_slot():
1178         while (ret < max_items) {
1179                 unsigned int slots_found;
1180                 unsigned long next_index;       /* Index of next search */
1181 
1182                 if (cur_index > max_index)
1183                         break;
1184                 slots_found = __lookup_tag(node, results + ret,
1185                                 cur_index, max_items - ret, &next_index,
tag);
1186                 ret += slots_found;	
			// cannot update ret because slots_found == 0.
			// so, this while loops forever.
1187                 if (next_index == 0)
1188                         break;
1189                 cur_index = next_index;
1190         }
---

-----------------------------------------------------------------------
(2) Why does __lookup_tag() return with 0 and doesn't update the index?
-----------------------------------------------------------------------
Assuming the following:
  - the one of the slot in radix_tree_node is NULL.
  - the one of the tag which corresponds to the slot sets with
    PAGECACHE_TAG_TOWRITE or other.
  - In a certain height(!=0), the corresponding index is 0.

a) __lookup_tag() notices that the tag is set.

1005 static unsigned int
1006 __lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
1007         unsigned int max_items, unsigned long *next_index, unsigned int tag)
1008 {
1009         unsigned int nr_found = 0;
1010         unsigned int shift, height;
1011 
1012         height = slot->height;
1013         if (height == 0)
1014                 goto out;
1015         shift = (height-1) * RADIX_TREE_MAP_SHIFT;
1016 
1017         while (height > 0) {
1018                 unsigned long i = (index >> shift) & RADIX_TREE_MAP_MASK ;
1019 
1020                 for (;;) {
1021                         if (tag_get(slot, tag, i))
1022                                 break;
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* the index is not updated yet.

b) __lookup_tag() notices that the slot is NULL.

1023                         index &= ~((1UL << shift) - 1);
1024                         index += 1UL << shift;
1025                         if (index == 0)
1026                                 goto out;       /* 32-bit wraparound */
1027                         i++;
1028                         if (i == RADIX_TREE_MAP_SIZE)
1029                                 goto out;
1030                 }
1031                 height--;
1032                 if (height == 0) {      /* Bottom level: grab some items */
...
1055                 }
1056                 shift -= RADIX_TREE_MAP_SHIFT;
1057                 slot = rcu_dereference_raw(slot->slots[i]);
1058                 if (slot == NULL)
1059                         break;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

c) __lookup_tag() doesn't update the index and return with 0.

1060         }
1061 out:
1062         *next_index = index;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1063         return nr_found;
1064 }

------------------------------------------------
(3) Why is the slot NULL even if the tag is set?
------------------------------------------------
Because radix_tree_range_tag_if_tagged() always sets the root tag with 
PAGECACHE_TAG_TOWRITE if the root tag is set with PAGECACHE_TAG_DIRTY,
even if there is no tag which can be set with PAGECACHE_TAG_TOWRITE
in the specified range (from *first_indexp to last_index). Of course,
some PAGECACHE_TAG_DIRTY nodes must exist outside the specified range.
(radix_tree_range_tag_if_tagged() is called only from tag_pages_for_writeback())

 640 unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root
*root,
 641                 unsigned long *first_indexp, unsigned long last_index,
 642                 unsigned long nr_to_tag,
 643                 unsigned int iftag, unsigned int settag)
 644 {
 645         unsigned int height = root->height;
 646         struct radix_tree_path path[height];
 647         struct radix_tree_path *pathp = path;
 648         struct radix_tree_node *slot;
 649         unsigned int shift;
 650         unsigned long tagged = 0;
 651         unsigned long index = *first_indexp;
 652 
 653         last_index = min(last_index, radix_tree_maxindex(height));
 654         if (index > last_index)
 655                 return 0;
 656         if (!nr_to_tag)
 657                 return 0;
 658         if (!root_tag_get(root, iftag)) {
 659                 *first_indexp = last_index + 1;
 660                 return 0;
 661         }
 662         if (height == 0) {
 663                 *first_indexp = last_index + 1;
 664                 root_tag_set(root, settag);
 665                 return 1;
 666         }
...
 733         root_tag_set(root, settag);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 734         *first_indexp = index;
 735 
 736         return tagged;
 737 }

As the result, there is no radix_tree_node which is set with 
PAGECACHE_TAG_TOWRITE but the root tag(radix_tree_root) is set with 
PAGECACHE_TAG_TOWRITE.

[figure: inside radix_tree]
(Please see the figure with typewriter font)
===========================================
          [roottag = DIRTY]
                 |             tag=0:NOTHING
         tag[0 0 0 1]              1:DIRTY
            [x x x +]              2:WRITEBACK
                   |               3:DIRTY,WRITEBACK
                   p               4:TOWRITE
             <--->                 5:DIRTY,TOWRITE ...
     specified range (index: 0 to 2)           

* There is no DIRTY tag within the specified range.
 (But there is a DIRTY tag outside that range.)

            | | | | | | | | |
    after calling tag_pages_for_writeback()
            | | | | | | | | |
            v v v v v v v v v

          [roottag = DIRTY,TOWRITE]
                 |                 p is "page".
         tag[0 0 0 1]              x is NULL.
            [x x x +]              +- is a pointer to "page".
                   |         
                   p        

* But TOWRITE tag is set on the root tag.
============================================

After that, radix_tree_extend() via radix_tree_insert() is called 
when the page is added.
This function sets the new radix_tree_node with PAGECACHE_TAG_TOWRITE
to succeed the status of the root tag.

 246 static int radix_tree_extend(struct radix_tree_root *root, unsigned long
index)
 247 {
 248         struct radix_tree_node *node;
 249         unsigned int height;
 250         int tag;
 251 
 252         /* Figure out what the height should be.  */
 253         height = root->height + 1;
 254         while (index > radix_tree_maxindex(height))
 255                 height++;
 256 
 257         if (root->rnode == NULL) {
 258                 root->height = height;
 259                 goto out;
 260         }
 261 
 262         do {
 263                 unsigned int newheight;
 264                 if (!(node = radix_tree_node_alloc(root)))
 265                         return -ENOMEM;
 266 
 267                 /* Increase the height.  */
 268                 node->slots[0] = radix_tree_indirect_to_ptr(root->rnode);
 269 
 270                 /* Propagate the aggregated tag info into the new root */
 271                 for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
 272                         if (root_tag_get(root, tag))
 273                                 tag_set(node, tag, 0);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 274                 }

===========================================
          [roottag = DIRTY,TOWRITE]
                 |     :       
         tag[0 0 0 1] [0 0 0 0]        
            [x x x +] [+ x x x]    
                   |   |     
                   p   p (new page)    

            | | | | | | | | |
    after calling radix_tree_insert
            | | | | | | | | |
            v v v v v v v v v

          [roottag = DIRTY,TOWRITE]
                 |                
         tag [5 0 0 0]    *  DIRTY and TOWRITE tags are
             [+ + x x]       succeeded to the new node.
              | |
  tag [0 0 0 1] [0 0 0 0]
      [x x x +] [+ x x x]          
             |   |      
             p   p    
============================================

After that, the index 3 page is released by remove_from_page_cache().
Then we can make the situation that the tag is set with PAGECACHE_TAG_TOWRITE 
and that the slot which corresponds to the tag is NULL.
===========================================
          [roottag = DIRTY,TOWRITE]
                 |                
         tag [5 0 0 0]    
             [+ + x x]    
              | |
  tag [0 0 0 1] [0 0 0 0]
      [x x x +] [+ x x x]          
             |   |      
             p   p    
         (remove)

            | | | | | | | | |
    after calling remove_page_cache
            | | | | | | | | |
            v v v v v v v v v

          [roottag = DIRTY,TOWRITE]
                 |                
         tag [4 0 0 0]      * Only DIRTY tag is cleared 
             [x + x x]        because no TOWRITE tag is existed 
                |             in the bottom node.
                [0 0 0 0]
                [+ x x x]          
                 |      
                 p    
============================================

-----------------------------------------------------------------
To solve this problem
-----------------------------------------------------------------
Change to that radix_tree_tag_if_tagged() doesn't tag the root tag 
if it doesn't set any tags within the specified range.

Like this.
============================================
 640 unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root
*root,
 641                 unsigned long *first_indexp, unsigned long last_index,
 642                 unsigned long nr_to_tag,
 643                 unsigned int iftag, unsigned int settag)
 644 {
 650         unsigned long tagged = 0;
...
 733 	     if (tagged)  
^^^^^^^^^^^^^^^^^^^^^^^^
 734            root_tag_set(root, settag);
 735         *first_indexp = index;
 736 
 737         return tagged;
 738 }

============================================

I made a fix patch for linux-2.6.38-rc1. 
Please confirm my hangup theory and the patch.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 lib/radix-tree.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 5086bb9..7ea2e03 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -736,10 +736,11 @@ next:
 		}
 	}
 	/*
-	 * The iftag must have been set somewhere because otherwise
-	 * we would return immediated at the beginning of the function
+	 * We need not to tag the root tag if there is no tag which is set with
+	 * settag within the range from *first_indexp to last_index.
 	 */
-	root_tag_set(root, settag);
+	if (tagged > 0)
+		root_tag_set(root, settag);
 	*first_indexp = index;
 
 	return tagged;
-- 
1.5.5.6
