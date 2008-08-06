From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] ext3: don't try to resize if there are no reserved gdt
	blocks left
Date: Wed, 6 Aug 2008 12:14:57 -0400
Message-ID: <20080806161457.GF27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbYHFQPT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 12:15:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

When trying to resize a ext3 fs and you run out of reserved gdt blocks, you get
an error that doesn't actually tell you what went wrong, it just says that the
gdb it picked is not correct, which is the case since you don't have any
reserved gdt blocks left.  This patch adds a check to make sure you have
reserved gdt blocks to use, and if not prints out a more relevant error.  Thank
you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/ext3/resize.c
===================================================================
--- linux-2.6.orig/fs/ext3/resize.c
+++ linux-2.6/fs/ext3/resize.c
@@ -790,7 +790,8 @@ int ext3_group_add(struct super_block *s
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT3_HAS_COMPAT_FEATURE(sb,
-					     EXT3_FEATURE_COMPAT_RESIZE_INODE)){
+					     EXT3_FEATURE_COMPAT_RESIZE_INODE)
+		    || !le16_to_cpu(es->s_reserved_gdt_blocks)){
 			ext3_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
