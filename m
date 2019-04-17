Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB53C282DC
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E0B217FA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="utQTg6aR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfDQRyW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:54:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28413 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733279AbfDQRyE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:54:04 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20190417175400epoutp039229c55c9036ac787189769926a830bc~WVIKGH-RF3159031590epoutp03B;
        Wed, 17 Apr 2019 17:54:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20190417175400epoutp039229c55c9036ac787189769926a830bc~WVIKGH-RF3159031590epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523640;
        bh=iP0XOFxFxW4dqp5UudF4yA1+ezdoL5xyOuz+dgVM6Tk=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=utQTg6aRbKNBBC9fzqCj2hW7USv6659s2321i8+619vSmhLL2jhdOjys5Z6CFOyUr
         PjErWBJFBEjehKAACrAz93nleSqYTRAajMhSyUSPovD1EIyEJNfJWDA5y9kkRIamBq
         +NzcyemLet2TAgmlkK8VdDbX3z2DdL1NQgExKdQg=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20190417175400epcas2p38ccb0c4ea4da9aedfb7bf2270190b367~WVIJ0XxbZ1769817698epcas2p3M;
        Wed, 17 Apr 2019 17:54:00 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.64.04206.83867BC5; Thu, 18 Apr 2019 02:54:00 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3~WVIJci7c93108131081epcas2p2U;
        Wed, 17 Apr 2019 17:54:00 +0000 (GMT)
X-AuditID: b6c32a47-14bff7000000106e-16-5cb76838c683
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.EF.03620.73867BC5; Thu, 18 Apr 2019 02:54:00 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:59 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 5/7] nvme: register stream info with block layer
Date:   Wed, 17 Apr 2019 23:20:04 +0530
Message-id: <1555523406-2380-6-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdljTTNciY3uMQecXGYuj/9+yWey9pW0x
        c94dNos9e0+yWFzeNYfNYv6yp+wWV6YsYnZg99i8pN6jb8sqRo/Pm+QCmKO4bFJSczLLUov0
        7RK4Mg49+M1c8EW4YmWHQAPjIoEuRk4OCQETiTU7njB3MXJxCAnsYJR41LCWCcL5zihx6O8s
        VpiqvStnsoHYQgK7GSVmvw6EKJrOJPF4fxNQEQcHm4CmxIXJpSBxEYE5jBLL9k1jBmlgFrCT
        mPHtNdggYQFnid4H09lBbBYBVYlNT7cwgdi8Ak4Sk57uZ4JYJidx81wnWC8nUP2jK7fYQIZK
        CPxklbgwZxILRJGLxJs509ghbGmJZ6s2MkLYxRK/7hxlhmjoYJS43jATqsFe4uKev0wQF/FJ
        dBz+yw5ytYQAr0RHmxBEiYdEW9tlqPenMUq0PXvMPIFRYgEjwypGsdSC4tz01GKjAmO94sTc
        4tK8dL3k/NxNjOBo0nLfwbjtnM8hRgEORiUe3hWq22OEWBPLiitzDzFKcDArifA6pmyJEeJN
        SaysSi3Kjy8qzUktPsQozcGiJM77UHputJBAemJJanZqakFqEUyWiYNTqoFRgfvEjrYyscMN
        37j0DQMFJ095Gq6oN/fKvuPJdv25GxY/STLbxBxtYpjLVvSt7tz68327LGw92bbXVzHb/A3O
        bnPZ+0HR58Cx0On/7gVcnWb95mr3+T19pVxuj+XsFJslvYTLzhaUPzv5/rmR8Zf7t9NMn9/d
        9f5NwJK45Zw/37r82fTj1PTrSizFGYmGWsxFxYkArtk3pKICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAV2LjO0xBtfeMFsc/f+WzWLvLW2L
        mfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDu8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqk
        b5fAlXHowW/mgi/CFSs7BBoYFwl0MXJySAiYSOxdOZOti5GLQ0hgJ6PEs1ONzBDOTCaJk6tn
        sXQxcnCwCWhKXJhcChIXEZjDKNGzez0rSDezgJ3EjG+vwWxhAWeJ3gfT2UFsFgFViU1PtzCB
        2LwCThKTnu5ngtgmJ3HzXCcziM0JVP/oyi02EFsIqOb0qj/sExh5FjAyrGKUTC0ozk3PLTYq
        MMpLLdcrTswtLs1L10vOz93ECAyWbYe1+ncwPl4Sf4hRgINRiYd3her2GCHWxLLiytxDjBIc
        zEoivI4pW2KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8/LnH4sUEkhPLEnNTk0tSC2CyTJxcEo1
        MG68JtycU3HGyL/ks6jW1mvNXwOvCbwN+V4S5/R+78svhsz2yyqWpZtteNeg48J3ao/RBDkh
        /v8X9Yya1y5/xKl0o4H3fs6fST0qjieKtitdlvwiqHqD40O8e28Ke1HdFLHtE8v+O53WLV5z
        Y+N/e74NX9bO598bKyBSnRD1re2Qv9Ay28nfU5VYijMSDbWYi4oTAS4871MSAgAA
X-CMS-MailID: 20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3
CMS-TYPE: 102P
X-CMS-RootMailID: 20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175400epcas2p2b166bfaef69f5a02e856743be76199f3@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Make nvme driver register number of streams with block layer. Block
layer will use that for write-hint to stream-id conversion. Registration
is done for each namespace. Since NVMe spec allow all available
streams (within subsystem) to be used by all namespaces, no attempt
has been made to add reservation at namespace level.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2c43e12..81b86fa 100644
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
@@ -530,12 +519,9 @@ static void nvme_assign_write_stream(struct nvme_ctrl *ctrl,
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
 
@@ -3189,6 +3175,7 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 {
 	struct streams_directive_params s;
 	int ret;
+	u16 nr_streams;
 
 	if (!ctrl->nr_streams)
 		return 0;
@@ -3200,6 +3187,8 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns)
 	ns->sws = le32_to_cpu(s.sws);
 	ns->sgs = le16_to_cpu(s.sgs);
 
+	nr_streams = min_t(unsigned, ctrl->nr_streams, BLK_MAX_WRITE_HINTS - 1);
+	blk_queue_stream_limits(ns->queue, nr_streams);
 	if (ns->sws) {
 		unsigned int bs = 1 << ns->lba_shift;
 
-- 
2.7.4

