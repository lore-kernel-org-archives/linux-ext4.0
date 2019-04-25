Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959AFC282E1
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603D020645
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lW7KeMC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfDYLYK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33282 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387580AbfDYLYI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:08 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190425112404epoutp045b25d253735467c4670790affac7533f~Ys9_TRUfL0936909369epoutp04j;
        Thu, 25 Apr 2019 11:24:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190425112404epoutp045b25d253735467c4670790affac7533f~Ys9_TRUfL0936909369epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191444;
        bh=GkSqbdrDJV1STm2bKdKjWIfP93iOF5XNeEs045WX1h8=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=lW7KeMC3Idq49/+l6VZ1og8T2CThtWxP1qO9lDiZc77vtklVYQWVxw5Ngkhf8A90B
         T0bwRVTBqjlBwY1TdHW2zlZb3pXIV2JlcOe1EmzhLkjIHKMmgmd3/1og5G8ZMN617I
         BpmZQ+E1/jOzy+6oK0UrHb74h2R/wdYyBqq6UvRA=
Received: from epsmges1p2.samsung.com (unknown [182.195.42.54]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190425112403epcas1p2e03bab8b9169e8cf575401bd63da598c~Ys9_CJ7Qg0216202162epcas1p2P;
        Thu, 25 Apr 2019 11:24:03 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.D7.04142.3D891CC5; Thu, 25 Apr 2019 20:24:03 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112403epcas1p13006198cda351a08c8403c2b85c9f102~Ys99wKxS91172511725epcas1p1U;
        Thu, 25 Apr 2019 11:24:03 +0000 (GMT)
X-AuditID: b6c32a36-ce1ff7000000102e-85-5cc198d35208
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p1new.samsung.com
        (Symantec Messaging Gateway) with SMTP id CE.BF.03598.3D891CC5; Thu, 25 Apr
        2019 20:24:03 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:24:03 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 5/7] nvme: register stream info with block layer
Date:   Thu, 25 Apr 2019 16:50:00 +0530
Message-id: <1556191202-3245-6-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCmge7lGQdjDDbd0bH4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGUdPbGAuuCZYsW3hFOYGxot8XYycHBICJhKzOp6ydTFycQgJ7GCUuNyxmxHC
        +c4ocXzfRmaYqt1NWxlBbCGBDYwSU1/nQBRNZ5J4cHoKUIKDg01AU+LC5FKQuIjAHEaJZfum
        gTUzC4RIrHiyigWkRljAWeLWTxOQMIuAqkT7wh2sIDavgJPE+7UrWCB2yUncPNcJ1soJVP7i
        xzMmkJkSAo1sEgv+3GeCKHKReP/5LdheCQFpiUtHbSHCxRK/7hxlhqjvYJS43jATaqi9xMU9
        f5kg7uGTePe1hxWil1eio00IwvSQ+Lk2C+KtaYwSs6dvZ5vAKLGAkWEVo1hqQXFuemqxYYGR
        XnFibnFpXrpecn7uJkZwTGmZ7WBcdM7nEKMAB6MSD69C5IEYIdbEsuLK3EOMEhzMSiK86qYH
        Y4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzrndwjhESSE8sSc1OTS1ILYLJMnFwSjUwLnaeNrFi
        79Hdz6bNkT28qjLX1N/rw/n9r61uT/Hbv4zLpfB2vPnPsHWHnf6qPznZ/7r4yWe3h1lL+sV2
        nT7fkN+rvMn4+Jnrm/19KrVy1657dvO/0PwpZ/bmNhrtd3t1cF2s36Vfz+qXnFqdINOz//ya
        /L/qX86uvt1mZ6kX7RAw+3SU/rwJJieVWIozEg21mIuKEwEy5fJypQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xoO7lGQdjDN5tlrD4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGUdPbGAuuCZYsW3hFOYGxot8XYycHBICJhK7m7YydjFycQgJrGOUaHkzjQnC
        mckk8XnhFKAMBwebgKbEhcmlIHERgTmMEj2717OCdDMLhEjMevaYDaRGWMBZ4tZPE5Awi4Cq
        RPvCHWAlvAJOEu/XrmCBWCYncfNcJzOIzQlU/uLHMyYQWwio5tq0TewTGHkWMDKsYpRMLSjO
        Tc8tNiowzEst1ytOzC0uzUvXS87P3cQIDJtth7X6djDeXxJ/iFGAg1GJh/dC7IEYIdbEsuLK
        3EOMEhzMSiK86qYHY4R4UxIrq1KL8uOLSnNSiw8xSnOwKInz3s47FikkkJ5YkpqdmlqQWgST
        ZeLglGpg1L3sbJI267X39/MCkn5bolYdSOH3sgleo7r+eciBFdPKH7hu7PjP8laoNDGvKSm1
        sc68gbeqprThqO2vtzcvf427w8X913pJiLN6Mn9SqPM6j7vLJwu+YJx+bffNKRmvne48OHnw
        opbC4evLV168udA9e/XmuTqZ95fZm4QJPJ/w6VVf6eLri5RYijMSDbWYi4oTAWbZlXwXAgAA
X-CMS-MailID: 20190425112403epcas1p13006198cda351a08c8403c2b85c9f102
CMS-TYPE: 101P
X-CMS-RootMailID: 20190425112403epcas1p13006198cda351a08c8403c2b85c9f102
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112403epcas1p13006198cda351a08c8403c2b85c9f102@epcas1p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Make nvme driver register number of streams with block layer. Block
layer will use that for write-hint to stream-id conversion. Registration
is done for each namespace. Since NVMe spec allow all available
streams (within subsystem) to be used by all namespaces, no attempt
has been made to add reservation at namespace level.
Also driver no longer disables stream feature if device reported less
than 4 streams. Any write-hint beyond exported number of streams will
be mapped to 0 by block layer.
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f3000d9..81b86fa 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -464,10 +464,6 @@ static int nvme_toggle_streams(struct nvme_ctrl *ctrl, bool enable)
 	return nvme_submit_sync_cmd(ctrl->admin_q, &c, NULL, 0);
 }
 
-static int nvme_disable_streams(struct nvme_ctrl *ctrl)
-{
-	return nvme_toggle_streams(ctrl, false);
-}
 
 static int nvme_enable_streams(struct nvme_ctrl *ctrl)
 {
@@ -510,14 +506,7 @@ static int nvme_configure_directives(struct nvme_ctrl *ctrl)
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
@@ -3186,6 +3175,7 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 {
 	struct streams_directive_params s;
 	int ret;
+	u16 nr_streams;
 
 	if (!ctrl->nr_streams)
 		return 0;
@@ -3197,6 +3187,8 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 	ns->sws = le32_to_cpu(s.sws);
 	ns->sgs = le16_to_cpu(s.sgs);
 
+	nr_streams = min_t(unsigned, ctrl->nr_streams, BLK_MAX_WRITE_HINTS - 1);
+	blk_queue_stream_limits(ns->queue, nr_streams);
 	if (ns->sws) {
 		unsigned int bs = 1 << ns->lba_shift;
 
-- 
2.7.4

