Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B17C282DC
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 271822064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Zr2TJVQq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733285AbfDQRyE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:54:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28409 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733270AbfDQRyD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:54:03 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20190417175359epoutp03f78333186bdd1d4bb01fdf95db1377e1~WVIJCLpJL0261502615epoutp03Q;
        Wed, 17 Apr 2019 17:53:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20190417175359epoutp03f78333186bdd1d4bb01fdf95db1377e1~WVIJCLpJL0261502615epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523639;
        bh=NoFKI2vIGHfk5Szl9zBT5VVk2EURUjmYsy+rBSCVOUY=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=Zr2TJVQqJCbNGWkScQRLJhD6EainYO2OPj2Mf+CzLWTdzM4I1z8N67jqtHa/y1o88
         fnXgKeqJMjugo6/is0mpd0ZPGrQ11NcFKiEx91a2FcDV1LY0+Ct9xUUEE66Xjzsl/a
         tkkLVqx7kE9wKC++AyGlGqChZCGoG9BoHLO2S7ys=
Received: from epsmges1p2.samsung.com (unknown [182.195.42.54]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190417175358epcas1p1cd9027f37a2bf7190c73320797a91cf7~WVIINUeHK1874118741epcas1p1B;
        Wed, 17 Apr 2019 17:53:58 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.BB.04142.63867BC5; Thu, 18 Apr 2019 02:53:58 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604~WVIHpBTbN1781617816epcas1p4Y;
        Wed, 17 Apr 2019 17:53:58 +0000 (GMT)
X-AuditID: b6c32a36-cf9ff7000000102e-52-5cb768362621
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.11.03598.63867BC5; Thu, 18 Apr 2019 02:53:58 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:57 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 4/7] block: introduce write-hint to stream-id conversion
Date:   Wed, 17 Apr 2019 23:20:03 +0530
Message-id: <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhTT9csY3uMwdtPehZH/79ls9h7S9ti
        5rw7bBZ79p5ksbi8aw6bxfxlT9ktrkxZxOzA7rF5Sb1H35ZVjB6fN8kFMEdx2aSk5mSWpRbp
        2yVwZTx+/Ie5YLtgxdRzr9gaGJfxdTFycEgImEgsP6TYxcjFISSwg1Fi/bdfLBDOd0aJtiNz
        mbsYOcGKLkz9wg6R2M0ocWXmByhnOpPEjC9N7CCj2AQ0JS5MLgWJiwjMYZRYtm8aWDezgJ3E
        jG+vWUFsYQFvicb2JUwgNouAqkTLz51sIDavgJPEytMnWCG2yUncPNcJ1ssp4Czx6MotNpCh
        EgJ/WSUaF1xihyhykZg2/zQzxA/SEpeO2kKEiyV+3TnKDFHfwShxvWEmC0TCXuLinr9MEAfx
        Sbz72sMK0csr0dEmBFHiIXH83lGox6YxSrRs/8U8gVFiASPDKkax1ILi3PTUYsMCI73ixNzi
        0rx0veT83E2M4GjSMtvBuOiczyFGAQ5GJR5eBo3tMUKsiWXFlbmHGCU4mJVEeB1TtsQI8aYk
        VlalFuXHF5XmpBYfYpTmYFES513v4BwjJJCeWJKanZpakFoEk2Xi4JRqYOzvTi03/dqy28Wl
        vGnnoW+RZzyPqMWx3tI0vfmiNMhpx5Jbs2vbDM5FcBsftBd7pnN+vg1n5J+5E8Q/SrGX254L
        SG5ZVcGepX35zqlb74S5zfymvasP2vCFkyHKIuFmzwenhd/LxQSCCqfMXjjpBuPq1zXrJdcH
        HnoVIvLmAJtoIO/HEgP+PUosxRmJhlrMRcWJAGmHz6KiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xgK5ZxvYYg2u9HBZH/79ls9h7S9ti
        5rw7bBZ79p5ksbi8aw6bxfxlT9ktrkxZxOzA7rF5Sb1H35ZVjB6fN8kFMEdx2aSk5mSWpRbp
        2yVwZTx+/Ie5YLtgxdRzr9gaGJfxdTFyckgImEhcmPqFvYuRi0NIYCejxPNZF9ggnJlMEjs+
        32DuYuTgYBPQlLgwuRQkLiIwh1GiZ/d6VpBuZgE7iRnfXoPZwgLeEo3tS5hAbBYBVYmWnzvZ
        QGxeASeJladPsEJsk5O4ea6TGcTmFHCWeHTlFliNEFDN6VV/2Ccw8ixgZFjFKJlaUJybnlts
        VGCYl1quV5yYW1yal66XnJ+7iREYLtsOa/XtYLy/JP4QowAHoxIP7wrV7TFCrIllxZW5hxgl
        OJiVRHgdU7bECPGmJFZWpRblxxeV5qQWH2KU5mBREue9nXcsUkggPbEkNTs1tSC1CCbLxMEp
        1cDI/n1i4Tyj0t3PXqvVbVs491TBSfvfVi8zc7wkL88uzu1lmnFvkt5B6y3KJl33pM/wBO5e
        WDqP8UBT3qx179UZvK28JVVbZXcG5QR03v9pJjc5422moemrH1umsLZmrU6P0Fp2sTmrvVPL
        Q8D11X8n38VHG6N+b3H59u//S+MplpENM2KXCM1VYinOSDTUYi4qTgQAS7yOxRMCAAA=
X-CMS-MailID: 20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604
CMS-TYPE: 101P
X-CMS-RootMailID: 20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch moves write-hint-to-stream-id conversion in block-layer.
Earlier this was done by driver (nvme). Current conversion is of the
form "streamid = write-hint - 1", for both user and kernel streams.
Conversion takes stream limit (maintained in request queue) into
account. Write-hints beyond the exposed limit turn to 0.
A new field 'streamid' has been added in request. While 'write-hint'
field continues to exist. It keeps original value passed from upper
layer, and used during merging checks.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-core.c       | 20 ++++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index a55389b..712e6b7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -730,6 +730,25 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	return false;
 }
 
+enum rw_hint blk_write_hint_to_streamid(struct request *req,
+				        struct bio *bio)
+{
+	enum rw_hint streamid, nr_streams;
+	struct request_queue *q = req->q;
+	nr_streams = q->limits.nr_streams;
+
+	streamid = bio->bi_write_hint;
+	if (!nr_streams || streamid == WRITE_LIFE_NOT_SET ||
+	    streamid == WRITE_LIFE_NONE)
+		streamid = 0;
+	else {
+		--streamid;
+		if(streamid > nr_streams)
+			streamid = 0;
+	}
+	return streamid;
+}
+
 void blk_init_request_from_bio(struct request *req, struct bio *bio)
 {
 	if (bio->bi_opf & REQ_RAHEAD)
@@ -738,6 +757,7 @@ void blk_init_request_from_bio(struct request *req, struct bio *bio)
 	req->__sector = bio->bi_iter.bi_sector;
 	req->ioprio = bio_prio(bio);
 	req->write_hint = bio->bi_write_hint;
+	req->streamid = blk_write_hint_to_streamid(req, bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
 EXPORT_SYMBOL_GPL(blk_init_request_from_bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eb6eb60..7cd1c2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -217,6 +217,7 @@ struct request {
 #endif
 
 	unsigned short write_hint;
+	unsigned short streamid;
 	unsigned short ioprio;
 
 	unsigned int extra_len;	/* length of alignment and padding */
-- 
2.7.4

