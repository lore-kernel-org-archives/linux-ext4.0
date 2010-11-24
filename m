From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/2] ext3: Add more journal error check
Date: Thu, 25 Nov 2010 01:53:13 +0900
Message-ID: <1290617593-4615-2-git-send-email-namhyung@gmail.com>
References: <1290617593-4615-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290617593-4615-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Check return value of ext3_journal_get_write_acccess() and
ext3_journal_dirty_metadata().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/inode.c |    6 ++++--
 fs/ext3/namei.c |    4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 460b6d4..1fd908d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2151,13 +2151,15 @@ static void ext3_clear_blocks(handle_t *handle, struct inode *inode,
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
-			ext3_journal_dirty_metadata(handle, bh);
+			if (ext3_journal_dirty_metadata(handle, bh))
+				return;
 		}
 		ext3_mark_inode_dirty(handle, inode);
 		truncate_restart_transaction(handle, inode);
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
-			ext3_journal_get_write_access(handle, bh);
+			if (ext3_journal_get_write_access(handle, bh))
+				return;
 		}
 	}
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index c8415e7..4400b4e 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1607,7 +1607,9 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
-		ext3_journal_dirty_metadata(handle, frames[0].bh);
+		err = ext3_journal_dirty_metadata(handle, frames[0].bh);
+		if (err)
+			goto journal_error;
 	}
 	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
 	if (!de)
-- 
1.7.0.4
