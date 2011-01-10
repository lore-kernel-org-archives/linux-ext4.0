From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix memory leak in ext4_free_branches
Date: Mon, 10 Jan 2011 12:56:47 -0500
Message-ID: <1294682207-10494-1-git-send-email-tytso@mit.edu>
References: <20110110175234.GD3128@thunk.org>
Cc: hughd@google.com, Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43353 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1AJR4u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 12:56:50 -0500
In-Reply-To: <20110110175234.GD3128@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 40389687 moved a call to ext4_forget() out of
ext4_free_branches and let ext4_free_blocks() handle calling
bforget().  But that change unfortunately did not replace the call to
ext4_forget() with brelse(), which was needed to drop the in-use count
of the indirect block's buffer head, which lead to a memory leak when
deleting files that used indirect blocks.  Fix this.

Thanks to Hugh Dickins for pointing this out.

Cc: stable@kernel.org
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 84b6162..e80fc51 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4378,6 +4378,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					(__le32 *) bh->b_data,
 					(__le32 *) bh->b_data + addr_per_block,
 					depth);
+			brelse(bh);
 
 			/*
 			 * Everything below this this pointer has been
-- 
1.7.3.1

