From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext3: Handle error from d_splice_alias()
Date: Tue, 29 May 2012 22:07:46 +0200
Message-ID: <1338322067-17566-4-git-send-email-jack@suse.cz>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1338322067-17566-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When directory hiearchy is corrupted and contains cycles, d_splice_alias() can
fail. Handle the failure cleanly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/namei.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index eeb63df..faf09b7 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1016,6 +1016,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 	struct inode * inode;
 	struct ext3_dir_entry_2 * de;
 	struct buffer_head * bh;
+	struct dentry *ret;
 
 	if (dentry->d_name.len > EXT3_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1038,7 +1039,13 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 			return ERR_PTR(-EIO);
 		}
 	}
-	return d_splice_alias(inode, dentry);
+	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret)) {
+		ext3_error(dir->i_sb, __func__, "directory #%lu corrupted",
+			   dir->i_ino);
+		iput(inode);
+	}
+	return ret;
 }
 
 
-- 
1.7.1

