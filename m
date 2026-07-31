Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BA23368AE
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 03:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785469045; cv=none; b=QcNuuvLNi8Q2MtLO/pl985CGYKkmMaV0iwnzcqhCQ8+KN40jFQwejcOrFC3JllWeFYawNkzMuxS6/DU5ayO5Qi3GXAyufBtqNunxs33XApMPdBQSkDZiL82h2n21hZX2RPyuY6LICSL13rU7nwq9/MlmHFpUdpo30rbkLdeaGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785469045; c=relaxed/simple;
	bh=cdsxJXK76Km4xgluGyZHHJ25QTfjf6d1yWBMx48uYIc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lNOi13VEZouN9pORm+oGWDXwyfYV7QLDoNnppsM1lwnd8j+2rqq7W8MJ24vhJQPilXvSZ5EBUYQP0jaqQDaqo+cDLbwNu8lmNqqauW9H4cw0z+mUTgXbEu+MPWmoWUS/SZK7tDJJDkF+Ob+CmYn+rXROlHtLQACw5YiPnHAs1ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=QHdEphK8; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="QHdEphK8"
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
	by m0050093.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 66V3bGOu3302766;
	Fri, 31 Jul 2026 04:37:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=apr2026.eng;
	 bh=VUNee6/erK96XMobrR2n6FmMX+5L1gQJwIcNHhH0CPY=; b=QHdEphK8EHUu
	Tb6JpTVDIJo9yqhHJ81unpM3BNyYDF9UAaOnVo6eKJwaGsgQ3zvoU94KLa6Y9u+9
	buimMhLLLJVMPLjIbfrpAn4nTUyvcimQqO7xZvY9y8SkQ4sz8JgcUz7+Y5hsi5+2
	OWKOG4/+nJ1qjnALzgqWporFo/kAYrwujUipwpGOKnHIMNPCzOJ6z/AQMcOgOrc0
	azrWne62YDxlTU5Pr4IUvDAYsp72XBG0RgxiKma3waecKpCLdvEX/nZg4QSTQDXW
	+7D60b0d7WeL/ZGBW6NKHP8wkWOWnzbDxcw1XeoDS2QuPWeWOKY8ILBL0r/+AAGR
	gJ+ofcAHtA==
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
	by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 4fqeucsprt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 04:37:15 +0100 (BST)
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
	by prod-mail-ppoint4.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 66V3XpUo028891;
	Thu, 30 Jul 2026 23:37:15 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.220])
	by prod-mail-ppoint4.akamai.com (PPS) with ESMTPS id 4fr5ng6dxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:37:14 -0400 (EDT)
Received: from ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 20:37:14 -0700
Received: from sjc-lp2nq5qm.santaclara.corp.akamai.com (172.27.164.43) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server id 15.2.2562.43 via Frontend Transport; Thu, 30 Jul 2026 20:37:14
 -0700
Received: by sjc-lp2nq5qm.santaclara.corp.akamai.com (Postfix, from userid 30754)
	id 7D473AC0EBF; Thu, 30 Jul 2026 20:37:13 -0700 (PDT)
From: Josh Hunt <johunt@akamai.com>
To: <linux-ext4@vger.kernel.org>
CC: <kknox@akamai.com>, <tytos@mit.edu>
Subject: [PATCH 2/3] fix bitmap byte size calculations
Date: Thu, 30 Jul 2026 20:37:00 -0700
Message-ID: <20260731033701.2657758-3-johunt@akamai.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260731033701.2657758-1-johunt@akamai.com>
References: <20260731033701.2657758-1-johunt@akamai.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607310020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX45gxalK1CSwI
 3A1cJwrPoyDu9pTzY552yvKFYpTKImF78XxA1xCo1FwXNW43v7Jcxl/+8mql3sxfRv12y73FVNw
 0j1JLt4fx6L+kzEsJZkOLhP8X9MUg+6/Bjw2pGSAuXLLbNEBdiBLN4f2I+WkSmM69htob0JrHIv
 /VmTd2taK0LSbW1alOz5kNyhP4oy1HPhJtCgihY3inzFZg3EpMwVXNHgoWwthElmFTjFc75Z3q+
 Ln67sd4EtBHlFodrq4645Jj/FGMSctVW+AzFVKg68lVWnBoCbAiJ+AzWZr3HopArA3jVX4Camft
 gMm9sJ1POlltOXxMxCnxqfRdctItzIPyEEq9dGmkDmeDWXAxjYFukUpV79ni0pySqs2S7sNkTvp
 7pQ7+TPKZzcfIQICTU7hE2Fu9oFF31CtPI6cl0FjaM4mx7aKP7/NMOFjamLpPibYeWL4oRbN+TX
 69CwMtakqnErmaDFMpQ==
X-Proofpoint-GUID: QCdwpsrN8B0Oi81vWEnioRusxIo8sAfx
X-Proofpoint-ORIG-GUID: QCdwpsrN8B0Oi81vWEnioRusxIo8sAfx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX+Rl5aC+CNH6u
 00IiN6ehMyO7RaAngKNk0eQ85Z15N3W9NWjqMNng1xjPMO+ShywEyj3XWel4ksF5MRfZlsAGLP5
 CA7PY0P3t01VAVMl2qhqDuLUHqB3vZc=
