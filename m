From: Solofo.Ramangalahy@bull.net
Subject: [PATCH RESENT] ext4: cleanup for compiling mballoc with verification and debugging #defines
Date: Wed, 9 Apr 2008 09:08:04 +0200
Message-ID: <18428.27476.805658.391244@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32958 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYDIHHr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 03:07:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 979691A18E3
	for <linux-ext4@vger.kernel.org>; Wed,  9 Apr 2008 09:08:08 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 01224-10 for <linux-ext4@vger.kernel.org>;
 Wed,  9 Apr 2008 09:08:05 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 6753D1A18F2
	for <linux-ext4@vger.kernel.org>; Wed,  9 Apr 2008 09:08:05 +0200 (CEST)
Received: from frecb006361.adech.frec.bull.fr.bull.net (frecb006361.frec.bull.fr [129.183.101.70])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 010DE27289
	for <linux-ext4@vger.kernel.org>; Wed,  9 Apr 2008 09:08:01 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: cleanup for compiling mballoc with verification and debugging #defines

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

This patch allows compiling mballoc with:
#define AGGRESSIVE_CHECK
#define DOUBLE_CHECK
#define MB_DEBUG

It fixes:
Compilation errors:
fs/ext4/mballoc.c: In function '__mb_check_buddy':
fs/ext4/mballoc.c:605: error: 'struct ext4_prealloc_space' has no member named 'group_list'
fs/ext4/mballoc.c:606: error: 'struct ext4_prealloc_space' has no member named 'pstart'
fs/ext4/mballoc.c:608: error: 'struct ext4_prealloc_space' has no member named 'len'

Compilation warnings:
fs/ext4/mballoc.c: In function 'ext4_mb_normalize_group_request':
fs/ext4/mballoc.c:2863: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'int'
fs/ext4/mballoc.c: In function 'ext4_mb_use_inode_pa':
fs/ext4/mballoc.c:3103: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'int'

Sparse check:
fs/ext4/mballoc.c:3818:2: warning: context imbalance in 'ext4_mb_show_ac' - different lock contexts for basic block

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 fs/ext4/mballoc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d.orig/fs/ext4/mballoc.c
+++ linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/mballoc.c
@@ -602,10 +602,10 @@ static int __mb_check_buddy(struct ext4_
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
@@ -2860,7 +2860,7 @@ static void ext4_mb_normalize_group_requ
 		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
 	else
 		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
-	mb_debug("#%u: goal %lu blocks for locality group\n",
+	mb_debug("#%u: goal %u blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
 
@@ -3100,7 +3100,7 @@ static void ext4_mb_use_inode_pa(struct 
 	BUG_ON(pa->pa_free < len);
 	pa->pa_free -= len;
 
-	mb_debug("use %llu/%lu from inode pa %p\n", start, len, pa);
+	mb_debug("use %llu/%u from inode pa %p\n", start, len, pa);
 }
 
 /*
@@ -3831,7 +3831,7 @@ static void ext4_mb_show_ac(struct ext4_
 			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
 							start, pa->pa_len);
 		}
-		ext4_lock_group(sb, i);
+		ext4_unlock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
