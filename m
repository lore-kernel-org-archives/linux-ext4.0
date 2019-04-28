Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD75C43219
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2957A2075D
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfD1EbA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 00:31:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbfD1EbA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 28 Apr 2019 00:31:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3S4TEMc102799
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:30:59 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s54211gh7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:30:59 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 28 Apr 2019 05:30:58 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 28 Apr 2019 05:30:54 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3S4Urh513762784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Apr 2019 04:30:54 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0B52112061;
        Sun, 28 Apr 2019 04:30:53 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 818EF112063;
        Sun, 28 Apr 2019 04:30:50 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.75.21])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 28 Apr 2019 04:30:50 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, hch@infradead.org
Subject: [PATCH V2 05/13] fs/mpage.c: Integrate read callbacks
Date:   Sun, 28 Apr 2019 10:01:13 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190428043121.30925-1-chandan@linux.ibm.com>
References: <20190428043121.30925-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042804-2213-0000-0000-00000383619E
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011008; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01195431; UDB=6.00626836; IPR=6.00976273;
 MB=3.00026628; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-28 04:30:58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042804-2214-0000-0000-00005E3538F9
Message-Id: <20190428043121.30925-6-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904280030
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This commit adds code to make do_mpage_readpage() to be "read
callbacks" aware i.e. for files requiring decryption/verification,
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
index 3f19da75178b..e342b859ee44 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -30,6 +30,10 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/cleancache.h>
+#include <linux/fsverity.h>
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+#include <linux/read_callbacks.h>
+#endif
 #include "internal.h"
 
 /*
@@ -50,6 +54,20 @@ static void mpage_end_io(struct bio *bio)
 	int i;
 	struct bvec_iter_all iter_all;
 
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+	if (!bio->bi_status && bio->bi_private) {
+		struct read_callbacks_ctx *ctx;
+
+		ctx = bio->bi_private;
+
+		read_callbacks(ctx);
+		return;
+	}
+
+	if (bio->bi_private)
+		put_read_callbacks_ctx((struct read_callbacks_ctx *)(bio->bi_private));
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
+		struct read_callbacks_ctx *ctx;
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
+		ctx = get_read_callbacks_ctx(inode, args->bio, page->index);
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

