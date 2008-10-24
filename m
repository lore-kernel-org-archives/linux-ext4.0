From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2 v2] delay capable() check in ext4_has_free_blocks(
Date: Fri, 24 Oct 2008 15:41:42 -0500
Message-ID: <49023306.9010507@redhat.com>
References: <49022FB7.9050608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYJXUlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 16:41:45 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9OKfje1028125
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 16:41:45 -0400
In-Reply-To: <49022FB7.9050608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As reported by Eric Paris, the capable() check in ext4_has_free_blocks()
sometimes causes SELinux denials.

We can rearrange the logic so that we only try to use the root-reserved
blocks when necessary, and even then we can move the capable() test
to last, to avoid the check most of the time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
(whoops, forgot a quilt refresh before sending the last one...)

Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c	2008-10-24 15:32:36.000000000 -0500
+++ linux-2.6/fs/ext4/balloc.c	2008-10-24 15:38:52.897001441 -0500
@@ -599,18 +599,13 @@ void ext4_free_blocks(handle_t *handle, 
  */
 int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
-	s64 free_blocks, dirty_blocks;
-	s64 root_blocks = 0;
+	s64 free_blocks, dirty_blocks, root_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
 	free_blocks  = percpu_counter_read_positive(fbc);
 	dirty_blocks = percpu_counter_read_positive(dbc);
-
-	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
-		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
-		root_blocks = ext4_r_blocks_count(sbi->s_es);
+	root_blocks = ext4_r_blocks_count(sbi->s_es);
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
@@ -623,13 +618,20 @@ int ext4_has_free_blocks(struct ext4_sb_
 		}
 	}
 	/* Check whether we have space after
-	 * accounting for current dirty blocks
+	 * accounting for current dirty blocks & root reserved blocks.
 	 */
-	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
-		/* we don't have free space */
-		return 0;
+	if (free_blocks >= ((root_blocks + nblocks) + dirty_blocks))
+		return 1;
 
-	return 1;
+	/* Hm, nope.  Are (enough) root reserved blocks available? */
+	if (sbi->s_resuid == current->fsuid ||
+	    ((sbi->s_resgid != 0) && in_group_p(sbi->s_resgid)) ||
+	    capable(CAP_SYS_RESOURCE)) {
+		if (free_blocks >= (nblocks + dirty_blocks))
+			return 1;
+	}
+
+	return 0;
 }
 
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,

