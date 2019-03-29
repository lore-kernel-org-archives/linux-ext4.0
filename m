Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0157C4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5AE2186A
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ndlrwYuZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfC2H6G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:58:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22059 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbfC2H6A (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:58:00 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190329075756epoutp02e3049f6b1b71f877ff6d28fc120e19f8~QXvTEMoOB0251002510epoutp02x;
        Fri, 29 Mar 2019 07:57:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190329075756epoutp02e3049f6b1b71f877ff6d28fc120e19f8~QXvTEMoOB0251002510epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846276;
        bh=o2dx41Jhej6AqxcttNIRSbItvBM9G6Zdz2rRQgL4ChM=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=ndlrwYuZ/sX4+kSIrfHkkY0qgl8ya4DrXs4GVr7ffCZK0laiFkqB4d+Pe04FDVywi
         q2PKp7hTWxFwADQyx6pj0bohiLUr6JyQ67/Vs7c94LrhMVf1S2NaMG44bFlH7i4C0a
         Q2vkqpjUp1UOgurTr+IiTA0JXTmgUwJ2QsmpB40w=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075756epcas2p210aace814bd6c7972388c31e6e2e199f~QXvSfDiyP3185131851epcas2p2y;
        Fri, 29 Mar 2019 07:57:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.F1.04207.400DD9C5; Fri, 29 Mar 2019 16:57:56 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075755epcas2p2d2670db217ae3519d2c4b93d5e3749d1~QXvSND9UU1387513875epcas2p2X;
        Fri, 29 Mar 2019 07:57:55 +0000 (GMT)
X-AuditID: b6c32a48-689ff7000000106f-45-5c9dd0046a3b
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.CF.03620.300DD9C5; Fri, 29 Mar 2019 16:57:55 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:55 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 5/7] fs: introduce APIs to enable sending write-hint with
 buffer-head
Date:   Fri, 29 Mar 2019 13:23:50 +0530
Message-id: <1553846032-4451-6-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCmhS7LhbkxBm9fsVv8nj6F1eL/nmNs
        Fkf/v2WzOP/2MJPF3lvaFjPn3WGz2LP3JIvF5V1z2CzmL3vKbnFlyiJmBy6Pic3v2D12zrrL
        7rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZTz7eYm14JFwxcZHE5kaGE8KdDFyckgI
        mEhsaZ7L0sXIxSEksINRYtmHC+wQzndGiVfP1jHCVLWc/8sIkdjNKPHs1Q4WkISQwHQmiQeH
        DLsYOTjYBDQlLkwuBakREZgDNGnfNGaQGmaBcom/U64ygtQIC0RJbJnID2KyCKhK3G2LBang
        FXCSuPWjjx1ilZzEzXOdYJ2cAs4SH683gx0nIbCATWL3t/ssEEUuEq1vbzJD2NISz1ZthLqz
        WOLXnaPMEA0djBLXG2ZCNdhLXNzzlwniHj6JjsN/2UGOkBDglehoE4Io8ZA48GYKK8SP0xgl
        Ji04xjaBUWIBI8MqRrHUguLc9NRiowITveLE3OLSvHS95PzcTYzg6NPy2MF44JzPIUYBDkYl
        Ht4Pu+fECLEmlhVX5h5ilOBgVhLhDTw3N0aINyWxsiq1KD++qDQntfgQozQHi5I470PpudFC
        AumJJanZqakFqUUwWSYOTqkGxmmlTOUBf6fuLHC8EHDybrKj2YPVyQnbp+gdS0p/XMd8eONZ
        nfv3bc5ODzpbtD2I64HCAyEjm/mff57oTG6SEJ2dd0SVpz3fTOjDy12rXGf8mZo6Tau3fcn6
        h8bbHl16GZL7UPK586NKuaQnofaul3xX9krNN9lQvdHrwctPIWHRT58sNTFoFFFiKc5INNRi
        LipOBACcwuDuugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jAV3mC3NjDHb+N7L4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgynj28xJrwSPhio2PJjI1MJ4U6GLk5JAQ
        MJFoOf+XsYuRi0NIYCejxIOFn5hBEkICM5kkbpzi72Lk4GAT0JS4MLkUpEZEYA6jRM/u9awg
        cWaBcokpmzhBTGGBKIktE8GqWQRUJe62xYIM4RVwkrj1o48dYpOcxM1znWDDOQWcJT5eb2aB
        WOQksfZ+A/sERp4FjAyrGCVTC4pz03OLjQqM8lLL9YoTc4tL89L1kvNzNzECA2vbYa3+HYyP
        l8QfYhTgYFTi4Z2xc06MEGtiWXFl7iFGCQ5mJRHewHNzY4R4UxIrq1KL8uOLSnNSiw8xSnOw
        KInz8ucfixQSSE8sSc1OTS1ILYLJMnFwSjUwluZvMzrWueXpofBT9wUMNknvX+S5fJNg+BpT
        re1F7CtP/d1+yL+feepN5emp56eoFOz67VpncW5y/5RlGnliU6IP7I5nmmZvtHw+R29l66Xq
        O1t28MzfJnph883sK2KfnPaHLo8NCW/elZi5YQKDv67Yvd7tCyT94jdWRF+bG25nWZwZ8Pjh
        byWW4oxEQy3mouJEAB+RxC4oAgAA
