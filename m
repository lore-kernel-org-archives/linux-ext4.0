Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED96C6379F
	for <linux-ext4@archiver.kernel.org>; Thu, 23 Feb 2023 08:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjBWIhx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBWIhv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Feb 2023 03:37:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9930A10CE
        for <linux-ext4@vger.kernel.org>; Thu, 23 Feb 2023 00:37:49 -0800 (PST)
Received: from dggpeml500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PMmbt5YtSzrSF8;
        Thu, 23 Feb 2023 16:37:14 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500016.china.huawei.com
 (7.185.36.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 23 Feb
 2023 16:37:43 +0800
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>, zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH v2] lib/ext2fs: add some msg for io error
Date:   Thu, 23 Feb 2023 17:01:11 +0800
Message-ID: <20230223090111.680573-1-zhanchengbin1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add msgs to show whether there is eio in fsck process, when write and
fsync methods fail.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
v2->v1:
 - Delete return 0.

 lib/ext2fs/unix_io.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 3171c736..a6c85874 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1265,12 +1265,16 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 		return errno;
 
 	actual = write(data->dev, buf, size);
+
 	if (actual < 0)
-		return errno;
+		retval = errno;
 	if (actual != size)
-		return EXT2_ET_SHORT_WRITE;
+		retval = EXT2_ET_SHORT_WRITE;
 
-	return 0;
+	if (retval)
+		fprintf(stderr, "%s unix_write_byte error, error %d\n",
+				channel->name, errno);
+	return retval;
 }
 
 /*
@@ -1289,8 +1293,11 @@ static errcode_t unix_flush(io_channel channel)
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

