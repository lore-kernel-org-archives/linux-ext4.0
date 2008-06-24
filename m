From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext3: handle deleting corrupted indirect blocks
Date: Tue, 24 Jun 2008 14:47:20 +0100
Message-ID: <1214315240-22950-1-git-send-email-duaneg@dghda.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1266 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYFXNrX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 09:47:23 -0400
In-Reply-To: <20080607121940.8ee6044a.akpm@linux-foundation.org>
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
---

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 6ae4ecf..8019bf2 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2127,7 +2127,20 @@ static void ext3_free_data(handle_t *handle, struct inode *inode,
 
 	if (this_bh) {
 		BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, this_bh);
+
+		/*
+		 * The buffer head should have an attached journal head at this
+		 * point. However, if the data is corrupted and an indirect
+		 * block pointed to itself, it would have been detached when
+		 * the block was cleared. Check for this instead of OOPSing.
+		 */
+		if (bh2jh(this_bh))
+			ext3_journal_dirty_metadata(handle, this_bh);
+		else
+			ext3_error(inode->i_sb, "ext3_free_data",
+				   "circular indirect block detected, "
+				   "inode=%lu, block="E3FSBLK,
+				   inode->i_ino, this_bh->b_blocknr);
 	}
 }
 
