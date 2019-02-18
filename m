Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD7EC4360F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956802146F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfBRKEh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:04:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729170AbfBRKEg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 05:04:36 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1IA3tCm078713
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:35 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qqqe3898y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:35 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 18 Feb 2019 10:04:30 -0000
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Feb 2019 10:04:27 -0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1IA4Q0e29360184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 10:04:26 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B350136059;
        Mon, 18 Feb 2019 10:04:26 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A17AE136051;
        Mon, 18 Feb 2019 10:04:23 +0000 (GMT)
Received: from localhost.in.ibm.com (unknown [9.124.35.115])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 18 Feb 2019 10:04:23 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH 06/10] Introduce REQ_POST_READ_PROC bio flag
Date:   Mon, 18 Feb 2019 15:34:29 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218100433.20048-1-chandan@linux.ibm.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021810-8235-0000-0000-00000E607B5F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010619; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000280; SDB=6.01162773; UDB=6.00607075; IPR=6.00943349;
 MB=3.00025633; MTD=3.00000008; XFM=3.00000015; UTC=2019-02-18 10:04:29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021810-8236-0000-0000-000044846E39
Message-Id: <20190218100433.20048-7-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-18_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902180077
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ext4 and F2FS currently use a non-NULL value stored at bio->bi_private
to determine if the contents of the bio need to be "post processed"
i.e. whether its contents need to be decrypted and/or verified. For
block size < page size scenario, bio->bi_private would hold a pointer to
buffer_head. Hence, this commit adds the new flag REQ_POST_READ_PROC to
be able to decisively check for post process requirement for a bio.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/readpage.c        | 11 +++++++++--
 fs/post_read_process.c    |  2 +-
 include/linux/blk_types.h |  2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 8943fc41fd33..c7dbab35deaa 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -245,6 +245,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		}
 		if (bio == NULL) {
 			struct bio_post_read_ctx *ctx;
+			unsigned int op_flags = 0;
 
 			bio = bio_alloc(GFP_KERNEL,
 				min_t(int, nr_pages, BIO_MAX_PAGES));
@@ -259,8 +260,14 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			bio->bi_private = ctx;
-			bio_set_op_attrs(bio, REQ_OP_READ,
-						is_readahead ? REQ_RAHEAD : 0);
+
+			if (is_readahead)
+				op_flags |= REQ_RAHEAD;
+
+			if (ctx)
+				op_flags |= REQ_POST_READ_PROC;
+
+			bio_set_op_attrs(bio, REQ_OP_READ, op_flags);
 		}
 
 		length = first_hole << blkbits;
diff --git a/fs/post_read_process.c b/fs/post_read_process.c
index 1f8663d70247..66c1c6e57e70 100644
--- a/fs/post_read_process.c
+++ b/fs/post_read_process.c
@@ -104,7 +104,7 @@ void put_bio_post_read_ctx(struct bio_post_read_ctx *ctx)
 
 bool bio_post_read_required(struct bio *bio)
 {
-	return bio->bi_private && !bio->bi_status;
+	return bio->bi_opf & REQ_POST_READ_PROC;
 }
 
 static int __init bio_init_post_read_processing(void)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5c7e7f859a24..6904945c8c40 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -320,6 +320,7 @@ enum req_flag_bits {
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
 	__REQ_BACKGROUND,	/* background IO */
 	__REQ_NOWAIT,           /* Don't wait if request will block */
+	__REQ_POST_READ_PROC,
 
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
@@ -346,6 +347,7 @@ enum req_flag_bits {
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
+#define REQ_POST_READ_PROC	(1ULL << __REQ_POST_READ_PROC)
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
 
-- 
2.19.1

