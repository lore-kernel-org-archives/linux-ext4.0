Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC22AC10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 821B220645
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AAYrDUkT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbfDYLYf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30678 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387545AbfDYLYE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:04 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190425112401epoutp0154f3efce8b08a5c57f52a4872319583e~Ys976J_2g1904819048epoutp01f;
        Thu, 25 Apr 2019 11:24:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190425112401epoutp0154f3efce8b08a5c57f52a4872319583e~Ys976J_2g1904819048epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191441;
        bh=4S6KChIBk/IqG41ydTdXRNYQIbozJTHYfmrQ7Y29Fy0=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=AAYrDUkThUv+58pIWELgbqysEharMon4iX4btuzrVtKp++QDF6hYi4CWunIcsFtY/
         CNqeYCEVVKIxChsSGsGf8P3WOJThjnRHs1NWJ4pPFigqo4GEaPR7uAYt8oR3skGl99
         uLhEryKhRDC4G4GFbgAb+BIS+yEDk+j/28ZeXuMU=
Received: from epsmges1p2.samsung.com (unknown [182.195.42.54]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190425112400epcas1p468414a681f5575952ec05e4abb0f1f1b~Ys97bOP_X2380823808epcas1p4H;
        Thu, 25 Apr 2019 11:24:00 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.D7.04142.0D891CC5; Thu, 25 Apr 2019 20:24:00 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190425112400epcas1p26e7634f95a185a83c31470006d291161~Ys97JOliC0718107181epcas1p22;
        Thu, 25 Apr 2019 11:24:00 +0000 (GMT)
X-AuditID: b6c32a36-ce1ff7000000102e-7d-5cc198d09ab8
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p1new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 1E.BF.03598.0D891CC5; Thu, 25 Apr
        2019 20:24:00 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:24:00 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 4/7] block: introduce write-hint to stream-id conversion
Date:   Thu, 25 Apr 2019 16:49:59 +0530
Message-id: <1556191202-3245-5-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCmru6FGQdjDL59MLP4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGa8n7GIpmKlYcfrde/YGxibpLkZODgkBE4nOh4dYuhi5OIQEdjBKXJn4Esr5
        zijxq3suE0xVy+79bBCJDYwSX38vZwVJCAlMZ5I4dSyui5GDg01AU+LC5FKQGhGBOYwSy/ZN
        YwapYRYIkVjxZBULiC0s4C2xec4vsDiLgKrEyZ4XbCC9vAJOEgs+CEPskpO4ea4TrIRTwFni
        xY9nTCAzJQQ62CRer1/ADlHkIvHsWBsLSK+EgLTEpaO2EOFiiV93jjJD1TNKXG+YyQKRsJe4
        uOcvE8Q9fBLvvvawQvTySnS0CUGUeEjsebedCeLHaYwS0961M05glFjAyLCKUSy1oDg3PbXY
        sMBIrzgxt7g0L10vOT93EyM4qrTMdjAuOudziFGAg1GJh1ch8kCMEGtiWXFl7iFGCQ5mJRFe
        ddODMUK8KYmVValF+fFFpTmpxYcYpTlYlMR51zs4xwgJpCeWpGanphakFsFkmTg4pRoYJYs/
        XV3wPPi63bOZFcwnZgrMTlnqf+eej/9jmyX98jPbYlJX3H+6nOnSNYZNT3/dXy1SznjJ9NeH
        Q4dv7md/svW6wJ5H3C6pP+c+7rnAOH8LTw9z9Y35S9jseR5aRFlKH90QvGP22/Jbakqvr235
        J7r35+rl7zMOzll7carTmmdsJj8OrVyU/r9SiaU4I9FQi7moOBEAwGk3waYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xoO6FGQdjDH7PV7X4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGa8n7GIpmKlYcfrde/YGxibpLkZODgkBE4mW3fvZuhi5OIQE1jFKNM3dxQLh
        zGSSePzzIVMXIwcHm4CmxIXJpSBxEYE5jBI9u9ezgnQzC4RIzHr2mA3EFhbwltg85xcziM0i
        oCpxsucFG0gvr4CTxIIPwhDL5CRunusEK+EUcJZ48eMZE4gtBFRybdom9gmMPAsYGVYxSqYW
        FOem5xYbFRjmpZbrFSfmFpfmpesl5+duYgSGzbbDWn07GO8viT/EKMDBqMTDeyH2QIwQa2JZ
        cWXuIUYJDmYlEV5104MxQrwpiZVVqUX58UWlOanFhxilOViUxHlv5x2LFBJITyxJzU5NLUgt
        gskycXBKNTBK35jqYRryorTJ/l/dC+mrZ36Z/1r234L5tnRJxmetrby97jvnGB7c9WJtVGQ2
        x8mitqwisQNL2q+xy33qnNYkWD3fbueeaNvUprj3dZOPKW25t7Ioa8KpFw28yU2fTvx6Lv77
        /YFZbdyaH+6V8x08tmP2JIncDQ6WzFVbvgXdeCpoZmvz4e0eJZbijERDLeai4kQA1T38wRcC
        AAA=
