From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix update of mtime and ctime on rename
Date: Wed, 26 Mar 2008 11:46:14 +0100
Message-ID: <20080326104614.GD7835@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch below makes ext3 update mtime and ctime of the directory
into which we move file even if the directory entry already exists.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/namei.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index dec3e0d..b0f377f 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2318,6 +2318,8 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
 			new_de->file_type = old_de->file_type;
 		new_dir->i_version++;
+		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
+		ext3_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
 		ext3_journal_dirty_metadata(handle, new_bh);
 		brelse(new_bh);
-- 
1.5.2.4

