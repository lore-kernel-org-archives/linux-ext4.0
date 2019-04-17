Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579D6C282DD
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BAD42064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NpAmYO0m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733253AbfDQRx6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:53:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19367 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbfDQRx6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:53:58 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190417175354epoutp025903a323167096bff9d0bda60c7fc620~WVIEfu3OY0540005400epoutp02Q;
        Wed, 17 Apr 2019 17:53:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190417175354epoutp025903a323167096bff9d0bda60c7fc620~WVIEfu3OY0540005400epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523634;
        bh=jnasjsltYOWI5j2h9cG9IGjDl+oZ1+awrFgJ1LtSdiY=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=NpAmYO0mZcbTv7J+G27mRyyYZMGqYhKdal3UOVwgr7xsP9zbbZHB2ng7sDeVlKtrh
         5zrGJt27BHKicbwTs7Y+mcHJVQgTPINIw53zJXLKBi2ZUXHlWxlWuv3+r9LyyR7Aed
         Exa8oWh9zz3p/2trk027R985AOgULSyJGm/qWlRw=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190417175353epcas2p1054d178266c50e151c33f8a7f865ba9d~WVIDoB2E31198411984epcas2p1F;
        Wed, 17 Apr 2019 17:53:53 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.58.04207.13867BC5; Thu, 18 Apr 2019 02:53:53 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190417175353epcas2p1eaec3fea0bf26bb97416149e11b1317e~WVIDVYopJ1198411984epcas2p1E;
        Wed, 17 Apr 2019 17:53:53 +0000 (GMT)
X-AuditID: b6c32a48-689ff7000000106f-f0-5cb76831ec18
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.EF.03620.13867BC5; Thu, 18 Apr 2019 02:53:53 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:53 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 2/7] block: increase stream count for in-kernel use
Date:   Wed, 17 Apr 2019 23:20:01 +0530
Message-id: <1555523406-2380-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCmua5hxvYYg87TRhZH/79ls9h7S9ti
        5rw7bBZ79p5ksbi8aw6bxfxlT9ktrkxZxOzA7rF5Sb1H35ZVjB6fN8kFMEdx2aSk5mSWpRbp
        2yVwZbS8Eyw4ylrRtK2PsYHxJEsXIyeHhICJxNOOi0A2F4eQwA5GiYbTP5kgnO+MEjOvrGKH
        qbr55w0jRGI3o8St9haolulMEl8XzWDrYuTgYBPQlLgwuRQkLiIwh1Fi2b5pzCDdzAJ2EjO+
        vWYFsYUF3CTaZqwBm8oioCoxc+lHMJtXwEni841jUNvkJG6e6wTr5RRwlnh05RYbyFAJgZ+s
        EvOvHGaEKHKROPvxKTOELS3xbNVGqHixxK87R5khGjoYJa43zIT61F7i4p6/TBAX8Ul0HP7L
        DnK1hACvREebEESJh8SnI6+YIT6bxiixf/M/pgmMEgsYGVYxiqUWFOempxYbFZjoFSfmFpfm
        pesl5+duYgTHk5bHDsYD53wOMQpwMCrx8K5Q3R4jxJpYVlyZe4hRgoNZSYTXMWVLjBBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeh9Jzo4UE0hNLUrNTUwtSi2CyTBycUg2MW57LH5KvrnqYJvr8
        udq19ZPPPZ5+TDDiSWHAW+ePWy3qLSX4k9csrt+7ftOJu4V5/Id+cC/ed3Gyk9LunOBf5+z+
        KQfrqD/5PJNh4tWvC8uUt9UaWWerik+aFhxRcD3GIf3Qph+O8k+mLdsopVjkuP9Z47k1dhNv
        zzvxn/f+q4fLGfvnbfrZ1KrEUpyRaKjFXFScCAD92XbEowIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAV3DjO0xBmtuy1kc/f+WzWLvLW2L
        mfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDu8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqk
        b5fAldHyTrDgKGtF07Y+xgbGkyxdjJwcEgImEjf/vGHsYuTiEBLYySixat5aZghnJpPEvxmz
        gKo4ONgENCUuTC4FiYsIzGGU6Nm9nhWkm1nATmLGt9dgtrCAm0TbjDXsIDaLgKrEzKUfwWxe
        ASeJzzeOsUNsk5O4ea6TGcTmFHCWeHTlFhuILQRUc3rVH/YJjDwLGBlWMUqmFhTnpucWGxUY
        5aWW6xUn5haX5qXrJefnbmIEBsu2w1r9OxgfL4k/xCjAwajEw7tCdXuMEGtiWXFl7iFGCQ5m
        JRFex5QtMUK8KYmVValF+fFFpTmpxYcYpTlYlMR5+fOPRQoJpCeWpGanphakFsFkmTg4pRoY
        5/A/0Kqzqf+h+m6tV4329XMhMam7Q3+sKZumWNSw2ubt+rDYabv3RbxLczq9raZG5unRikM3
        zadv+r63t9RCMkbwpe/fY2t/fZJYt23KT7echHDX2Zu/TDXmmbW/rrCyr0hh83O2R24iaee0
        1G9p7NmuHG2QGKK3WfhYoEJ3isu9dOtJPmbvlFiKMxINtZiLihMBMA8bMRICAAA=
X-CMS-MailID: 20190417175353epcas2p1eaec3fea0bf26bb97416149e11b1317e
CMS-TYPE: 102P
X-CMS-RootMailID: 20190417175353epcas2p1eaec3fea0bf26bb97416149e11b1317e
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175353epcas2p1eaec3fea0bf26bb97416149e11b1317e@epcas2p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This bumps up stream count to support in-kernel hints.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/blkdev.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5c58a3b..f200aed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -566,7 +566,9 @@ struct request_queue {
 
 	struct work_struct	release_work;
 
-#define BLK_MAX_WRITE_HINTS	5
+#define BLK_MAX_USER_HINTS     (WRITE_LIFE_KERN_MIN - 2)
+#define BLK_MAX_KERN_HINTS     4
+#define BLK_MAX_WRITE_HINTS    (1 + BLK_MAX_USER_HINTS + BLK_MAX_KERN_HINTS)
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
 };
 
-- 
2.7.4

