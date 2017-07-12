From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH 1/5] ext4: preserve i_mode if __ext4_set_acl() fails
Date: Wed, 12 Jul 2017 06:53:51 -0300
Message-ID: <52152ec4b83fe0c406475bfee39efafaaa2a88fb.1499805486.git.ernesto.mnd.fernandez@gmail.com>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When changing a file's acl mask, __ext4_set_acl() will first set the group
bits of i_mode to the value of the mask, and only then set the actual
extended attribute representing the new acl.

If the second part fails (due to lack of space, for example) and the file
had no acl attribute to begin with, the system will from now on assume
that the mask permission bits are actual group permission bits, potentially
granting access to the wrong users.

Prevent this by only changing the inode mode after the acl has been set.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
 fs/ext4/acl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 09441ae..2985cd0 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -189,16 +189,17 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	void *value = NULL;
 	size_t size = 0;
 	int error;
+	int update_mode = 0;
+	umode_t mode = inode->i_mode;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
 		if (acl) {
-			error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+			error = posix_acl_update_mode(inode, &mode, &acl);
 			if (error)
 				return error;
-			inode->i_ctime = current_time(inode);
-			ext4_mark_inode_dirty(handle, inode);
+			update_mode = 1;
 		}
 		break;
 
@@ -221,8 +222,14 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 				      value, size, xattr_flags);
 
 	kfree(value);
-	if (!error)
+	if (!error) {
 		set_cached_acl(inode, type, acl);
+		if (update_mode) {
+			inode->i_mode = mode;
+			inode->i_ctime = current_time(inode);
+			ext4_mark_inode_dirty(handle, inode);
+		}
+	}
 
 	return error;
 }
-- 
2.1.4

