From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext2: Update also inode on disk when dir is IS_DIRSYNC
Date: Wed, 14 Jan 2009 16:12:27 +0100
Message-ID: <1231945948-23676-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Pavel Machek <pavel@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56985 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752358AbZANPMa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 10:12:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We used to just write changed page for IS_DIRSYNC inodes. But we also have to
update directory inode itself just for the case that we've allocated a new
block and changed i_size.

Thanks to AKPM for spotting a serious bug in the original version of this
patch.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Pavel Machek <pavel@suse.cz>
---
 fs/ext2/dir.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 9a0fc40..2999d72 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -95,10 +95,13 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 		mark_inode_dirty(dir);
 	}
 
-	if (IS_DIRSYNC(dir))
+	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
-	else
+		if (!err)
+			err = ext2_sync_inode(dir);
+	} else {
 		unlock_page(page);
+	}
 
 	return err;
 }
-- 
1.6.0.2

