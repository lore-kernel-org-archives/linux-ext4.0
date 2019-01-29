Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63415C282CD
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 02:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2334A214DA
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 02:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfA2CFk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 21:05:40 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54181 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfA2CFk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 21:05:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TJBK5Nz_1548727532;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TJBK5Nz_1548727532)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Jan 2019 10:05:37 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-ext4@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] ext4: unlock unused_pages timely when doing writeback
Date:   Tue, 29 Jan 2019 10:05:31 +0800
Message-Id: <20190129020531.1665-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In mpage_add_bh_to_extent(), when accumulated extents length is greater
than MAX_WRITEPAGES_EXTENT_LEN or buffer head's b_stat is not equal, we
will not continue to search unmapped area for this page, but note this
page is locked, and will only be unlocked in mpage_release_unused_pages()
after ext4_io_submit, if io also is throttled by blk-throttle or similar
io qos, we will hold this page locked for a while, it's unnecessary.

I think the best fix is to refactor mpage_add_bh_to_extent() to let it
return some hints whether to unlock this page, but given that we will
improve dioread_nolock later, we can let it done later, so currently
the simple fix would just call mpage_release_unused_pages() before
ext4_io_submit().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/ext4/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e0703cc6..83a0d7c76736 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2836,12 +2836,12 @@ static int ext4_writepages(struct address_space *mapping,
 		goto unplug;
 	}
 	ret = mpage_prepare_extent_to_map(&mpd);
+	/* Unlock pages we didn't use */
+	mpage_release_unused_pages(&mpd, false);
 	/* Submit prepared bio */
 	ext4_io_submit(&mpd.io_submit);
 	ext4_put_io_end_defer(mpd.io_submit.io_end);
 	mpd.io_submit.io_end = NULL;
-	/* Unlock pages we didn't use */
-	mpage_release_unused_pages(&mpd, false);
 	if (ret < 0)
 		goto unplug;
 
@@ -2909,10 +2909,11 @@ static int ext4_writepages(struct address_space *mapping,
 			handle = NULL;
 			mpd.do_map = 0;
 		}
-		/* Submit prepared bio */
-		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
 		mpage_release_unused_pages(&mpd, give_up_on_write);
+		/* Submit prepared bio */
+		ext4_io_submit(&mpd.io_submit);
+
 		/*
 		 * Drop our io_end reference we got from init. We have
 		 * to be careful and use deferred io_end finishing if
-- 
2.17.2

