From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Update also inode on disk when dir is IS_DIRSYNC
Date: Tue, 13 Jan 2009 13:42:02 +0100
Message-ID: <1231850522-11074-1-git-send-email-jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Pavel Machek <pavel@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758700AbZAMMmV@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We used to just write changed page for IS_DIRSYNC inodes. But we also have to
update directory inode itself just for the case that we've allocated a new
block and changed i_size.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Pavel Machek <pavel@suse.cz>
---
 fs/ext2/dir.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

  Andrew, would you please merge the patch? Ext3 and ext4 don't have this
problem BTW.

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 9a0fc40..7fba549 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -94,11 +94,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
+	unlock_page(page);
 
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
-	else
-		unlock_page(page);
+		err = ext2_sync_inode(dir);
 
 	return err;
 }
-- 
1.6.0.4
