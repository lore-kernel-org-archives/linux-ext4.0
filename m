From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] ext4: use file_dentry()
Date: Sat, 26 Mar 2016 17:09:59 -0400
Message-ID: <1459026600-9232-5-git-send-email-tytso@mit.edu>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	Miklos Szeredi <mszeredi@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

EXT4 may be used as lower layer of overlayfs and accessing f_path.dentry
can lead to a crash.

Fix by replacing direct access of file->f_path.dentry with the
file_dentry() accessor, which will always return a native object.

Reported-by: Daniel Axtens <dja@axtens.net>
Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
Fixes: ff978b09f973 ("ext4 crypto: move context consistency check to ext4_file_open()")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> # v4.5
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 257118d..edba9fb 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -374,7 +374,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return -ENOKEY;
 	}
 
-	dir = dget_parent(filp->f_path.dentry);
+	dir = dget_parent(file_dentry(filp));
 	if (ext4_encrypted_inode(d_inode(dir)) &&
 	    !ext4_is_child_context_consistent_with_parent(d_inode(dir), inode)) {
 		ext4_warning(inode->i_sb,
-- 
2.5.0
