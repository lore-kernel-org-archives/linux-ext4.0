From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 16/42] ext4: Avoid printk floods in the face of directory corruption
Date: Thu,  9 Oct 2008 00:05:34 -0400
Message-ID: <1223525160-9887-17-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Eugene Teo <eugeneteo@kernel.sg>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54497 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757577AbYJIEGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:12 -0400
In-Reply-To: <1223525160-9887-16-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note: some people thinks this represents a security bug, since it
might make the system go away while it is printing a large number of
console messages, especially if a serial console is involved.  Hence,
it has been assigned CVE-2008-3528, but it requires that the attacker
either has physical access to your machine to insert a USB disk with a
corrupted filesystem image (at which point why not just hit the power
button), or is otherwise able to convince the system administrator to
mount an arbitrary filesystem image (at which point why not just
include a setuid shell or world-writable hard disk device file or some
such).  Me, I think they're just being silly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/ext4/dir.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d40da31..3ca6a2b 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -102,6 +102,7 @@ static int ext4_readdir(struct file *filp,
 	int err;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
+	int dir_has_error = 0;
 
 	sb = inode->i_sb;
 
@@ -148,9 +149,13 @@ static int ext4_readdir(struct file *filp,
 		 * of recovering data when there's a bad sector
 		 */
 		if (!bh) {
-			ext4_error(sb, "ext4_readdir",
-				"directory #%lu contains a hole at offset %lu",
-				inode->i_ino, (unsigned long)filp->f_pos);
+			if (!dir_has_error) {
+				ext4_error(sb, __func__, "directory #%lu "
+					   "contains a hole at offset %Lu",
+					   inode->i_ino,
+					   (unsigned long long) filp->f_pos);
+				dir_has_error = 1;
+			}
 			/* corrupt size?  Maybe no more blocks to read */
 			if (filp->f_pos > inode->i_blocks << 9)
 				break;
-- 
1.5.6.1.205.ge2c7.dirty

