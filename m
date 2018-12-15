Return-Path: <SRS0=7LHW=OY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:45654 "EHLO
        dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727668AbeLODnw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Dec 2018 22:43:52 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: stgraham2000@gmail.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: include terminating u32 in size of xattr entries when expanding inodes
Date: Fri, 14 Dec 2018 22:43:43 -0500
Message-Id: <20181215034343.28488-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_expand_extra_isize_ea(), we calculate the total size of the
xattr header, plus the xattr entries so we know how much of the
beginning part of the xattrs to move when expanding the inode extra
size.  We need to include the terminating u32 at the end of the xattr
entries, or else if there is uninitialized, non-zero bytes after the
xattr entries and before the xattr values, the list of xattr entries
won't be properly terminated.

Reported-by: Steve Graham <stgraham2000@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7fddd519adae..86ed9c686249 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2722,7 +2722,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	base = IFIRST(header);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 	min_offs = end - base;
-	total_ino = sizeof(struct ext4_xattr_ibody_header);
+	total_ino = sizeof(struct ext4_xattr_ibody_header) + sizeof(u32);
 
 	error = xattr_check_inode(inode, header, end);
 	if (error)
-- 
2.19.1
