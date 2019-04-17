Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C64C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0904E2064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CIAyJN1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733239AbfDQRx5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:53:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49145 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733216AbfDQRx4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:53:56 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190417175352epoutp016a9cdc22c6155e6dc86b582cadb6d63f~WVICU6CyB2230422304epoutp01z;
        Wed, 17 Apr 2019 17:53:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190417175352epoutp016a9cdc22c6155e6dc86b582cadb6d63f~WVICU6CyB2230422304epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523632;
        bh=AW0YDDi+9LxgJJQEsuX274rekHmOC8F5v9v1EvGolgI=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=CIAyJN1CYDMKCCud09/haqoQpZjbcT2hfwQ+LfUCOi9HY5tC99O4yLQCjtKjWBkbU
         VsRyebgPc5vJlYUnGHTYeh3LrbtdGdSYlxzQPooSQ7C0F92s/AZ7B09ajwUJcTrkm/
         kDTuGcfsNtihHX8WL4EhVmICVLDXNs+Int6OgSE4=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175352epcas1p4a6189df1d2b856f7f07718004a7d11e3~WVICCiHsu1781617816epcas1p4Q;
        Wed, 17 Apr 2019 17:53:52 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.63.04139.03867BC5; Thu, 18 Apr 2019 02:53:52 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175351epcas1p481ec1bd87188022020a504447e88fde4~WVIBHFvwF2080520805epcas1p4G;
        Wed, 17 Apr 2019 17:53:51 +0000 (GMT)
X-AuditID: b6c32a35-973ff7000000102b-4e-5cb76830be01
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.11.03598.F2867BC5; Thu, 18 Apr 2019 02:53:51 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:51 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 1/7] fs: introduce write-hint start point for in-kernel
 hints
Date:   Wed, 17 Apr 2019 23:20:00 +0530
Message-id: <1555523406-2380-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhTV9cgY3uMwZN2Houj/9+yWey9pW0x
        c94dNos9e0+yWFzeNYfNYv6yp+wWV6YsYnZg99i8pN6jb8sqRo/Pm+QCmKO4bFJSczLLUov0
        7RK4Mjq6brIULGSt6GmYydjAuI6li5GTQ0LAROLlyjamLkYuDiGBHYwSvzbPZINwvjNK9D2/
        xwRTdfrbdHYQW0hgN6PEin4diKLpTBKnFi5j7WLk4GAT0JS4MLkUJC4iMIdRYtm+acwgDcwC
        dhIzvr1mBbGFBYIkPv6+CLaaRUBVovXBW7AaXgEniSXXfrJDLJOTuHmuEyzOKeAs8ejKLTaI
        +E9WidvTZCBsF4mX13+B7ZUQkJa4dNQWIlws8evOUWaQGyQEOhglrjfMhHrTXuLinr9MEPfw
        Sbz72gPVyyvR0SYEUeIhsf95A9Tz0xglPm58xD6BUWIBI8MqRrHUguLc9NRiwwJDveLE3OLS
        vHS95PzcTYzgWNIy3cE45ZzPIUYBDkYlHl4Gje0xQqyJZcWVuYcYJTiYlUR4HVO2xAjxpiRW
        VqUW5ccXleakFh9ilOZgURLnXe/gHCMkkJ5YkpqdmlqQWgSTZeLglGpgPJac/yAuMjNzisx7
        Ke+JpQ1hDLqmhc88fkudZrXzDjrMNaumx+Vl35q13DKHmPvW5iy68s69/6C0leD6PBH+D6me
        b3Zcq1C23jlnJ49+eeIOE3t3yZnHI24GBDakX1e/Wtca4Mt9wtQrfFet9auta2/deDZ7umaR
        xcXEwPUhC/bEcevxt2srsRRnJBpqMRcVJwIAP1CCjaECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xgK5+xvYYgxNvuS2O/n/LZrH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3WPzknqPvi2rGD0+b5ILYI7isklJzcksSy3S
        t0vgyujouslSsJC1oqdhJmMD4zqWLkZODgkBE4nT36azdzFycQgJ7GSUuNB5mhHCmckkcWV6
        N1MXIwcHm4CmxIXJpSBxEYE5jBI9u9ezgnQzC9hJzPj2GswWFgiQ+NB0gh3EZhFQlWh98JYZ
        xOYVcJJYcu0nO8Q2OYmb5zrB4pwCzhKPrtxiA7GFgGpOr/rDPoGRZwEjwypGydSC4tz03GKj
        AsO81HK94sTc4tK8dL3k/NxNjMBw2XZYq28H4/0l8YcYBTgYlXh4V6hujxFiTSwrrsw9xCjB
        wawkwuuYsiVGiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/tvGORQgLpiSWp2ampBalFMFkmDk6p
        BkbWS1FhsS5v7wufPmi45vux8zXCrIk9Apy/P3qbL1U91RA/YcH9J+X86/KKY3myPItmxXmn
        lr39LXC4UvP84e17vIPjohp5rfx2BTXmcQa8WXnwLlvJxzNqau8u+3Y3be5iy05My/3y5wxL
        PPeMy8a923OY/tRL3dijndodmnWgMyUp+CfDEyWW4oxEQy3mouJEAN5IJu0TAgAA
X-CMS-MailID: 20190417175351epcas1p481ec1bd87188022020a504447e88fde4
CMS-TYPE: 101P
X-CMS-RootMailID: 20190417175351epcas1p481ec1bd87188022020a504447e88fde4
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175351epcas1p481ec1bd87188022020a504447e88fde4@epcas1p4.samsung.com>
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

