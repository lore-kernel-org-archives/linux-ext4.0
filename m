From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext2: Handle error from d_splice_alias()
Date: Tue, 29 May 2012 22:07:45 +0200
Message-ID: <1338322067-17566-3-git-send-email-jack@suse.cz>
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
 fs/ext2/namei.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f663a67..d5f8aab 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -59,6 +59,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 {
 	struct inode * inode;
 	ino_t ino;
+	struct dentry *ret;
 	
 	if (dentry->d_name.len > EXT2_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -74,7 +75,13 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 			return ERR_PTR(-EIO);
 		}
 	}
-	return d_splice_alias(inode, dentry);
+	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret)) {
+		ext2_error(dir->i_sb, __func__, "directory #%lu corrupted",
+			   dir->i_ino);
+		iput(inode);
+	}
+	return ret;
 }
 
 struct dentry *ext2_get_parent(struct dentry *child)
-- 
1.7.1

