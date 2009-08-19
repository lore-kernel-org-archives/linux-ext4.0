From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] ext4: use variables not types in sizeofs() for allocations
Date: Wed, 19 Aug 2009 15:16:36 -0500
Message-ID: <4A8C5DA4.3050002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZHSUqA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 16:46:00 -0400
Received: from int-mx07.intmail.prod.int.phx2.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7JKGcKe009820
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 16:16:38 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx07.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7JKGbgT026017
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 16:16:38 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7JKGaZf015876
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 16:16:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Precursor to changing some types; to keep things in sync, it 
seems better to allocate/memset based on the size of the 
variables we are using rather than on some disconnected 
basic type like "unsigned short"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. feel free to be sure I've *'d all my ptrs correctly.  :)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 992ec20..1b99c03 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -867,7 +867,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			grinfo = ext4_get_group_info(sb, group);
 			grinfo->bb_fragments = 0;
 			memset(grinfo->bb_counters, 0,
-			       sizeof(unsigned short)*(sb->s_blocksize_bits+2));
+			       sizeof(*grinfo->bb_counters) *
+				(sb->s_blocksize_bits+2));
 			/*
 			 * incore got set to the group block bitmap below
 			 */
@@ -2663,14 +2664,14 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	unsigned max;
 	int ret;
 
-	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned short);
+	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_offsets);
 
 	sbi->s_mb_offsets = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_offsets == NULL) {
 		return -ENOMEM;
 	}
 
-	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
+	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_maxs);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
 		kfree(sbi->s_mb_offsets);

