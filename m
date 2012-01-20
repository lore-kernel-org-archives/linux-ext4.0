From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/8] ext4: Protect ext4_page_mkwrite & ext4_setattr with sb_start_write - sb_end_write
Date: Fri, 20 Jan 2012 21:34:41 +0100
Message-ID: <1327091686-23177-4-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab2ATUe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jan 2012 15:34:57 -0500
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since ext4_page_mkwrite() calls into __block_page_mkwrite() it has to
provide freezing protection on it's own. Also ext4_setattr() needs protection
because ext4_truncate() can modify last page of the file.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..05d6328 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4225,6 +4225,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	if (is_quota_modification(inode, attr))
 		dquot_initialize(inode);
 	if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
@@ -4327,6 +4328,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		rc = ext4_acl_chmod(inode);
 
 err_out:
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
@@ -4733,11 +4735,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
-	/*
-	 * This check is racy but catches the common case. We rely on
-	 * __block_page_mkwrite() to do a reliable check.
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -4805,5 +4803,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	return ret;
 }
-- 
1.7.1

