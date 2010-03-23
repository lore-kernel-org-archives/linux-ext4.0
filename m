From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
	ext4_mb_regular_allocator()
Date: Tue, 23 Mar 2010 20:40:29 +0800
Message-ID: <ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
	 <20100322182645.GI11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33182 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0CWMkc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2010 08:40:32 -0400
Received: by gwaa18 with SMTP id a18so1464726gwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 23 Mar 2010 05:40:31 -0700 (PDT)
In-Reply-To: <20100322182645.GI11560@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/23, tytso@mit.edu <tytso@mit.edu>:
> On Mon, Mar 22, 2010 at 10:35:54PM +0800, jing zhang wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Mon Mar 22 22:20:38     2010
>>
>> 1, In one of the hot functions in mballoc.c, unnecessary operation on
>>        struct ext4_group_desc *desc;
>>     is removed.

---

diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc5.c
index bba1282..fb18199 100644
--- a/linux-2.6.32/fs/ext4/mballoc.c
+++ b/ext4_mm_leak/mballoc5.c
@@ -2027,7 +2027,6 @@ repeat:

 		for (i = 0; i < ngroups; group++, i++) {
 			struct ext4_group_info *grp;
-			struct ext4_group_desc *desc;

 			if (group == ngroups)
 				group = 0;
@@ -2050,7 +2049,6 @@ repeat:
 			}

 			ac->ac_groups_scanned++;
-			desc = ext4_get_group_desc(sb, group, NULL);
 			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&


>> 2, Unlike spin_lock() and spin_unlock(), ext4_mb_load_buddy() is
>> companied by ext4_mb_release_desc. And it is hard, at least for me, to
>> get sure that ext4_mb_release_desc has little to do with struct
>> ext4_group_desc, and for those readers as well, whose native language
>> is not English. It seems the choice includes
>>      ext4_mb_release_buddy
>>      ext4_mb_put_buddy
>>      ext4_mb_unload_buddy
>> and I like the last one.

---

diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc4.c
index bba1282..45d78a9 100644
--- a/linux-2.6.32/fs/ext4/mballoc.c
+++ b/ext4_mm_leak/mballoc4.c
@@ -1150,7 +1150,7 @@ err:
 	return ret;
 }

-static void ext4_mb_release_desc(struct ext4_buddy *e4b)
+static void ext4_mb_unload_buddy(struct ext4_buddy *e4b)
 {
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
@@ -1618,7 +1618,7 @@ int ext4_mb_try_best_found(struct
ext4_allocation_context *ac,
 	}

 	ext4_unlock_group(ac->ac_sb, group);
-	ext4_mb_release_desc(e4b);
+	ext4_mb_unload_buddy(e4b);

 	return 0;
 }
@@ -1674,7 +1674,7 @@ int ext4_mb_find_by_goal(struct
ext4_allocation_context *ac,
 		ext4_mb_use_best_found(ac, e4b);
 	}
 	ext4_unlock_group(ac->ac_sb, group);
-	ext4_mb_release_desc(e4b);
+	ext4_mb_unload_buddy(e4b);

 	return 0;
 }
@@ -2045,7 +2045,7 @@ repeat:
 			if (!ext4_mb_good_group(ac, group, cr)) {
 				/* someone did allocation from this group */
 				ext4_unlock_group(sb, group);
-				ext4_mb_release_desc(&e4b);
+				ext4_mb_unload_buddy(&e4b);
 				continue;
 			}

@@ -2060,7 +2060,7 @@ repeat:
 				ext4_mb_complex_scan_group(ac, &e4b);

 			ext4_unlock_group(sb, group);
-			ext4_mb_release_desc(&e4b);
+			ext4_mb_unload_buddy(&e4b);

 			if (ac->ac_status != AC_STATUS_CONTINUE)
 				break;
@@ -2150,7 +2150,7 @@ static int ext4_mb_seq_groups_show(struct
seq_file *seq, void *v)
 	ext4_lock_group(sb, group);
 	memcpy(&sg, ext4_get_group_info(sb, group), i);
 	ext4_unlock_group(sb, group);
-	ext4_mb_release_desc(&e4b);
+	ext4_mb_unload_buddy(&e4b);

 	seq_printf(seq, "#%-5u: %-5u %-5u %-5u [", group, sg.info.bb_free,
 			sg.info.bb_fragments, sg.info.bb_first_free);
@@ -2567,7 +2567,7 @@ static void release_blocks_on_commit(journal_t
*journal, transaction_t *txn)
 		sb_issue_discard(sb, discard_block, entry->count);

 		kmem_cache_free(ext4_free_ext_cachep, entry);
-		ext4_mb_release_desc(&e4b);
+		ext4_mb_unload_buddy(&e4b);
 	}

 	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
@@ -3692,7 +3692,7 @@ out:
 	ext4_unlock_group(sb, group);
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
-	ext4_mb_release_desc(&e4b);
+	ext4_mb_unload_buddy(&e4b);
 	put_bh(bitmap_bh);
 	return free;
 }
@@ -3796,7 +3796,7 @@ repeat:
 		if (bitmap_bh == NULL) {
 			ext4_error(sb, __func__, "Error in reading block "
 					"bitmap for %u", group);
-			ext4_mb_release_desc(&e4b);
+			ext4_mb_unload_buddy(&e4b);
 			continue;
 		}

@@ -3805,7 +3805,7 @@ repeat:
 		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
 		ext4_unlock_group(sb, group);

-		ext4_mb_release_desc(&e4b);
+		ext4_mb_unload_buddy(&e4b);
 		put_bh(bitmap_bh);

 		list_del(&pa->u.pa_tmp_list);
@@ -4069,7 +4069,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 		ext4_mb_release_group_pa(&e4b, pa, ac);
 		ext4_unlock_group(sb, group);

-		ext4_mb_release_desc(&e4b);
+		ext4_mb_unload_buddy(&e4b);
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
@@ -4570,7 +4570,7 @@ do_more:
 		atomic_add(count, &sbi->s_flex_groups[flex_group].free_blocks);
 	}

-	ext4_mb_release_desc(&e4b);
+	ext4_mb_unload_buddy(&e4b);

 	*freed += count;



> Please separate things like this into two separate patches; it makes
> them much easier to review.
>
> Thanks,
>
> 					- Ted
>
