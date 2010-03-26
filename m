From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] ext2: symlink must be handled via filesystem specific operation
Date: Fri, 26 Mar 2010 19:29:54 +0300
Message-ID: <1269620996-11400-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45099 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab0CZQaK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 12:30:10 -0400
Received: by bwz1 with SMTP id 1so1954865bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 09:30:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

generic setattr implementation is no longer responsible for
quota transfer so synlinks must be handled via ext2_setattr.
---
 fs/ext2/symlink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
index 4e2426e..565cf81 100644
--- a/fs/ext2/symlink.c
+++ b/fs/ext2/symlink.c
@@ -32,6 +32,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
+	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -43,6 +44,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
 const struct inode_operations ext2_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= ext2_follow_link,
+	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
-- 
1.6.6.1

