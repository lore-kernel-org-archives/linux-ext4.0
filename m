Return-Path: <SRS0=1ImQ=76=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1D4C433E6
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Jun 2020 11:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B342206D8
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Jun 2020 11:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQL6r (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:58:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6353 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbgFQL6o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 Jun 2020 07:58:44 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F84526374A69B09578E;
        Wed, 17 Jun 2020 19:58:41 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 17 Jun 2020
 19:58:33 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <jack@suse.cz>
CC:     <adilger.kernel@dilger.ca>, <zhangxiaoxu5@huawei.com>,
        <yi.zhang@huawei.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2 1/5] fs: add bdev writepage hook to block device
Date:   Wed, 17 Jun 2020 19:59:43 +0800
Message-ID: <20200617115947.836221-2-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200617115947.836221-1-yi.zhang@huawei.com>
References: <20200617115947.836221-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add a new bdev_write_page hook into struct super_operations and called
by bdev_writepage(), which could be used by filesystem to propagate
private handlers.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/block_dev.c     | 5 +++++
 include/linux/fs.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 47860e589388..46e25a4e3ebf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -606,6 +606,11 @@ EXPORT_SYMBOL(thaw_bdev);
 
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct super_block *super = BDEV_I(page->mapping->host)->bdev.bd_super;
+
+	if (super && super->s_op->bdev_write_page)
+		return super->s_op->bdev_write_page(page, blkdev_get_block, wbc);
+
 	return block_write_full_page(page, blkdev_get_block, wbc);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cffc3619eed5..b87b784c6bc6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1983,6 +1983,7 @@ struct super_operations {
 	struct dquot **(*get_dquots)(struct inode *);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*bdev_write_page)(struct page *, get_block_t *, struct writeback_control *);
 	long (*nr_cached_objects)(struct super_block *,
 				  struct shrink_control *);
 	long (*free_cached_objects)(struct super_block *,
-- 
2.25.4

