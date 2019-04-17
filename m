Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA6FC282DC
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9CB2064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ESyRflBl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733268AbfDQRyB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:54:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49153 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733216AbfDQRyA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:54:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190417175357epoutp01e11dbaf51e9069fa95238330b4b9370b~WVIGzXioN1672816728epoutp01b;
        Wed, 17 Apr 2019 17:53:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190417175357epoutp01e11dbaf51e9069fa95238330b4b9370b~WVIGzXioN1672816728epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523637;
        bh=yngJd/i4HDdpI6vpdDUMKHnT/4qweub0+lvxLfq26PE=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=ESyRflBlWa1xymU3US7nf6Q5SPw+fF859uskVDBoPONzkvYoSTnTfnDCOdHrfBmh6
         lBX8AAAkUNk5ZHaavViaYiGqkkIaNpcKyDh7YriU1S6BIxGg9InQmmbCZh80RG2Vmw
         BBeswvUBkIiUj6IBFCF4MHxmCvo73Ey0qYg4udCU=
Received: from epsmges2p1.samsung.com (unknown [182.195.42.69]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175356epcas2p4ad63924958516c6cbc040dbe0f76a339~WVIGIZyIa2024920249epcas2p4F;
        Wed, 17 Apr 2019 17:53:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.A3.04195.43867BC5; Thu, 18 Apr 2019 02:53:56 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190417175355epcas2p182a8626924a911310f7584d564d0a1ec~WVIFcJ_yt1198411984epcas2p1N;
        Wed, 17 Apr 2019 17:53:55 +0000 (GMT)
X-AuditID: b6c32a45-d47ff70000001063-1c-5cb76834277f
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.EF.03620.33867BC5; Thu, 18 Apr 2019 02:53:55 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:55 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 3/7] block: introduce API to register stream information
 with block-layer
Date:   Wed, 17 Apr 2019 23:20:02 +0530
Message-id: <1555523406-2380-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdljTQtckY3uMwbL/ShZH/79ls9h7S9ti
        5rw7bBZ79p5ksbi8aw6bxfxlT9ktrkxZxOzA7rF5Sb1H35ZVjB6fN8kFMEdx2aSk5mSWpRbp
        2yVwZbxbv4mxYC1/xfwtjg2M33m6GDk5JARMJBqO7mPuYuTiEBLYwSjxpaeLEcL5zihxfkcD
        E0zV1tafTBCJ3YwSZ55cB0sICUxnklg0X7+LkYODTUBT4sLkUpAaEYE5jBLL9k1jBqlhFrCT
        mPHtNSuILSwQJ3GpbReYzSKgKvHuyCqwObwCThLzl59mhVgmJ3HzXCdYL6eAs8SjK7fYQIZK
        CPxllThz5zojRJGLRNeu88wQtrTEs1UboeLFEr/uHGWGaOhglLjeMJMFImEvcXHPXyaIi/gk
        Og7/ZQe5WkKAV6KjTQiixEOi83YvC8SX0xglJlw+zDyBUWIBI8MqRrHUguLc9NRiowJDveLE
        3OLSvHS95PzcTYzgaNJy3cE445zPIUYBDkYlHt4VqttjhFgTy4orcw8xSnAwK4nwOqZsiRHi
        TUmsrEotyo8vKs1JLT7EKM3BoiTO+0h6brSQQHpiSWp2ampBahFMlomDU6qB8bgV046Y2gMh
        Fb/5lrv6L3zxX2H9gmcL7NriLDO2aAeu4A57EjfrXIbzWf4gZr+7yixfOqtPrdsakLZlyl6D
        8gfvlqRv5/i96miedUTy8d8FTgvzqpmXWNbOuZnF98OjJ6JasO7Wwi9GP46L/mH/pDov8NDW
        oCux9VOjOq5bXuBYV9Qm2BKQrMRSnJFoqMVcVJwIACFHEemiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t9jAV3jjO0xBmdP6lkc/f+WzWLvLW2L
        mfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDu8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqk
        b5fAlfFu/SbGgrX8FfO3ODYwfufpYuTkkBAwkdja+pOpi5GLQ0hgJ6NE35uNLCAJIYGZTBKt
        D4u7GDk42AQ0JS5MLgWpERGYwyjRs3s9K0gNs4CdxIxvr8FsYYE4iUttu8BsFgFViXdHVjGB
        2LwCThLzl59mhVgmJ3HzXCcziM0p4Czx6MotNohdThKnV/1hn8DIs4CRYRWjZGpBcW56brFR
        gVFearlecWJucWleul5yfu4mRmCobDus1b+D8fGS+EOMAhyMSjy8K1S3xwixJpYVV+YeYpTg
        YFYS4XVM2RIjxJuSWFmVWpQfX1Sak1p8iFGag0VJnJc//1ikkEB6YklqdmpqQWoRTJaJg1Oq
        gTFw3YNzAn+iVJq1TiXUslcutA92WZw82ex9kgWjoqj2rXkX72W7uJnXr8xYefbkzQWC/7od
        A3b+eN2WPmWB/q0A26b9ex5xvJBUa+h61Gp+f7XtnEDJ5rUyXy/EfVXMC5RVbrbZOy3Hq3ZV
        56f67ueK/4/9m+PvtYrTIOrn5Kwf3zt5Pn+4cEqJpTgj0VCLuag4EQDJqtP7EQIAAA==
X-CMS-MailID: 20190417175355epcas2p182a8626924a911310f7584d564d0a1ec
CMS-TYPE: 102P
X-CMS-RootMailID: 20190417175355epcas2p182a8626924a911310f7584d564d0a1ec
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175355epcas2p182a8626924a911310f7584d564d0a1ec@epcas2p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This introduces stream limit (count of streams supported by underlying
driver) in request-queue.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-settings.c   | 12 ++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6375afa..6023229 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -231,6 +231,18 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
 /**
+ * blk_queue_stream_limits - set stream parameters
+ * @q:  the request queue for the device
+ * @nr_streams: number of streams supported by device
+ **/
+void blk_queue_stream_limits(struct request_queue *q,
+		unsigned short nr_streams)
+{
+	q->limits.nr_streams = nr_streams;
+}
+EXPORT_SYMBOL(blk_queue_stream_limits);
+
+/**
  * blk_queue_max_write_same_sectors - set max sectors for a single write same
  * @q:  the request queue for the device
  * @max_write_same_sectors: maximum number of sectors to write per command
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f200aed..eb6eb60 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -340,6 +340,7 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
+	unsigned short		nr_streams;
 };
 
 #ifdef CONFIG_BLK_DEV_ZONED
@@ -1065,6 +1066,7 @@ extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern void blk_queue_stream_limits(struct request_queue *q, unsigned short);
 
 /*
  * Number of physical segments as sent to the device.
-- 
2.7.4

