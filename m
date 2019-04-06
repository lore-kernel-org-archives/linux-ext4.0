Return-Path: <SRS0=2wuY=SI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558D5C10F06
	for <linux-ext4@archiver.kernel.org>; Sat,  6 Apr 2019 07:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD882173C
	for <linux-ext4@archiver.kernel.org>; Sat,  6 Apr 2019 07:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfDFHJG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:09:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfDFHJG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 Apr 2019 03:09:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 67E9DF9E5D7211D795D6;
        Sat,  6 Apr 2019 15:09:03 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.408.0; Sat, 6 Apr 2019 15:08:55 +0800
From:   ZhangXiaoxu <zhangxiaoxu5@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <zhangxiaoxu5@huawei.com>
CC:     <yi.zhang@huawei.com>
Subject: [PATCH] fs/buffer.c: Fix data corruption when buffer write with IO error
Date:   Sat, 6 Apr 2019 15:13:13 +0800
Message-ID: <1554534793-31444-1-git-send-email-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When the buffer write failed, 'end_buffer_write_sync' and
'end_buffer_async_write' will clear the uptodate flag. But the
data in the buffer maybe newer than disk. In some case, this
will lead data corruption.

For example: ext4 flush metadata to disk failed, it will clear
the uptodate flag. when a new coming call want the buffer, it will
read it from the disk(because the buffer no uptodate flag). But
the journal not checkpoint now, it will read old data from disk.
If read successfully, ext4 will write the old data to the new
journal, the data will corruption.

So, don't clear the uptodate flag when write the buffer failed.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/buffer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ce35760..9fe1827 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -172,7 +172,6 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	} else {
 		buffer_io_error(bh, ", lost sync page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
 	put_bh(bh);
@@ -325,7 +324,6 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	} else {
 		buffer_io_error(bh, ", lost async page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 		SetPageError(page);
 	}
 
-- 
2.7.4

