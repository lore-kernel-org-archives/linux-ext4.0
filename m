Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB0BC636D7
	for <linux-ext4@archiver.kernel.org>; Thu, 23 Feb 2023 08:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjBWIZa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjBWIZ3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Feb 2023 03:25:29 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C5C279A3
        for <linux-ext4@vger.kernel.org>; Thu, 23 Feb 2023 00:25:27 -0800 (PST)
Received: from dggpeml500016.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PMmHL6Z7Dz16Ns6;
        Thu, 23 Feb 2023 16:22:54 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500016.china.huawei.com
 (7.185.36.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 23 Feb
 2023 16:25:25 +0800
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>, zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH] lib/ext2fs: add some msg for io error
Date:   Thu, 23 Feb 2023 16:48:41 +0800
Message-ID: <20230223084841.584231-1-zhanchengbin1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add msgs to show whether there is eio in fsck process, when write and
fsync methods fail.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
 lib/ext2fs/unix_io.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 3171c736..d0ab3689 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1265,12 +1265,17 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 		return errno;
 
 	actual = write(data->dev, buf, size);
+
 	if (actual < 0)
-		return errno;
+		retval = errno;
 	if (actual != size)
-		return EXT2_ET_SHORT_WRITE;
+		retval = EXT2_ET_SHORT_WRITE;
 
 	return 0;
+
+	fprintf(stderr, "%s unix_write_byte error, error %d\n",
+			channel->name, errno);
+	return retval;
 }
 
 /*
@@ -1289,8 +1294,11 @@ static errcode_t unix_flush(io_channel channel)
 	retval = flush_cached_blocks(channel, data, 0);
 #endif
 #ifdef HAVE_FSYNC
-	if (!retval && fsync(data->dev) != 0)
+	if (!retval && fsync(data->dev) != 0) {
+		fprintf(stderr, "%s flush error, error %d\n",
+				channel->name, errno);
 		return errno;
+	}
 #endif
 	return retval;
 }
-- 
2.31.1

