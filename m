From: akpm@linux-foundation.org
Subject: [patch 090/148] ext3: don't try to resize if there are no reserved gdt blocks left
Date: Sat, 18 Oct 2008 20:27:55 -0700
Message-ID: <200810190327.m9J3Rt6h032710@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbYJSDeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2008 23:34:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

When trying to resize a ext3 fs and you run out of reserved gdt blocks,
you get an error that doesn't actually tell you what went wrong, it just
says that the gdb it picked is not correct, which is the case since you
don't have any reserved gdt blocks left.  This patch adds a check to make
sure you have reserved gdt blocks to use, and if not prints out a more
relevant error.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext3/resize.c~ext3-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left
+++ a/fs/ext3/resize.c
@@ -790,7 +790,8 @@ int ext3_group_add(struct super_block *s
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT3_HAS_COMPAT_FEATURE(sb,
-					     EXT3_FEATURE_COMPAT_RESIZE_INODE)){
+					     EXT3_FEATURE_COMPAT_RESIZE_INODE)
+		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
 			ext3_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
_