X-Authority-Analysis: v=2.4 cv=ZIfnX37b c=1 sm=1 tr=0 ts=6a6c186b cx=c_pps
 a=NaJOksh5yBwW9//Q5C/Ubg==:117 a=NaJOksh5yBwW9//Q5C/Ubg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=d4nn1RXdvEacMIURMw2s:22 a=X7Ea-ya5AAAA:8 a=6HtkDXh1vmktNHZaldQA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606160001 definitions=main-2607310020

From: Kit Knox <kknox@akamai.com>

The bitmap byte size calculations use integer division (count / 8) without
rounding up.  When clusters_per_group or inodes_per_group is not a multiple
of 8, this allocates too few bytes.  The bitmap backends copy (num + 7) / 8
bytes via ext2fs_get_block_bitmap_range2(), causing a buffer overrun of 1-7
bytes.

Example: With s_clusters_per_group = blocksize*8 + 1, the buffer is
undersized by 1 byte, causing heap corruption when the bitmap is copied.

Signed-off-by: Kit Knox <kknox@akamai.com>
---
 e2fsck/pass5.c          | 10 ++++++----
 lib/ext2fs/rw_bitmaps.c | 13 ++++++-------
 misc/dumpe2fs.c         |  4 ++--
 resize/resize2fs.c      |  3 ++-
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index c1d45a5f..aad2e76a 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -324,10 +324,12 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	redo_flag = 0;
 	char *actual_buf, *bitmap_buf;
 
-	actual_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
-						     "actual bitmap buffer");
-	bitmap_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
-						     "bitmap block buffer");
+	actual_buf = (char *) e2fsck_allocate_memory(ctx,
+		ext2fs_div_ceil(fs->super->s_clusters_per_group, 8),
+		"actual bitmap buffer");
+	bitmap_buf = (char *) e2fsck_allocate_memory(ctx,
+		ext2fs_div_ceil(fs->super->s_clusters_per_group, 8),
+		"bitmap block buffer");
 
 	clear_problem_context(&pctx);
 	free_array = (unsigned int *) e2fsck_allocate_memory(ctx,
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1da75e4a..211d9ec4 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -72,15 +72,14 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	inode_nbytes = block_nbytes = 0;
 	if (do_block) {
-		block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
+		block_nbytes = ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
 		retval = io_channel_alloc_buf(fs->io, 0, &block_buf);
 		if (retval)
 			goto errout;
 		memset(block_buf, 0xff, fs->blocksize);
 	}
 	if (do_inode) {
-		inode_nbytes = (size_t)
-			((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
+		inode_nbytes = ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
 		retval = io_channel_alloc_buf(fs->io, 0, &inode_buf);
 		if (retval)
 			goto errout;
@@ -230,8 +229,8 @@ static int bitmap_tail_verify(unsigned char *bitmap, int first, int last)
 static errcode_t read_bitmaps_range_prepare(ext2_filsys fs, int flags)
 {
 	errcode_t retval;
-	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
+	int block_nbytes = ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
+	int inode_nbytes = ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
 	char *buf;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
@@ -289,8 +288,8 @@ static errcode_t read_bitmaps_range_start(ext2_filsys fs, int flags,
 	dgrp_t i;
 	char *block_bitmap = 0, *inode_bitmap = 0;
 	errcode_t retval = 0;
-	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
+	int block_nbytes = ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
+	int inode_nbytes = ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
 	int csum_flag;
 	unsigned int	cnt;
 	blk64_t	blk;
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b56d15d9..2c45d6bb 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -168,8 +168,8 @@ static void list_desc(ext2_filsys fs, int grp_only)
 	if (ext2fs_has_feature_bigalloc(fs->super))
 		units = _("clusters");
 
-	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
+	block_nbytes = ext2fs_div_ceil(EXT2_CLUSTERS_PER_GROUP(fs->super), 8);
+	inode_nbytes = ext2fs_div_ceil(EXT2_INODES_PER_GROUP(fs->super), 8);
 
 	if (fs->block_map)
 		block_bitmap = malloc(block_nbytes);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dfefca1d..ad092244 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2088,6 +2088,7 @@ static int fix_ea_ibody_entries(ext2_extent imap,
 
 	ea_magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
 				inode->i_extra_isize);
+
 	if (*ea_magic != EXT2_EXT_ATTR_MAGIC)
 		return 0;
 
@@ -2950,7 +2951,7 @@ static errcode_t resize2fs_calculate_summary_stats(ext2_filsys fs)
 	/*
 	 * First calculate the block statistics
 	 */
-	bitmap_buf = malloc(fs->blocksize);
+	bitmap_buf = malloc(ext2fs_div_ceil(fs->super->s_clusters_per_group, 8));
 	if (!bitmap_buf)
 		return ENOMEM;
 	for (group = 0; group < fs->group_desc_count; group++) {
-- 
2.34.1

