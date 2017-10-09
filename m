From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 119/192] ext3: Don't clear SGID when inheriting ACLs
Date: Mon, 09 Oct 2017 13:44:24 +0100
Message-ID: <lsq.1507553064.641910794@decadent.org.uk>
References: <lsq.1507553063.449494954@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        "Jan Kara" <jack@suse.cz>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1507553063.449494954@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

3.16.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Based on Jan Kara's fix for ext2 (commit a992f2d38e4c), from which the
following description is taken:

> When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> set, DIR1 is expected to have SGID bit set (and owning group equal to
> the owning group of 'DIR0'). However when 'DIR0' also has some default
> ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> 'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by moving the posix_acl_update_mode() call up from
__ext3_set_acl() into ext3_set_acl().

Fixes: 073931017b49 ("posix_acl: Clear SGID bit when setting file permissions")
Cc: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext3/acl.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -194,13 +194,6 @@ __ext3_set_acl(handle_t *handle, struct
 	switch(type) {
 		case ACL_TYPE_ACCESS:
 			name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
-			if (acl) {
-				error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-				if (error)
-					return error;
-				inode->i_ctime = CURRENT_TIME_SEC;
-				ext3_mark_inode_dirty(handle, inode);
-			}
 			break;
 
 		case ACL_TYPE_DEFAULT:
@@ -239,7 +232,15 @@ retry:
 	handle = ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
+	if (type == ACL_TYPE_ACCESS && acl) {
+		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		if (error)
+			goto journal_stop;
+		inode->i_ctime = CURRENT_TIME_SEC;
+		ext3_mark_inode_dirty(handle, inode);
+	}
 	error = __ext3_set_acl(handle, inode, type, acl);
+journal_stop:
 	ext3_journal_stop(handle);
 	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
