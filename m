Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D20FC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC9E2183F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N072ZS+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfC2H57 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:57:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22029 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbfC2H56 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:57:58 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190329075754epoutp026ea0cde0c9fb5943454e57bd94f00aa3~QXvQ6ZkKX0250102501epoutp02u;
        Fri, 29 Mar 2019 07:57:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190329075754epoutp026ea0cde0c9fb5943454e57bd94f00aa3~QXvQ6ZkKX0250102501epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846274;
        bh=m/4T9WC/PqjxETlqSCQrMqU+MwhIfpKT2Hm8sepu9eU=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=N072ZS+mFgWzUBiixloK2l+90kyWTofxNDEGC5LOEI1SuxfApjSIXfRw/vG1bfr4D
         sLQp2N1JRC8it0c0d9UrctR1obquhuVal+uiJVo/mXrFhtScQxBm0IS/z3qA7/KSf4
         WkrGAcxx5nYecMkLrAzmOPDxX5c+flT4gFZVhN0M=
Received: from epsmges1p3.samsung.com (unknown [182.195.42.55]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20190329075753epcas1p3a3c11cf9e270d2158e749c2d499b962e~QXvQCOmMv2558425584epcas1p3c;
        Fri, 29 Mar 2019 07:57:53 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.34.04143.100DD9C5; Fri, 29 Mar 2019 16:57:53 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190329075753epcas1p16ce37362f83ccb8520a782b845dcb905~QXvPwS9q_1918919189epcas1p1J;
        Fri, 29 Mar 2019 07:57:53 +0000 (GMT)
X-AuditID: b6c32a37-f19ff7000000102f-9c-5c9dd0016cbc
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.7F.03598.100DD9C5; Fri, 29 Mar 2019 16:57:53 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:53 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 4/7] nvme: register stream info with block layer
Date:   Fri, 29 Mar 2019 13:23:49 +0530
Message-id: <1553846032-4451-5-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCmni7jhbkxBsvuylv8nj6F1eL/nmNs
        Fkf/v2WzOP/2MJPF3lvaFjPn3WGz2LP3JIvF5V1z2CzmL3vKbnFlyiJmBy6Pic3v2D12zrrL
        7rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZdy638tSMEmwYkP7Z6YGxp+8XYycHBIC
        JhL3n/WydzFycQgJ7GCUWNvdzQrhfGeU+P55EyNMVfuWHhaIxG5GiV2n3jOBJIQEpjNJtOxM
        7mLk4GAT0JS4MLkUpEZEYA6jxLJ905hBapgFyiX+TrkKNkhYwFni+s0usDiLgKrEw003wOK8
        Ak4SU/q+QS2Tk7h5rhOshhOo/uP1ZrDFEgJL2CQmP7vIDrJMQsBFYl+jHoQpLXHpqC1Ea7HE
        rztHmSHKOxglrjfMZIFI2Etc3POXCeIePol3X3tYIXp5JTrahCBMD4m9c2UhvprGKLFtivcE
        RokFjAyrGMVSC4pz01OLDQuM9YoTc4tL89L1kvNzNzGCI0/LfAfjhnM+hxgFOBiVeHhn7JwT
        I8SaWFZcmXuIUYKDWUmEN/Dc3Bgh3pTEyqrUovz4otKc1OJDjNIcLErivOsdnGOEBNITS1Kz
        U1MLUotgskwcnFINjLXbXLjit5cX7nUMKXY1SuE7Yb3zbk7Og7seEaIJb4zTvkXmqMm3TGT9
        97N/1qekfWFf7tYv++Yakvx490zmpHnzdv9x06ve9e75j3NJ847ohS3smikSML0hvDo73Skn
        4ADP75P+TWzf7aaU6IU2y9d6nj96sXyVlVrf3kz5OZuDDeaav7Y6o8RSnJFoqMVcVJwIAAKo
        ob+4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAV3GC3NjDC7f57L4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyrh1v5elYJJgxYb2z0wNjD95uxg5OSQE
        TCTat/SwdDFycQgJ7GSUWNOyjA3CmckkMXXXF+YuRg4ONgFNiQuTS0HiIgJzGCV6dq9nBYkz
        C5RLTNnECTJIWMBZ4vrNLmYQm0VAVeLhphuMIDavgJPElL5vjBDL5CRunusEq+EEqv94vZkF
        xBYCqll7v4F9AiPPAkaGVYySqQXFuem5xUYFhnmp5XrFibnFpXnpesn5uZsYgeG17bBW3w7G
        +0viDzEKcDAq8fDO2DknRog1say4MvcQowQHs5IIb+C5uTFCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeW/nHYsUEkhPLEnNTk0tSC2CyTJxcEo1MNpaO/f+vWAnXmA8NbVX/5eb1d/Vy/Uszfnl
        k4S7sp/vWdnw6XYF26TlG6byZBVdfy2u8He2r6Gt3p6fucp/zsmduDhX+2PWrKhLHGFHv7A3
        NYus0Tj2oWvZ/nUsbvZzZmyezaIgdfzcw1W37FuXt/0UbtS2+VX3zubyMm6GRLUCN277DRv/
        piuxFGckGmoxFxUnAgAtqzszKwIAAA==
X-CMS-MailID: 20190329075753epcas1p16ce37362f83ccb8520a782b845dcb905
CMS-TYPE: 101P
X-CMS-RootMailID: 20190329075753epcas1p16ce37362f83ccb8520a782b845dcb905
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075753epcas1p16ce37362f83ccb8520a782b845dcb905@epcas1p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

nvme registes number of streams with block layer, which will use that
for write-hint to streamid conversion. Registration is done for each
namespace. Since NVMe spec allow all available streams (within subsystem)
to be used by all namespaces, no attempt has been made to add reservation
at namespace level.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 150e497..e34386b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -513,14 +513,7 @@ static int nvme_configure_directives(struct nvme_ctrl *ctrl)
 		return ret;
 
 	ctrl->nssa = le16_to_cpu(s.nssa);
-	if (ctrl->nssa < BLK_MAX_WRITE_HINTS - 1) {
-		dev_info(ctrl->device, "too few streams (%u) available\n",
-					ctrl->nssa);
-		nvme_disable_streams(ctrl);
-		return 0;
-	}
-
-	ctrl->nr_streams = min_t(unsigned, ctrl->nssa, BLK_MAX_WRITE_HINTS - 1);
+	ctrl->nr_streams = ctrl->nssa;
 	dev_info(ctrl->device, "Using %u streams\n", ctrl->nr_streams);
 	return 0;
 }
@@ -533,12 +526,9 @@ static void nvme_assign_write_stream(struct nvme_ctrl *ctrl,
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
 
@@ -3138,6 +3128,7 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 {
 	struct streams_directive_params s;
 	int ret;
+	u16 nr_streams;
 
 	if (!ctrl->nr_streams)
 		return 0;
@@ -3149,6 +3140,8 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 	ns->sws = le32_to_cpu(s.sws);
 	ns->sgs = le16_to_cpu(s.sgs);
 
+	nr_streams = min_t(unsigned, ctrl->nr_streams, BLK_MAX_WRITE_HINTS - 1);
+	blk_queue_stream_limits(ns->queue, nr_streams);
 	if (ns->sws) {
 		unsigned int bs = 1 << ns->lba_shift;
 
-- 
2.7.4

