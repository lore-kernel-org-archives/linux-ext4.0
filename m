From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] e2fsprogs: Fix build failure on powerpc.
Date: Wed,  4 Jun 2008 14:31:23 +0530
Message-ID: <1212570083-24253-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45067 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYFDJBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 05:01:39 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5491NB3031218
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:31:23 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m5490rox491724
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:30:53 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5491M2f023059
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 14:31:23 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

../../../lib/ext2fs/swapfs.c:198: error: 'struct <anonymous>' has no member named 'i_pad1'
../../../lib/ext2fs/swapfs.c:198: error: 'struct <anonymous>' has no member named 'i_pad1'
make[2]: *** [swapfs.o] Error 1
make[1]: *** [all-libs-recursive] Error 1
make: *** [all] Error 2

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/swapfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 33c7ab3..5fe3292 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -195,7 +195,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			ext2fs_swab32(f->osd1.linux1.l_i_version);
 		t->osd2.linux2.l_i_blocks_hi = 
 			ext2fs_swab16(f->osd2.linux2.l_i_blocks_hi);
-		t->osd2.linux2.i_pad1 = ext2fs_swab16(f->osd2.linux2.i_pad1);
+		t->osd2.linux2.l_i_file_acl_high =
+			ext2fs_swab16(f->osd2.linux2.l_i_file_acl_high);
 		t->osd2.linux2.l_i_uid_high =
 		  ext2fs_swab16 (f->osd2.linux2.l_i_uid_high);
 		t->osd2.linux2.l_i_gid_high =
-- 
1.5.5.1.357.g1af8b.dirty

