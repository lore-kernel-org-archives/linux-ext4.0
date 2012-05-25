From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: Fix rbtree backend for extent lengths greater
 than 2^32
Date: Fri, 25 May 2012 14:43:53 -0500
Message-ID: <4FBFE0F9.8050509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab2EYTnz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 May 2012 15:43:55 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4PJhttq014616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 25 May 2012 15:43:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well, this took way too long to find, in retrospect.

In short, for a completely full filesystem with more than 2^32
blocks, the rbtree bitmap backend can assemble an extent of used
blocks which is longer than 2^32.  If it does, it will overflow
->count, and corrupt the rbtree for the bitmaps.

Discovered by completely filling a 32T filesystem using fallocate, and
then observing debugfs, dumpe2fs, and e2fsck all behaving badly.

(Note that filling with only 31 x 1T files did not show the problem,
because freespace was fragmented enough that there was no sufficiently
long range of used blocks.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

An alternative solution might be to limit the rb_extent to
32-bit counts, and not merging beyond that.  For fragmented
freespace, as normal, perhaps that would be a better memory
savings?  But this fixes the immediate problem and seems worth
merging to avoid bad situations such as e2fsck corrupting a
perfectly good 32T filesystem...

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 7ab72f4..a83f8ac 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -33,7 +33,7 @@
 struct bmap_rb_extent {
 	struct rb_node node;
 	__u64 start;
-	__u32 count;
+	__u64 count;
 };
 
 struct ext2fs_rb_private {

