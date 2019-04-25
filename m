Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3ACC10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003182084B
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CX2upkFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbfDYLYL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30699 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387620AbfDYLYL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:11 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190425112406epoutp01fdcef32e667086729f27c1b7a49aa4e2~Ys_AqWt091904819048epoutp01h;
        Thu, 25 Apr 2019 11:24:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190425112406epoutp01fdcef32e667086729f27c1b7a49aa4e2~Ys_AqWt091904819048epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191446;
        bh=LslFbD0lwD/9SQNcuMJl+Vtr6HxJKs3jycHzydcCwpE=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=CX2upkFrOZ/YwIy/oJ16XhFhIKKpiWCihFDyZjgsM7ue4UBbzgl8hP9YsKmRXTuCK
         ZrVc9KyK38HDy0yWNS7pInHhd0F/tSSal5112dUM3hgMyT8qNTM2DFPGwyQx/tfWpM
         4Ef+1iKErFRY3o0DBvr4Ohq9zfidZCd7oVQKGNeI=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20190425112406epcas1p379af84defcdee33c109eb4d7d59e92e1~Ys_AXDg7k2352823528epcas1p33;
        Thu, 25 Apr 2019 11:24:06 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.10.04139.6D891CC5; Thu, 25 Apr 2019 20:24:06 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190425112406epcas1p4a54b2c5d15ae42a53ff3c206cf7a7892~Ys_AMy97V2380823808epcas1p4V;
        Thu, 25 Apr 2019 11:24:06 +0000 (GMT)
X-AuditID: b6c32a35-98bff7000000102b-05-5cc198d63200
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p1new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 7F.BF.03598.5D891CC5; Thu, 25 Apr
        2019 20:24:06 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:24:05 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 6/7] fs: introduce APIs to enable passing write-hint with
 buffer-head
Date:   Thu, 25 Apr 2019 16:50:01 +0530
Message-id: <1556191202-3245-7-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCmnu61GQdjDBpvClj8nj6F1eLo/7ds
        FntvaVvMnHeHzWLP3pMsFpd3zWGzmL/sKbvFlSmLmB04PDYvqffo27KK0ePzJrkA5igum5TU
        nMyy1CJ9uwSujMX9q5kL3ghXLH+7hK2B8aJAFyMnh4SAicTUBS+Zuxi5OIQEdjBKnF94jQ3C
        +c4o8er9T6YuRg6wqmftoSANQgIbGCW2PoyCsKczSdx9YQ5SwiagKXFhcilIq4jAHEaJZfum
        MYPUMAuESKx4sooFxBYWiJJY8fQNG4jNIqAq0Tf5O1gNr4CTxJ11TWwQB8lJ3DzXCRbnFHCW
        ePHjGRPIUAmBRjaJ/03nGCHucZF4tFQAwpSWuHTUFqK1WOLXnaPMEOUdjBLXG2ayQCTsJS7u
        +csEcQ+fxLuvPawQvbwSHW1CECUeEv8nvGKEeH0ao8SXru+sExglFjAyrGIUSy0ozk1PLTYs
        MNQrTswtLs1L10vOz93ECI4oLdMdjFPO+RxiFOBgVOLhVYg8ECPEmlhWXJl7iFGCg1lJhFfd
        9GCMEG9KYmVValF+fFFpTmrxIUZpDhYlcd71Ds4xQgLpiSWp2ampBalFMFkmDk6pBsZ9v35u
        Sno5Q3bKtlZxkyaGlo8Ttn3cHjij51iMl6jn5O/O75MUZ6g2sE4v1J6arT5L23HDTP6jjsUb
        5n6vO/N81gKm92y/HlpafFrGcjjSrp41Qruz1vbzwetFG+6/Pla4Ka6pcdHBTPXu1NtiyaXz
        hLfd9mDUfFo3L+MRV2vp8wcnPjqU3alSYinOSDTUYi4qTgQAFhaWh6QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e+xoO61GQdjDJqCLX5Pn8JqcfT/WzaL
        vbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDhwem5fUe/RtWcXo8XmTXABzFJdNSmpO
        Zllqkb5dAlfG4v7VzAVvhCuWv13C1sB4UaCLkYNDQsBE4ll7aBcjJ4eQwDpGicNHLbsYuYDs
        mUwS3z9PYwSpYRPQlLgwuRQkLiIwh1GiZ/d6VpAGZoEQiVnPHrOB2MICURIrnr4Bs1kEVCX6
        Jn9nBrF5BZwk7qxrAotLCMhJ3DzXCRbnFHCWePHjGRPEYieJa9M2sU9g5FnAyLCKUTK1oDg3
        PbfYqMAwL7Vcrzgxt7g0L10vOT93EyMwZLYd1urbwXh/SfwhRgEORiUe3guxB2KEWBPLiitz
        DzFKcDArifCqmx6MEeJNSaysSi3Kjy8qzUktPsQozcGiJM57O+9YpJBAemJJanZqakFqEUyW
        iYNTqoFRb1qKbr/c5CpR+7f1t24LxkY5GZu47J51RYDxCENI2COBrWEx9auaHr23ZIw9WLpd
        xCjpys1JvGdkdfpFpixl86n2vrKlUkJlhfH2yyI21yI5d65aaPCq+QUn64tCP7enXaUPZHqS
        3/65+GXzFH/rORpZnnsNPnbtOzH1/bv5iWvnnPe/fi1biaU4I9FQi7moOBEAZpu6dhUCAAA=
X-CMS-MailID: 20190425112406epcas1p4a54b2c5d15ae42a53ff3c206cf7a7892
CMS-TYPE: 101P
X-CMS-RootMailID: 20190425112406epcas1p4a54b2c5d15ae42a53ff3c206cf7a7892
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112406epcas1p4a54b2c5d15ae42a53ff3c206cf7a7892@epcas1p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

submit_bh and write_dirty_buffer do not take write-hint as parameter.
This introduces variants which do, and pass write-hint to lower layer.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/buffer.c                 | 18 ++++++++++++++++--
 include/linux/buffer_head.h |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ce35760..dc1ea59 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3105,6 +3105,13 @@ int submit_bh(int op, int op_flags, struct buffer_head *bh)
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
@@ -3162,6 +3169,13 @@ EXPORT_SYMBOL(ll_rw_block);
 
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
@@ -3169,9 +3183,9 @@ void write_dirty_buffer(struct buffer_head *bh, int op_flags)
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

