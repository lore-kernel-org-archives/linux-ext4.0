From: Valerie Aurora <valerie.aurora@gmail.com>
Subject: [PATCH 11/74] ext2: Split ext2_add_entry() from ext2_add_link()
Date: Tue, 22 Mar 2011 18:58:47 -0700
Message-ID: <1300845590-14184-12-git-send-email-valerie.aurora@gmail.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Cc: viro@zeniv.linux.org.uk, Valerie Aurora <vaurora@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@kernel.org,
	Valerie Aurora <valerie.aurora@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Allow future code to use the guts of ext2_add_link().

Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@kernel.org
Signed-off-by: Valerie Aurora <valerie.aurora@gmail.com>
---
 fs/ext2/dir.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 79987ab..74b23b0 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -480,10 +480,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	mark_inode_dirty(dir);
 }
 
-/*
- *	Parent is locked.
- */
-int ext2_add_link (struct dentry *dentry, struct inode *inode)
+int ext2_add_entry (struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	const char *name = dentry->d_name.name;
@@ -579,6 +576,11 @@ out_unlock:
 	goto out_put;
 }
 
+int ext2_add_link (struct dentry *dentry, struct inode *inode)
+{
+	return ext2_add_entry(dentry, inode);
+}
+
 /*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
-- 
1.7.0.4

