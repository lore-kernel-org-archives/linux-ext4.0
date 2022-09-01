Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2DEC0502C
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Sep 2022 13:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiIAN00 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiIANYe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2022 09:24:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BD211A06;
        Thu,  1 Sep 2022 06:24:12 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MJMCd2n4QzHnXc;
        Thu,  1 Sep 2022 21:22:21 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 1 Sep
 2022 21:24:09 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
        <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
        <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
CC:     <tytso@mit.edu>, <akpm@linux-foundation.org>, <axboe@kernel.dk>,
        <viro@zeniv.linux.org.uk>, <rpeterso@redhat.com>,
        <agruenba@redhat.com>, <almaz.alexandrovich@paragon-software.com>,
        <mark@fasheh.com>, <dushistov@mail.ru>, <hch@infradead.org>,
        <yi.zhang@huawei.com>, <chengzhihao1@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH v2 13/14] ext2: replace bh_submit_read() helper with bh_read_locked()
Date:   Thu, 1 Sep 2022 21:35:04 +0800
Message-ID: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
has been integrated in bh_read() helper, so switch to use it directly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext2/balloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index c17ccc19b938..5dc0a31f4a08 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -126,6 +126,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
 	ext2_fsblk_t bitmap_blk;
+	int ret;
 
 	desc = ext2_get_group_desc(sb, block_group, NULL);
 	if (!desc)
@@ -139,10 +140,10 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (likely(bh_uptodate_or_lock(bh)))
+	ret = bh_read(bh, 0);
+	if (ret > 0)
 		return bh;
-
-	if (bh_submit_read(bh) < 0) {
+	if (ret < 0) {
 		brelse(bh);
 		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
-- 
2.31.1

