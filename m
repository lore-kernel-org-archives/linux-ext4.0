From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't leave i_crtime.tv_sec uninitialized
Date: Sun, 16 Feb 2014 19:31:22 -0500
Message-ID: <1392597082-7483-1-git-send-email-tytso@mit.edu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58719 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaBQAbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Feb 2014 19:31:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the i_crtime field is not present in the inode, don't leave the
field uninitialized.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ece5556..d3a534f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -771,6 +771,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
 			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+	else								       \
+		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
-- 
1.9.0

