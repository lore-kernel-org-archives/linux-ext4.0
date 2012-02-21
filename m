From: David Howells <dhowells@redhat.com>
Subject: [PATCH 66/73] ext2: Split ext2_add_entry() from ext2_add_link() [ver
 #2]
Date: Tue, 21 Feb 2012 18:05:46 +0000
Message-ID: <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@kernel.org
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	valerie.aurora@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Allow future code to use the guts of ext2_add_link().

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@kernel.org
---

 fs/ext2/dir.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 89015f1..d8382dc 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -489,10 +489,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	mark_inode_dirty(dir);
 }
 
-/*
- *	Parent is locked.
- */
-int ext2_add_link (struct dentry *dentry, struct inode *inode)
+int ext2_add_entry(struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	const char *name = dentry->d_name.name;
@@ -588,6 +585,11 @@ out_unlock:
 	goto out_put;
 }
 
+int ext2_add_link(struct dentry *dentry, struct inode *inode)
+{
+	return ext2_add_entry(dentry, inode);
+}
+
 /*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
