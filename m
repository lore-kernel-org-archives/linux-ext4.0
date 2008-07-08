From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext4: handle deleting corrupted indirect blocks
Date: Tue,  8 Jul 2008 15:42:00 +0100
Message-ID: <1215528121-26934-2-git-send-email-duaneg@dghda.com>
References: <1215528121-26934-1-git-send-email-duaneg@dghda.com>
Cc: sct@redhat.com, adilger@clusterfs.com, Mingming <cmm@us.ibm.com>,
	Sami Liedes <sliedes@cc.hut.fi>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2725 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYGHOmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2008 10:42:07 -0400
In-Reply-To: <1215528121-26934-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While freeing indirect blocks we attach a journal head to the parent buffer
head, free the blocks, then journal the parent. If the indirect block list
is corrupted and points to the parent the journal head will be detached
when the block is cleared, causing an OOPS.

Check for that explicitly and handle it gracefully.

This patch fixes the third case (image hdb.20000057.nullderef.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is the ext4 version of an ext3 patch queued in -mm.
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d97077..f3cd914 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2179,7 +2179,20 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 
 	if (this_bh) {
 		BUFFER_TRACE(this_bh, "call ext4_journal_dirty_metadata");
-		ext4_journal_dirty_metadata(handle, this_bh);
+
+		/*
+		 * The buffer head should have an attached journal head at this
+		 * point. However, if the data is corrupted and an indirect
+		 * block pointed to itself, it would have been detached when
+		 * the block was cleared. Check for this instead of OOPSing.
+		 */
+		if (bh2jh(this_bh))
+			ext4_journal_dirty_metadata(handle, this_bh);
+		else
+			ext4_error(inode->i_sb, __func__,
+				   "circular indirect block detected, "
+				   "inode=%lu, block=%lu",
+				   inode->i_ino, this_bh->b_blocknr);
 	}
 }
 
