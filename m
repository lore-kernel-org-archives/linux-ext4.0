From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] ext4: only call ext4_truncate when size <= isize
Date: Tue, 19 May 2015 11:28:57 -0400
Message-ID: <1432049337-3520-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22495 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbbESPaF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2015 11:30:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At LSF we decided that if we truncate up from isize we shouldn't trim fallocated
blocks that were fallocated with KEEP_SIZE and are past the new i_size.  This
patch fixes ext4 to do this.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/ext4/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0554b0b..92174dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4640,6 +4640,7 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
 int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
+	loff_t oldsize = inode->i_size;
 	int error, rc = 0;
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
@@ -4727,8 +4728,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		} else {
-			loff_t oldsize = inode->i_size;
