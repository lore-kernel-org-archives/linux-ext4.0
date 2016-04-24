From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: refuse O_DIRECT opens for mode where DIO doesn't work
Date: Sun, 24 Apr 2016 00:27:58 -0400
Message-ID: <1461472078-20104-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32830 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbcDXE2I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Apr 2016 00:28:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Certain ext4 modes (encryption, data=journal, inline data) cause
Direct I/O to be a no-op.  Instead of making DIO fail silently, make
the open with the O_DIRECT flag fail with EINVAL.

This will avoid surprises to application programs, and also signal to
xfstests not to try O_DIRECT tests for file system modes where it
doesn't work (and could result in test failures).

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fa2208b..4113676 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -372,7 +372,12 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return -EACCES;
 		if (ext4_encryption_info(inode) == NULL)
 			return -ENOKEY;
+		if (filp->f_flags & O_DIRECT)
+			return -EINVAL;
 	}
+	if ((ext4_should_journal_data(inode) || ext4_has_inline_data(inode)) &&
+	    (filp->f_flags & O_DIRECT))
+		return -EINVAL;
 
 	dir = dget_parent(file_dentry(filp));
 	if (ext4_encrypted_inode(d_inode(dir)) &&
-- 
2.5.0

