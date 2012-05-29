From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Handle error from d_splice_alias()
Date: Tue, 29 May 2012 22:07:47 +0200
Message-ID: <1338322067-17566-5-git-send-email-jack@suse.cz>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab2E2UH4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 16:07:56 -0400
In-Reply-To: <1338322067-17566-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When directory hiearchy is corrupted and contains cycles, d_splice_alias() can
fail. Handle the failure cleanly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e2a3f4b..fc65520 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1024,6 +1024,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 	struct inode *inode;
 	struct ext4_dir_entry_2 *de;
 	struct buffer_head *bh;
+	struct dentry *ret;
 
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1045,7 +1046,12 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 			return ERR_PTR(-EIO);
 		}
 	}
-	return d_splice_alias(inode, dentry);
+	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret)) {
+		EXT4_ERROR_INODE(dir, "directory corrupted");
+		iput(inode);
+	}
+	return ret;
 }
 
 
-- 
1.7.1

