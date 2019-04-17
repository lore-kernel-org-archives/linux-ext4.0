Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05EEC282DC
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711882064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Expsd6mc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbfDQRyH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:54:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49165 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733216AbfDQRyG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:54:06 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190417175402epoutp01bb20485114e59ef6cd5e7ad93b5c4067~WVILvwO922230122301epoutp012;
        Wed, 17 Apr 2019 17:54:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190417175402epoutp01bb20485114e59ef6cd5e7ad93b5c4067~WVILvwO922230122301epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523642;
        bh=LslFbD0lwD/9SQNcuMJl+Vtr6HxJKs3jycHzydcCwpE=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=Expsd6mcV4X39Er8zOJ41wmvK5P+8cdeTn3hzxPoBKyKtPeKtfzjjMdRdMU0HfwLO
         0bjJwS9i9x2iCkPdfMLlG1kcsOBxFbLaZBy2uj3gNFup6cqFaCdT/H5aK1CHoQP+nu
         ZLYPMeCV3f5dpbZSHmzv/n7Glh4pm15uB+xWIrwY=
Received: from epsmges1p3.samsung.com (unknown [182.195.42.55]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20190417175402epcas1p306a6de5194a9d64d7753fc065d456b5b~WVILfkgYe0859308593epcas1p3Y;
        Wed, 17 Apr 2019 17:54:02 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.AE.04143.A3867BC5; Thu, 18 Apr 2019 02:54:02 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175402epcas1p450f2617234aadf24cb4c8ae184d48c68~WVILRlCsI2081320813epcas1p4L;
        Wed, 17 Apr 2019 17:54:02 +0000 (GMT)
X-AuditID: b6c32a37-f19ff7000000102f-a4-5cb7683a1bc7
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.11.03598.93867BC5; Thu, 18 Apr 2019 02:54:02 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:54:01 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 6/7] fs: introduce APIs to enable passing write-hint with
 buffer-head
Date:   Wed, 17 Apr 2019 23:20:05 +0530
Message-id: <1555523406-2380-7-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCmrq5VxvYYg/NnRC2O/n/LZrH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3WPzknqPvi2rGD0+b5ILYI7isklJzcksSy3S
        t0vgyljcv5q54I1wxfK3S9gaGC8KdDFyckgImEjMP/GQsYuRi0NIYAejxOqds1ghnO+MEnsa
        9jLDVE3rboeq2s0o8enAfiYIZzqTxOl57UBVHBxsApoSFyaXgsRFBOYwSizbNw2sm1nATmLG
        t9esILawQJTEig+tjCA2i4CqxISL89hBbF4BJ4k319qZILbJSdw81wnWyyngLPHoyi02kKES
        An9ZJVqf72aFKHKROLhiNthiCQFpiUtHbSHCxRK/7hxlhqjvYJS43jCTBSJhL3Fxz18miIP4
        JN597WGF6OWV6GgTgijxkOiee5gZ4rFpjBIvO1exT2CUWMDIsIpRLLWgODc9tdiwwFivODG3
        uDQvXS85P3cTIzietMx3MG4453OIUYCDUYmHd4Xq9hgh1sSy4srcQ4wSHMxKIryOKVtihHhT
        EiurUovy44tKc1KLDzFKc7AoifOud3COERJITyxJzU5NLUgtgskycXBKNTCW9u1/u/ql/PpJ
        LSwxj/PVfmx+/iBr/eaQx18OB+cdjn3aXyXRf6PEribR4ca6rgXCBTP/HOT2lmLYrPXYh+Xw
        2lrjyZbzC4qXG/+fnnq3ecaPTydrOI7f+Hcg6+2DXd6eU1T/dTxXncDz9aZkz4Wji2JDzjku
        N971rYV3yqY680+CXfMZy61nK7EUZyQaajEXFScCAPssPpujAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xgK5VxvYYgx3XWC2O/n/LZrH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3WPzknqPvi2rGD0+b5ILYI7isklJzcksSy3S
        t0vgyljcv5q54I1wxfK3S9gaGC8KdDFyckgImEhM625n7GLk4hAS2MkocXDmIihnJpNEw/ct
        7F2MHBxsApoSFyaXgsRFBOYwSvTsXs8K0s0sYCcx49trMFtYIEpixYdWRhCbRUBVYsLFeewg
        Nq+Ak8Sba+1MENvkJG6e62QGsTkFnCUeXbnFBmILAdWcXvWHfQIjzwJGhlWMkqkFxbnpucVG
        BYZ5qeV6xYm5xaV56XrJ+bmbGIHhsu2wVt8OxvtL4g8xCnAwKvHwrlDdHiPEmlhWXJl7iFGC
        g1lJhNcxZUuMEG9KYmVValF+fFFpTmrxIUZpDhYlcd7beccihQTSE0tSs1NTC1KLYLJMHJxS
        DYzi58/f32TSffuOa+nKVyunVKcbn//3/vPG15V/FDynMM30W5B97uzWrzmVEzhteVInBurU
        7rybU/HuGVN96blME/k99ZP0Tq2Km3r/y/deqy/+PyxthQ4mzdlrn1EVtWoFf7u/7wZ2Tv6p
        eyrq2Vw8zfQ0Xdx4vmbmXT24LOmghO/8B6I7b4spsRRnJBpqMRcVJwIA1KGVZRMCAAA=
X-CMS-MailID: 20190417175402epcas1p450f2617234aadf24cb4c8ae184d48c68
CMS-TYPE: 101P
X-CMS-RootMailID: 20190417175402epcas1p450f2617234aadf24cb4c8ae184d48c68
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175402epcas1p450f2617234aadf24cb4c8ae184d48c68@epcas1p4.samsung.com>
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

