Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EC2C4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B9D2183E
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Tkpb0z8s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfC2H5s (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:57:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48382 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbfC2H5r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:57:47 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190329075744epoutp01d139dea2c4a5c27df3797dbf3d58439c~QXvHKRxPr0504405044epoutp01Z;
        Fri, 29 Mar 2019 07:57:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190329075744epoutp01d139dea2c4a5c27df3797dbf3d58439c~QXvHKRxPr0504405044epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846264;
        bh=GMWfG/UFPIw6K5QHny8wOIAe2Q2tBotihJWkxHDsKe4=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=Tkpb0z8sX5Kw/Mstec0Yd3FHOBZBZ6Yw4/mV22puAUs0P+CkMoHWLOVyC6oiO9qTK
         yzXwcqZjLfAeO8ScssuUwgBhybO482TAoJ1f8OBAjcyBNjlml75euMMo3a21/9e0WC
         O/jLp24hF5SFgFCNv32IZ1FwanDP4eftvPpk1t88=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075743epcas1p2279b119a3e51bab134f1ecf65ea1a9b3~QXvG8OPrT0065800658epcas1p2P;
        Fri, 29 Mar 2019 07:57:43 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.45.04139.7FFCD9C5; Fri, 29 Mar 2019 16:57:43 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74~QXvGh3lDq0562405624epcas1p1X;
        Fri, 29 Mar 2019 07:57:43 +0000 (GMT)
X-AuditID: b6c32a35-98bff7000000102b-27-5c9dcff7a16f
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.7F.03598.7FFCD9C5; Fri, 29 Mar 2019 16:57:43 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:43 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 1/7] block: extend stream count for in-kernel use
Date:   Fri, 29 Mar 2019 13:23:46 +0530
Message-id: <1553846032-4451-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCmvu7383NjDFbs1rX4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgytj/I7/gKW/Fkc4O1gbGLdxdjJwcEgIm
        EjcX/GTsYuTiEBLYwSix4N83ZpCEkMB3Rol716tgiq59X80KUbSbUeLF9jNQznQmiTPPu4E6
        ODjYBDQlLkwuBYmLCMxhlFi2bxrYJGaBcom/U64ygtjCAi4S25vOMoHYLAKqEn9vvmEDsXkF
        nCQmzP7KDrFNTuLmuU6wXk4BZ4mP15tZQIZKCCxhk3i95goLRJGLRPeMC+wgiyUEpCUuHbWF
        CBdL/LpzlBmivoNR4nrDTKh6e4mLe/4yQRzEJ/Huaw8rRC+vREebEESJh8TyP89ZIb6fxihx
        9YHrBGCAMDKsYhRLLSjOTU8tNiww1CtOzC0uzUvXS87P3cQIjj0t0x2MU875HGIU4GBU4uGd
        sXNOjBBrYllxZe4hRgkOZiUR3sBzc2OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8653cI4REkhP
        LEnNTk0tSC2CyTJxcEo1MGZ4FDUmHyv3UzBxFLozj3lqX39R4aT4Azy1bz6f2iC6b8WKQMZc
        xd0PPBZs6WVW+lXRqHvtMC/jvCf/vCvv/Hqav6ytec/7nc/5f7yTuPD2/nE/oUmW2rrfNqjH
        Bj1n3/qSbfniMNZZt9S2d23NedrfveLV4UX1vquuejLx1x30+9j2xGJPi7ESS3FGoqEWc1Fx
        IgCWunMuuQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd3v5+fGGNy5KGTxe/oUVov/e46x
        WRz9/5bN4vzbw0wWe29pW8ycd4fNYs/ekywWl3fNYbOYv+wpu8WVKYuYHbg8Jja/Y/fYOesu
        u8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlbH/R37BU96KI50drA2MW7i7GDk5JARM
        JK59X83axcjFISSwk1Hi7INnbBDOTCaJh2dWsXcxcnCwCWhKXJhcChIXEZjDKNGzez0rSJxZ
        oFxiyiZOkEHCAi4S25vOMoHYLAKqEn9vvmEDsXkFnCQmzP7KDrFMTuLmuU5mEJtTwFni4/Vm
        FhBbCKhm7f0G9gmMPAsYGVYxSqYWFOem5xYbFRjmpZbrFSfmFpfmpesl5+duYgQG17bDWn07
        GO8viT/EKMDBqMTDO2PnnBgh1sSy4srcQ4wSHMxKIryB5+bGCPGmJFZWpRblxxeV5qQWH2KU
        5mBREue9nXcsUkggPbEkNTs1tSC1CCbLxMEp1cBo8aaMs9P85Kmrv9hOh4jaTSz1XDLz70GJ
        5PKH+78LRifzKMc6P+9n41Q1DE8Pyf02f5Lzc+1jy99L3Hc7PyfmYvon+x0PeP8nOl7Pv/jv
        Tegr17vqk7lO3ZivW5g31/9sR9hR9tUBUStcLv0verch7mKD7u6jpRt/t0aFMJ+1fRU5uTbq
        wrStSizFGYmGWsxFxYkACYMGAioCAAA=
X-CMS-MailID: 20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74
CMS-TYPE: 101P
X-CMS-RootMailID: 20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74@epcas1p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch bumps up stream count to suppor in-kernel hints. It also
adds 'streamid' member in 'request' and declares new API for driver
to register stream-info with block layer.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/blkdev.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 338604d..4088e21 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -214,6 +214,7 @@ struct request {
 #endif
 
 	unsigned short write_hint;
+	unsigned short streamid;
 	unsigned short ioprio;
 
 	void *special;		/* opaque pointer available for LLD use */
@@ -341,6 +342,8 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
+
+	unsigned short		nr_streams;
 	enum blk_zoned_model	zoned;
 };
 
@@ -567,8 +570,9 @@ struct request_queue {
 	size_t			cmd_size;
 
 	struct work_struct	release_work;
-
-#define BLK_MAX_WRITE_HINTS	5
+#define BLK_MAX_USER_HINTS	(WRITE_LIFE_KERN_MIN - 2)
+#define BLK_MAX_KERN_HINTS	4
+#define BLK_MAX_WRITE_HINTS	(1 + BLK_MAX_USER_HINTS + BLK_MAX_KERN_HINTS)
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
 };
 
@@ -1071,6 +1075,7 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern void blk_queue_stream_limits(struct request_queue *, unsigned short);
 
 /*
  * Number of physical segments as sent to the device.
-- 
2.7.4

