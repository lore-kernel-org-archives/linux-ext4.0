From: Solofo.Ramangalahy@bull.net
Subject: [PATCH] ext4: cleanup for compiling mballoc with verification and debugging #defines
Date: Wed, 6 Feb 2008 14:32:11 +0100
Message-ID: <18345.46811.448893.451203@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55716 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbYBFNcI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 08:32:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 67B991A18BB
	for <linux-ext4@vger.kernel.org>; Wed,  6 Feb 2008 14:32:15 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22353-10 for <linux-ext4@vger.kernel.org>;
 Wed,  6 Feb 2008 14:32:12 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id BEFE91A18B0
	for <linux-ext4@vger.kernel.org>; Wed,  6 Feb 2008 14:32:11 +0100 (CET)
Received: from frecb006361.adech.frec.bull.fr.bull.net (frecb006361.frec.bull.fr [129.183.101.70])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id E9646272AD
	for <linux-ext4@vger.kernel.org>; Wed,  6 Feb 2008 14:32:08 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

Allows compiling mballoc with:
#define AGGRESSIVE_CHECK
#define DOUBLE_CHECK
#define MB_DEBUG

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Cc: <linux-ext4@vger.kernel.org>

---
 fs/ext4/mballoc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6.24-git12-ext4-1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-git12-ext4-1.orig/fs/ext4/mballoc.c
+++ linux-2.6.24-git12-ext4-1/fs/ext4/mballoc.c
@@ -346,14 +346,14 @@
  */
 
 /*
- * with AGGRESSIVE_CHECK allocator runs consistency checks over
- * structures. these checks slow things down a lot
+ * With AGGRESSIVE_CHECK allocator runs consistency checks over
+ * structures. These checks slow things down a lot.
  */
 #define AGGRESSIVE_CHECK__
 
 /*
- * with DOUBLE_CHECK defined mballoc creates persistent in-core
- * bitmaps, maintains and uses them to check for double allocations
+ * With DOUBLE_CHECK defined, mballoc creates persistent in-core
+ * bitmaps, maintains and uses them to check for double allocations.
  */
 #define DOUBLE_CHECK__
 
@@ -881,10 +881,10 @@ static int __mb_check_buddy(struct ext4_
 	list_for_each(cur, &grp->bb_prealloc_list) {
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
-		pa = list_entry(cur, struct ext4_prealloc_space, group_list);
-		ext4_get_group_no_and_offset(sb, pa->pstart, &groupnr, &k);
+		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
-		for (i = 0; i < pa->len; i++)
+		for (i = 0; i < pa->pa_len; i++)
 			MB_CHECK_ASSERT(mb_test_bit(k + i, buddy));
 	}
 	return 0;
@@ -3097,7 +3097,7 @@ static void ext4_mb_normalize_group_requ
 		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
 	else
 		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
-	mb_debug("#%u: goal %lu blocks for locality group\n",
+	mb_debug("#%u: goal %u blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
 
@@ -3341,7 +3341,7 @@ static void ext4_mb_use_inode_pa(struct 
 	BUG_ON(pa->pa_free < len);
 	pa->pa_free -= len;
 
-	mb_debug("use %llu/%lu from inode pa %p\n", start, len, pa);
+	mb_debug("use %llu/%u from inode pa %p\n", start, len, pa);
 }
 
 /*
@@ -4060,7 +4060,7 @@ static void ext4_mb_show_ac(struct ext4_
 			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
 							start, pa->pa_len);
 		}
-		ext4_lock_group(sb, i);
+		ext4_unlock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
@@ -4412,7 +4412,7 @@ void ext4_mb_free_blocks(handle_t *handl
 			unsigned long block, unsigned long count,
 			int metadata, unsigned long *freed)
 {
-	struct buffer_head *bitmap_bh = 0;
+	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
 	struct ext4_allocation_context ac;
 	struct ext4_group_desc *gdp;
