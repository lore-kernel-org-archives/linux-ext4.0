From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] ext4: don't try to resize if there are no reserved gdt
	blocks left
Date: Wed, 6 Aug 2008 12:16:56 -0400
Message-ID: <20080806161656.GG27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYHFQRM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 12:17:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m76GHBNQ016853
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 12:17:11 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m76GHBeU004330
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 12:17:11 -0400
Received: from unused (unused [10.11.231.15] (may be forged))
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m76GHBB3029547
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 12:17:11 -0400
Received: from unused (localhost.localdomain [127.0.0.1])
	by unused (8.14.1/8.14.1) with ESMTP id m76GGuSN028196
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 12:16:56 -0400
Received: (from jwhiter@localhost)
	by unused (8.14.1/8.14.1/Submit) id m76GGutA028195
	for linux-ext4@vger.kernel.org; Wed, 6 Aug 2008 12:16:56 -0400
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

Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -773,7 +773,8 @@ int ext4_group_add(struct super_block *s
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT4_HAS_COMPAT_FEATURE(sb,
-					     EXT4_FEATURE_COMPAT_RESIZE_INODE)){
+					     EXT4_FEATURE_COMPAT_RESIZE_INODE)
+		    || !le16_to_cpu(es->s_reserved_gdt_blocks)){
 			ext4_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
