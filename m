From: akpm@linux-foundation.org
Subject: [patch 1/8] ext4: fix MB_DEBUG format warnings
Date: Thu, 29 Nov 2007 12:52:48 -0800
Message-ID: <200711292052.lATKqmNQ006825@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, sandeen@redhat.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbXK2UyE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

(applies at end of current ext4 patch series)

Fix a slew of compile warnings from mismatched format specifiers
when MB_DEBUG is turned on.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-fix-mb_debug-format-warnings fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fix-mb_debug-format-warnings
+++ a/fs/ext4/mballoc.c
@@ -954,7 +954,7 @@ static int ext4_mb_init_cache(struct pag
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
-		mb_debug("read bitmap for group %u\n", first_group + i);
+		mb_debug("read bitmap for group %lu\n", first_group + i);
 	}
 
 	/* wait for I/O completion */
@@ -2670,7 +2670,7 @@ static void ext4_mb_free_committed_block
 		if (md == NULL)
 			break;
 
-		mb_debug("gonna free %u blocks in group %u (0x%p):",
+		mb_debug("gonna free %u blocks in group %lu (0x%p):",
 				md->num, md->group, md);
 
 		err = ext4_mb_load_buddy(sb, md->group, &e4b);
@@ -3029,7 +3029,7 @@ static void ext4_mb_normalize_group_requ
 
 	BUG_ON(lg == NULL);
 	ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
-	mb_debug("#%u: goal %u blocks for locality group\n",
+	mb_debug("#%u: goal %lu blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
 
@@ -3255,7 +3255,7 @@ static void ext4_mb_use_inode_pa(struct 
 	BUG_ON(pa->pa_free < len);
 	pa->pa_free -= len;
 
-	mb_debug("use %lu/%lu from inode pa %p\n", start, len, pa);
+	mb_debug("use %llu/%lu from inode pa %p\n", start, len, pa);
 }
 
 /*
@@ -3282,7 +3282,7 @@ static void ext4_mb_use_group_pa(struct 
 	 * pa and think that it have enought free blocks if we
 	 * don't update pa_free here right ?
 	 */
-	mb_debug("use %lu/%lu from group pa %p\n", pa->pa_lstart-len, len, pa);
+	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
 }
 
 /*
@@ -3513,7 +3513,7 @@ static int ext4_mb_new_inode_pa(struct e
 	pa->pa_deleted = 0;
 	pa->pa_linear = 0;
 
-	mb_debug("new inode pa %p: %lu/%lu for %lu\n", pa,
+	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 
 	ext4_mb_use_inode_pa(ac, pa);
@@ -3569,7 +3569,7 @@ static int ext4_mb_new_group_pa(struct e
 	pa->pa_deleted = 0;
 	pa->pa_linear = 1;
 
-	mb_debug("new group pa %p: %lu/%lu for %lu\n", pa,
+	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 
 	ext4_mb_use_group_pa(ac, pa);
@@ -4072,8 +4072,8 @@ static int ext4_mb_initialize_context(st
 	 * locality group. this is a policy, actually */
 	ext4_mb_group_or_file(ac);
 
-	mb_debug("init ac: %u blocks @ %llu, goal %llu, flags %x, 2^%d, "
-			"left: %llu/%llu, right %llu/%llu to %swritable\n",
+	mb_debug("init ac: %u blocks @ %u, goal %u, flags %x, 2^%d, "
+			"left: %u/%u, right %u/%u to %swritable\n",
 			(unsigned) ar->len, (unsigned) ar->logical,
 			(unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
 			(unsigned) ar->lleft, (unsigned) ar->pleft,
@@ -4288,7 +4288,7 @@ static int ext4_mb_free_metadata(handle_
 				page_cache_get(e4b->bd_bitmap_page);
 				db->bb_md_cur = md;
 				db->bb_tid = handle->h_transaction->t_tid;
-				mb_debug("new md 0x%p for group %u\n",
+				mb_debug("new md 0x%p for group %lu\n",
 						md, md->group);
 			} else {
 				kfree(md);
_