X-CMS-MailID: 20190329075755epcas2p2d2670db217ae3519d2c4b93d5e3749d1
CMS-TYPE: 102P
X-CMS-RootMailID: 20190329075755epcas2p2d2670db217ae3519d2c4b93d5e3749d1
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075755epcas2p2d2670db217ae3519d2c4b93d5e3749d1@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

submit_bh and write_dirty_buffer do not take write-hint as parameter.
This introduces variants which do, and pass write-hint down.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/buffer.c                 | 18 ++++++++++++++++--
 include/linux/buffer_head.h |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 52d024b..19cf910 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3094,6 +3094,13 @@ int submit_bh(int op, int op_flags, struct buffer_head *bh)
 }
 EXPORT_SYMBOL(submit_bh);
 
+int submit_bh_write_hint(int op, int op_flags, struct buffer_head *bh,
+			 enum rw_hint hint)
+{
+	return submit_bh_wbc(op, op_flags, bh, hint, NULL);
+}
+EXPORT_SYMBOL(submit_bh_write_hint);
+
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
  * @op: whether to %READ or %WRITE
@@ -3151,6 +3158,13 @@ EXPORT_SYMBOL(ll_rw_block);
 
 void write_dirty_buffer(struct buffer_head *bh, int op_flags)
 {
+	write_dirty_buffer_with_hint(bh, op_flags, 0);
+}
+EXPORT_SYMBOL(write_dirty_buffer);
+
+void write_dirty_buffer_with_hint(struct buffer_head *bh, int op_flags,
+				   enum rw_hint hint)
+{
 	lock_buffer(bh);
 	if (!test_clear_buffer_dirty(bh)) {
 		unlock_buffer(bh);
@@ -3158,9 +3172,9 @@ void write_dirty_buffer(struct buffer_head *bh, int op_flags)
 	}
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
-	submit_bh(REQ_OP_WRITE, op_flags, bh);
+	submit_bh_wbc(REQ_OP_WRITE, op_flags, bh, hint, NULL);
 }
-EXPORT_SYMBOL(write_dirty_buffer);
+EXPORT_SYMBOL(write_dirty_buffer_with_hint);
 
 /*
  * For a data-integrity writeout, we need to wait upon any in-progress I/O
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73ef7..3d682ac 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -200,7 +200,10 @@ void ll_rw_block(int, int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int op_flags);
 void write_dirty_buffer(struct buffer_head *bh, int op_flags);
+void write_dirty_buffer_with_hint(struct buffer_head *bh, int op_flags,
+				   enum rw_hint hint);
 int submit_bh(int, int, struct buffer_head *);
+int submit_bh_write_hint(int, int, struct buffer_head *, enum rw_hint hint);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-- 
2.7.4

