Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87712C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 04:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C9E218D3
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 04:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfDXEhJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 00:37:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbfDXEhJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 00:37:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3O4Y1PY058059
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 00:37:07 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s2eq1w08a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 00:37:07 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 24 Apr 2019 05:37:07 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Apr 2019 05:37:03 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3O4b21u26411108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 04:37:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 619B1B2065;
        Wed, 24 Apr 2019 04:37:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5695FB206E;
        Wed, 24 Apr 2019 04:36:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.81.252])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 24 Apr 2019 04:36:59 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [PATCH V1 05/14] fs/mpage.c: Integrate post read processing
Date:   Wed, 24 Apr 2019 10:07:21 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190424043730.13683-1-chandan@linux.ibm.com>
References: <20190424043730.13683-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042404-0064-0000-0000-000003D026CD
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010984; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01193533; UDB=6.00625685; IPR=6.00974357;
 MB=3.00026570; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-24 04:37:06
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042404-0065-0000-0000-00003D2EF9E5
Message-Id: <20190424043730.13683-6-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904240038
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This commit adds code to make do_mpage_readpage() to be "post read
processing" aware i.e. for files requiring decryption/verification,
do_mpage_readpage() now allocates a context structure and assigns the
corresponding pointer to bio->bi_private. At endio time, a non-zero
bio->bi_private indicates that after the read operation is performed, the
bio's payload needs to be processed further before handing over the data
to user space.

The context structure is used for tracking the state machine associated
with post read processing.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/mpage.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 3f19da75178b..9c291d6ddab6 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -30,6 +30,10 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/cleancache.h>
+#include <linux/fsverity.h>
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+#include <linux/post_read_process.h>
+#endif
 #include "internal.h"
 
 /*
@@ -50,6 +54,20 @@ static void mpage_end_io(struct bio *bio)
 	int i;
 	struct bvec_iter_all iter_all;
 
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+	if (!bio->bi_status && bio->bi_private) {
+		struct bio_post_read_ctx *ctx;
+
+		ctx = bio->bi_private;
+
+		bio_post_read_processing(ctx);
+		return;
+	}
+
+	if (bio->bi_private)
+		put_bio_post_read_ctx((struct bio_post_read_ctx *)(bio->bi_private));
+#endif
+
 	bio_for_each_segment_all(bv, bio, i, iter_all) {
 		struct page *page = bv->bv_page;
 		page_endio(page, bio_op(bio),
@@ -189,7 +207,13 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 
 	block_in_file = (sector_t)page->index << (PAGE_SHIFT - blkbits);
 	last_block = block_in_file + args->nr_pages * blocks_per_page;
-	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
+#ifdef CONFIG_FS_VERITY
+	if (IS_VERITY(inode) && inode->i_sb->s_vop->readpage_limit)
+		last_block_in_file = inode->i_sb->s_vop->readpage_limit(inode);
+	else
+#endif
+		last_block_in_file = (i_size_read(inode) + blocksize - 1)
+			>> blkbits;
 	if (last_block > last_block_in_file)
 		last_block = last_block_in_file;
 	page_block = 0;
@@ -277,6 +301,14 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 	if (first_hole != blocks_per_page) {
 		zero_user_segment(page, first_hole << blkbits, PAGE_SIZE);
 		if (first_hole == 0) {
+#ifdef CONFIG_FS_VERITY
+			if (IS_VERITY(inode)) {
+				if (!fsverity_check_hole(inode, page)) {
+					SetPageError(page);
+					goto confused;
+				}
+			}
+#endif
 			SetPageUptodate(page);
 			unlock_page(page);
 			goto out;
@@ -299,7 +331,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 
 alloc_new:
 	if (args->bio == NULL) {
-		if (first_hole == blocks_per_page) {
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+		struct bio_post_read_ctx *ctx;
+#endif
+		if (first_hole == blocks_per_page
+			&& !(IS_ENCRYPTED(inode) || IS_VERITY(inode))) {
 			if (!bdev_read_page(bdev, blocks[0] << (blkbits - 9),
 								page))
 				goto out;
@@ -310,6 +346,15 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 					gfp);
 		if (args->bio == NULL)
 			goto confused;
+
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+		ctx = get_bio_post_read_ctx(inode, args->bio, page->index);
+		if (IS_ERR(ctx)) {
+			bio_put(args->bio);
+			args->bio = NULL;
+			goto confused;
+		}
+#endif
 	}
 
 	length = first_hole << blkbits;
@@ -331,7 +376,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 confused:
 	if (args->bio)
 		args->bio = mpage_bio_submit(REQ_OP_READ, op_flags, args->bio);
-	if (!PageUptodate(page))
+	if (!PageUptodate(page) && !PageError(page))
 		block_read_full_page(page, args->get_block);
 	else
 		unlock_page(page);
-- 
2.19.1

