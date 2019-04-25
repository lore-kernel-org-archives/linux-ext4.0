Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B7BC10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA9982084B
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rKK8QIMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbfDYLYC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33259 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbfDYLYB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:01 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190425112359epoutp04655bdbd95c99277ee127d522430461f2~Ys95zQs4S0936909369epoutp04h;
        Thu, 25 Apr 2019 11:23:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190425112359epoutp04655bdbd95c99277ee127d522430461f2~Ys95zQs4S0936909369epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191439;
        bh=KLOEKjb5V5E+T1HtUcoX4RHlie7JdKqebqAxB4h+Ixw=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=rKK8QIMbjRaNrbD0uYlU7ZyFFoZbdVig7RvapLtWC+5C1KKwF9OAHZNTCvmTJuq5E
         iw/5yXQsDPbKEu1bP++k6q8ZGaGRM/2o8JtGXBhDGF2dJ8BT+RtKCIKVqCkSTNHfdK
         2JMDhd5m1nuanjJij5C6ysDma0H5iDJ7r2cZ3RWw=
Received: from epsmges1p3.samsung.com (unknown [182.195.42.55]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112358epcas1p1a77b97033ef3e40fad5746b6919d9d3f~Ys95YKGMe2830228302epcas1p1R;
        Thu, 25 Apr 2019 11:23:58 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.9E.04143.EC891CC5; Thu, 25 Apr 2019 20:23:58 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112358epcas1p13da4f182241366c309cb2c76df3fb048~Ys95AHiQQ3094630946epcas1p1z;
        Thu, 25 Apr 2019 11:23:58 +0000 (GMT)
X-AuditID: b6c32a37-f31ff7000000102f-28-5cc198ce5896
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p1new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 6D.BF.03598.EC891CC5; Thu, 25 Apr
        2019 20:23:58 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:23:58 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 3/7] block: introduce API to register stream information
 with block-layer
Date:   Thu, 25 Apr 2019 16:49:58 +0530
Message-id: <1556191202-3245-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCmnu65GQdjDN5f1bX4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGRumb2QsWM9f8X31KpYGxp88XYycHBICJhLdR5ewdjFycQgJ7GCU+HTnKTtI
        QkjgO6PEvtWVMEWT/p5ngSjawChx8fpmNghnOpPE9lcdQBkODjYBTYkLk0tB4iICcxgllu2b
        xgzSzSwQIrHiySoWEFtYIE7iV/dBMJtFQFXiy5HdYNt4BZwkXu34xQqxTU7i5rlOsF5OAWeJ
        Fz+eMYEMlRDoYZOYdfAzI0SRi8Tki0eZQBZLCEhLXDpqCxEulvh15ygzRH0Ho8T1hpksEAl7
        iYt7/jJBHMQn8e5rDytEL69ER5sQhOkh8WmmPsRf04Babzxlm8AosYCRYRWjWGpBcW56arFh
        gbFecWJucWleul5yfu4mRnBUaZnvYNxwzucQowAHoxIPr0LkgRgh1sSy4srcQ4wSHMxKIrzq
        pgdjhHhTEiurUovy44tKc1KLDzFKc7AoifOud3COERJITyxJzU5NLUgtgskycXBKNTD2brP1
        VRa1vcoe++gcf+KFzhemHw395K9KWu9/uDhxZ6X2SW99374w/sQvR48vd2A8wBd/SuHIdxOh
        mJzQtp8fC7b/zMpuvuZ/U7Pk3LQjq9ZrOjC7y13rW/729CP5/ogt5vt4dMIVpW3srNvu7V4t
        tDHR586ECT6nGsTuPX9qo5V2bMF5yzdKLMUZiYZazEXFiQB+MoyApgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoO65GQdjDNY9FLT4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGRumb2QsWM9f8X31KpYGxp88XYycHBICJhKT/p5n6WLk4hASWMco8er5GVYI
        ZyaTxIkr19i6GDk42AQ0JS5MLgWJiwjMYZTo2b2eFaSbWSBEYtazx2wgtrBAnMSv7oMsIDaL
        gKrElyO72UFsXgEniVc7frFCbJOTuHmukxnE5hRwlnjx4xkTiC0EVHNt2ib2CYw8CxgZVjFK
        phYU56bnFhsVGOallusVJ+YWl+al6yXn525iBAbOtsNafTsY7y+JP8QowMGoxMN7IfZAjBBr
        YllxZe4hRgkOZiURXnXTgzFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW/nHYsUEkhPLEnNTk0t
        SC2CyTJxcEo1MKqKHRMwVcmc+M3TVWPD298sO2VmuxjeP2LAZrTl4+SNB05kxCtZV2rmt+ZK
        P328+9Waq5fFP0v+rbq3Rtgge+KXacrJKR6cS7qe9n9ZYnptx/WJk344a23dYPNW6e3EC/Iu
        JtXNe7Y92GoRrin19qd2h80Rlvt37q+L/Nn0eJ+Td8Lutsv1McVKLMUZiYZazEXFiQDt5mUU
        GAIAAA==
X-CMS-MailID: 20190425112358epcas1p13da4f182241366c309cb2c76df3fb048
CMS-TYPE: 101P
X-CMS-RootMailID: 20190425112358epcas1p13da4f182241366c309cb2c76df3fb048
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112358epcas1p13da4f182241366c309cb2c76df3fb048@epcas1p1.samsung.com>
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
index 2826225..5b6cb9747 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -340,6 +340,7 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
+	unsigned short		nr_streams;
 };
 
 #ifdef CONFIG_BLK_DEV_ZONED
@@ -1064,6 +1065,7 @@ extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern void blk_queue_stream_limits(struct request_queue *q, unsigned short);
 
 /*
  * Number of physical segments as sent to the device.
-- 
2.7.4

