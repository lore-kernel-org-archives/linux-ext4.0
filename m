Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15736C282E1
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D3E2084B
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P5BvpAb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfDYLXz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:23:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30641 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfDYLXy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:23:54 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190425112351epoutp01f595b58953eedcf27a9a3c16b2d10d76~Ys9y9mY021904819048epoutp01b;
        Thu, 25 Apr 2019 11:23:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190425112351epoutp01f595b58953eedcf27a9a3c16b2d10d76~Ys9y9mY021904819048epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191431;
        bh=AW0YDDi+9LxgJJQEsuX274rekHmOC8F5v9v1EvGolgI=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=P5BvpAb7RzoNy3TvxA834wqD9+mT1wXJrxinIC8eSvLaCYe+eB+VR6ZHDonJxvLRU
         QRppgQeT/bAoHZl1h1lUvkzyGkmu3OA9cyGpxDTO/038PTLKnOxk6jzgdDLIK1maKd
         WE6tL7jSOXFAR1h59nYAwhlpkM/zyQz09zHXvVdQ=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112351epcas2p1f2722ccc0f8098dea956c5b95ed0737f~Ys9yeHBFV2287122871epcas2p1m;
        Thu, 25 Apr 2019 11:23:51 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.9C.04207.7C891CC5; Thu, 25 Apr 2019 20:23:51 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190425112351epcas2p209fdb12872bdcdcb11afd7b6e196b85e~Ys9yTzvDF3134131341epcas2p2i;
        Thu, 25 Apr 2019 11:23:51 +0000 (GMT)
X-AuditID: b6c32a48-689ff7000000106f-79-5cc198c7b760
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id F6.4D.03620.7C891CC5; Thu, 25 Apr
        2019 20:23:51 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:23:50 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 1/7] fs: introduce write-hint start point for in-kernel
 hints
Date:   Thu, 25 Apr 2019 16:49:56 +0530
Message-id: <1556191202-3245-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCmqe7xGQdjDK4uFrP4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGR1dN1kKFrJW9DTMZGxgXMfSxcjJISFgIjFl2nYgm4tDSGAHo0TXiteMEM53
        RokZRzqYYaoOLfvJDmILCWxglJi+zhqiaDqTxP15r9m6GDk42AQ0JS5MLgWJiwjMYZRYtm8a
        WDOzQIjEiierWEBqhAWCJI4uDwUJswioSjzYdAOshFfASeLc2jZGiF1yEjfPdYLFOQWcJV78
        eMYEEW9kk3h30BPCdpHY/vIcO4QtLfFs1Uao3mKJX3eOMoPcICHQwShxvWEm1Jv2Ehf3/GWC
        uIdPouPwX3aQeyQEeCU62oQgSjwk7m7fzgrx1zRGiTX71zBPYJRYwMiwilEstaA4Nz212KjA
        RK84Mbe4NC9dLzk/dxMjOKq0PHYwHjjnc4hRgINRiYdXIfJAjBBrYllxZe4hRgkOZiURXnXT
        gzFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeR9Kz40WEkhPLEnNTk0tSC2CyTJxcEo1ME6R0We1
        SZy6Sv52RuCEPMlHxhH/PB//f7Zl05876hytIXpF4ekG35hkJsy6aOz2knVd6dm/K/jDVr19
        8jyqe9ohgQ+rGQ/NlChd8Chh1tzHXZPuMIrt3+X220JE2OXU9gWcDnZ75r9IcOe8YZJY2VfI
        M/fBOfd9s0PXdntxOd/4JNmxY9nHsG1KLMUZiYZazEXFiQBhA6SepgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoO7xGQdjDB78Z7f4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGR1dN1kKFrJW9DTMZGxgXMfSxcjJISFgInFo2U/2LkYuDiGBdYwSXXv72CCc
        mUwSTa+eATkcHGwCmhIXJpeCxEUE5jBK9OxezwrSzSwQIjHr2WM2EFtYIEDiwMMesDiLgKrE
        g003mEFsXgEniXNr2xghtslJ3DzXCRbnFHCWePHjGROILQRUc23aJvYJjDwLGBlWMUqmFhTn
        pucWGxUY5aWW6xUn5haX5qXrJefnbmIEBs62w1r9OxgfL4k/xCjAwajEw6sQeSBGiDWxrLgy
        9xCjBAezkgivuunBGCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8/PnHIoUE0hNLUrNTUwtSi2Cy
        TBycUg2Mil0CC3+pfjRlEjrJfEp/xVbbaXbrAnnXBwcqruz48+GllNZJnY12dw9IPbT+fvhz
        95QX271qRbyfnYk3M2HteyV+UPb7OQmB63e5DadkrfIw/dEcpt/yTOnohHktuuJSJ6Lf8Ur/
        c5j27avU53dJfwoLDTvne0378Vxp/hm+pVfir36X6FI1U2Ipzkg01GIuKk4EAPXffksYAgAA
X-CMS-MailID: 20190425112351epcas2p209fdb12872bdcdcb11afd7b6e196b85e
CMS-TYPE: 102P
X-CMS-RootMailID: 20190425112351epcas2p209fdb12872bdcdcb11afd7b6e196b85e
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112351epcas2p209fdb12872bdcdcb11afd7b6e196b85e@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Introduce "WRITE_LIFE_KERN_MIN". Kernel mode components can define own
write-hints using this as base.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28e76..ee27eb4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -299,6 +299,8 @@ enum rw_hint {
 	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
 	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
 	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
+/* Kernel should use write-hint starting from this */
+	WRITE_LIFE_KERN_MIN,
 };
 
 #define IOCB_EVENTFD		(1 << 0)
-- 
2.7.4

