From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: preserve i_mode if __ext4_set_acl() fails
Date: Tue,  8 Aug 2017 14:44:41 +0200
Message-ID: <20170808124442.8963-2-jack@suse.cz>
References: <20170808124442.8963-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Ted Tso <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
        gregkh@linuxfoundation.org,
        =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170808124442.8963-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

When changing a file's acl mask, __ext4_set_acl() will first set the group
bits of i_mode to the value of the mask, and only then set the actual
extended attribute representing the new acl.

If the second part fails (due to lack of space, for example) and the file
had no acl attribute to begin with, the system will from now on assume
that the mask permission bits are actual group permission bits, potentially
granting access to the wrong users.

Prevent this by only changing the inode mode after the acl has been set.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>

---
 fs/ext4/acl.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -189,16 +189,17 @@ __ext4_set_acl(handle_t *handle, struct
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
 
@@ -221,8 +222,14 @@ __ext4_set_acl(handle_t *handle, struct
 				      value, size, 0);
 
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
