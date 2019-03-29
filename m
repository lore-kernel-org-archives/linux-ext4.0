Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6573BC4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 338F32183E
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pdd5xlD8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfC2H5v (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:57:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48426 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfC2H5u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:57:50 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190329075747epoutp01bfda0d45c888b4a62685db863e232d71~QXvJ_MoV90504405044epoutp01e;
        Fri, 29 Mar 2019 07:57:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190329075747epoutp01bfda0d45c888b4a62685db863e232d71~QXvJ_MoV90504405044epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846267;
        bh=3ABOjlv0lfK3kx85YYrNVqMMcVW6sZA4ZmppvdcM598=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=pdd5xlD8o7DTvUNMNMd/PqF9PypJhYGe9+1mqD8K4n+1El1qTvTTC4+HY1IZtdhfD
         YAa4NhCvDZ62bpSMwuutwaC7VOdB8JGIvKXOLdkwf6f6E2ilObcel4u4PmPjx6GzOn
         iYeLWmaESUZQ2hCCe6tNU/2oJJ+iYnuvasHgiTRM=
Received: from epsmges1p4.samsung.com (unknown [182.195.42.56]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075746epcas1p2fb83ec41e21b545c68e7a893a5e1ff50~QXvJhQqcL1199211992epcas1p2I;
        Fri, 29 Mar 2019 07:57:46 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.BB.04257.AFFCD9C5; Fri, 29 Mar 2019 16:57:46 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190329075746epcas1p19e5a93c1f593b5fed3f98eddf9159aa5~QXvJUveL93185131851epcas1p1l;
        Fri, 29 Mar 2019 07:57:46 +0000 (GMT)
X-AuditID: b6c32a38-5e3ff700000010a1-c2-5c9dcffa3684
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.7F.03598.AFFCD9C5; Fri, 29 Mar 2019 16:57:46 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:46 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 2/7] block: introduce API to register stream information
 with block layer
Date:   Fri, 29 Mar 2019 13:23:47 +0530
Message-id: <1553846032-4451-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCmru6v83NjDA5NVLD4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyli74hdLwSqOirPnbjM2MP5i62Lk5JAQ
        MJFY2nmEuYuRi0NIYAejxKct71khnO+MEs93HGPqYuQAqzo2PxykQUhgN6PEuRWSEDXTmSTW
        /HnNDFLDJqApcWFyKUhcRGAOo8SyfdOYQRqYBcol/k65yghiCwvESXS37wbbzCKgKvHh1XMW
        EJtXwEnibt9aFoiL5CRunusE6+UUcJb4eL2ZBWSohMASNokFU58xQhS5SBzY0cUKcZy0xKWj
        thDhYolfd44yQ9R3MEpcb5gJNdRe4uKev0wQB/FJvPvaA9XLK9HRJgRR4iGxcNMsFojHpjFK
        dL05yTiBUWIBI8MqRrHUguLc9NRiwwITveLE3OLSvHS95PzcTYzg6NOy2MG455zPIUYBDkYl
        Ht4ZO+fECLEmlhVX5h5ilOBgVhLhDTw3N0aINyWxsiq1KD++qDQntfgQozQHi5I473oH5xgh
        gfTEktTs1NSC1CKYLBMHp1QDY+NdDtZl/09UnrTYt+NAf+66Ur1dTU8+3XQu+7y/2jVuwZEP
        fpPYgyc7SMl9cLv5tlPTnVXkm/ZXTpH9C0VPH7j1kH2a5a11bUdvqTRPU5e/VvLF9fjrKNNp
        HQWLNCKKJnyWWvZb98X7a9seNqbddlpUz/07qI+rePHMEn6jowsOnBYJv2XHkKfEUpyRaKjF
        XFScCACWpPfYugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd1f5+fGGJxbIGzxe/oUVov/e46x
        WRz9/5bN4vzbw0wWe29pW8ycd4fNYs/ekywWl3fNYbOYv+wpu8WVKYuYHbg8Jja/Y/fYOesu
        u8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlbF2xS+WglUcFWfP3WZsYPzF1sXIwSEh
        YCJxbH54FyMXh5DATkaJmw3fWSGcmUwS/asnMIEUsQloSlyYXAoSFxGYwyjRs3s9K0icWaBc
        Ysomzi5GTg5hgTiJ7vbdbCA2i4CqxIdXz1lAbF4BJ4m7fWvBbAkBOYmb5zqZQWxOAWeJj9eb
        weJCQDVr7zewT2DkWcDIsIpRMrWgODc9t9iowDAvtVyvODG3uDQvXS85P3cTIzC4th3W6tvB
        eH9J/CFGAQ5GJR7eGTvnxAixJpYVV+YeYpTgYFYS4Q08NzdGiDclsbIqtSg/vqg0J7X4EKM0
        B4uSOO/tvGORQgLpiSWp2ampBalFMFkmDk6pBkaVx2dzb8WzaZk6yU8x/9P1U7Tzx5K8Bclt
        R7KkdWaYmO+46uFf+kF/64PLle26d6fuCli0m+vbsfueM0pYPdxmVvwsl9/Y/0s7bMrmYEnL
        YoZfH855RplbneubpnPu6AVpjXtXtr8qVLh/UEQl6w7z93trk1jmiz9SC72Zd/lH4F226svr
        LY2UWIozEg21mIuKEwGf7nWnKgIAAA==
X-CMS-MailID: 20190329075746epcas1p19e5a93c1f593b5fed3f98eddf9159aa5
CMS-TYPE: 101P
X-CMS-RootMailID: 20190329075746epcas1p19e5a93c1f593b5fed3f98eddf9159aa5
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075746epcas1p19e5a93c1f593b5fed3f98eddf9159aa5@epcas1p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This associates stream limit (count of streams exposed by driver) with
request queue.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-settings.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3e7038e..bb0da61 100644
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
-- 
2.7.4