X-CMS-MailID: 20190425112400epcas1p26e7634f95a185a83c31470006d291161
CMS-TYPE: 101P
X-CMS-RootMailID: 20190425112400epcas1p26e7634f95a185a83c31470006d291161
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112400epcas1p26e7634f95a185a83c31470006d291161@epcas1p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch moves write-hint-to-stream-id conversion in block-layer.
Earlier this was done by driver (nvme). For user write-hints, conversion
is of the form "streamid = write-hint - 1". For kernel write-hints,
streams are allocated in top-to-bottom fashion. This has the effect of
mapping user-hints to lower range of stream-ids and kernel-hints to upper
range of stream-ids.
Conversion takes stream limit (maintained in request queue) into
account. Write-hints beyond the exposed limit turn to 0.
A new field 'streamid' has been added in request, while 'write-hint'
field has been removed. For merging checks, 'bi_write_hint' (of bio) is
used instead.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-core.c         | 29 ++++++++++++++++++++++++++++-
 block/blk-merge.c        |  4 ++--
 drivers/nvme/host/core.c |  7 ++-----
 include/linux/blkdev.h   |  2 +-
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a55389b..0485c20 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -730,6 +730,33 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	return false;
 }
 
+enum rw_hint blk_write_hint_to_streamid(struct request *req,
+					struct bio *bio)
+{
+	enum rw_hint streamid, write_hint, nr_streams;
+	struct request_queue *q = req->q;
+
+	nr_streams = q->limits.nr_streams;
+
+	write_hint = bio->bi_write_hint;
+
+	if (!nr_streams || write_hint == WRITE_LIFE_NOT_SET ||
+	    write_hint == WRITE_LIFE_NONE)
+		streamid = 0;
+	else if (write_hint < WRITE_LIFE_KERN_MIN) { /*user-space hints*/
+		streamid = write_hint - 1;
+		if (streamid > nr_streams)
+			streamid = 0;
+	} else { /* kernel hints */
+		streamid = write_hint - WRITE_LIFE_KERN_MIN + 1;
+		if (streamid > (nr_streams - BLK_MAX_USER_HINTS))
+			streamid = 0;
+		else
+			streamid = nr_streams - streamid + 1;
+	}
+	return streamid;
+}
+
 void blk_init_request_from_bio(struct request *req, struct bio *bio)
 {
 	if (bio->bi_opf & REQ_RAHEAD)
@@ -737,7 +764,7 @@ void blk_init_request_from_bio(struct request *req, struct bio *bio)
 
 	req->__sector = bio->bi_iter.bi_sector;
 	req->ioprio = bio_prio(bio);
-	req->write_hint = bio->bi_write_hint;
+	req->streamid = blk_write_hint_to_streamid(req, bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
 EXPORT_SYMBOL_GPL(blk_init_request_from_bio);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1c9d4f0..1435634 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -832,7 +832,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	 * Don't allow merge of different write hints, or for a hint with
 	 * non-hint IO.
 	 */
-	if (req->write_hint != next->write_hint)
+	if (req->bio->bi_write_hint != next->bio->bi_write_hint)
 		return NULL;
 
 	if (req->ioprio != next->ioprio)
@@ -964,7 +964,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	 * Don't allow merge of different write hints, or for a hint with
 	 * non-hint IO.
 	 */
-	if (rq->write_hint != bio->bi_write_hint)
+	if (rq->bio->bi_write_hint != bio->bi_write_hint)
 		return false;
 
 	if (rq->ioprio != bio_prio(bio))
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2c43e12..f3000d9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -530,12 +530,9 @@ static void nvme_assign_write_stream(struct nvme_ctrl *ctrl,
 				     struct request *req, u16 *control,
 				     u32 *dsmgmt)
 {
-	enum rw_hint streamid = req->write_hint;
+	enum rw_hint streamid = req->streamid;
 
-	if (streamid == WRITE_LIFE_NOT_SET || streamid == WRITE_LIFE_NONE)
-		streamid = 0;
-	else {
-		streamid--;
+	if (streamid != 0) {
 		if (WARN_ON_ONCE(streamid > ctrl->nr_streams))
 			return;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5b6cb9747..9cf8a40 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,7 +216,7 @@ struct request {
 	unsigned short nr_integrity_segments;
 #endif
 
-	unsigned short write_hint;
+	unsigned short streamid;
 	unsigned short ioprio;
 
 	unsigned int extra_len;	/* length of alignment and padding */
-- 
2.7.4

