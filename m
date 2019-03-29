Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3760DC10F0A
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0676C21773
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JJTVJXPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfC2H6F (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:58:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22079 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbfC2H6C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:58:02 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190329075759epoutp027aca1c256b690275046284881e2748e3~QXvVW50Qk0251002510epoutp020;
        Fri, 29 Mar 2019 07:57:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190329075759epoutp027aca1c256b690275046284881e2748e3~QXvVW50Qk0251002510epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846279;
        bh=IiZuU0ik+67oCr4Hd99R0DlNPChW1bLKnqJnQVC6KJM=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=JJTVJXPCHnjAoQLWu5IwFkIuBh790afoO/B60aqphnD1dCyFgu6vberuW4mWVU1/A
         6yQplHZnVzCO8eL6PyRdfcOKH7p7FAH+aBn4AJeVV3o6GCZfn7vlpNG61zLcNOAB1C
         HtpGN77OIgdCXmPBhe/RdqhYQBI9W12CZS689wH8=
Received: from epsmges1p5.samsung.com (unknown [182.195.42.57]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190329075759epcas1p4a83c17b18b8dd41c11e3f57c2e218e59~QXvVJiz_D0188401884epcas1p4w;
        Fri, 29 Mar 2019 07:57:59 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.B2.04108.600DD9C5; Fri, 29 Mar 2019 16:57:58 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752~QXvUmpArt2752527525epcas1p3c;
        Fri, 29 Mar 2019 07:57:58 +0000 (GMT)
X-AuditID: b6c32a39-8b7ff7000000100c-9d-5c9dd00644be
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.7F.03598.600DD9C5; Fri, 29 Mar 2019 16:57:58 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:58 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 6/7] fs: introduce write-hint start point for in-kernel
 hints
Date:   Fri, 29 Mar 2019 13:23:51 +0530
Message-id: <1553846032-4451-7-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCmvi7bhbkxBu+WW1v8nj6F1eL/nmNs
        Fkf/v2WzOP/2MJPF3lvaFjPn3WGz2LP3JIvF5V1z2CzmL3vKbnFlyiJmBy6Pic3v2D12zrrL
        7rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZWx92MhcMJG1Yv3hVtYGxoUsXYycHBIC
        JhIn1x4Bsrk4hAR2MEr0fvvKDOF8Z5RoeHeKvYuRA6yqYa4lRHw3o8ShzU/ZIJzpTBLPm7ey
        gBSxCWhKXJhcChIXEZjDKLFs3zRmkBXMAuUSf6dcZQSxhQWCJLbNncEKYrMIqEo83nMT7Axe
        ASeJdy/7mSFOkpO4ea4TzOYUcJb4eL0Z7DwJgQVsEv8enWCFKHKR2HrwNRvEddISl47aQoSL
        JX7dOcoMUd/BKHG9YSbUn/YSF/f8ZYI4iE/i3dceVoheXomONiGIEg+JTfO3QoNiGqPE4mer
        2CYwSixgZFjFKJZaUJybnlpsWGCqV5yYW1yal66XnJ+7iREcf1qWOxiPnfM5xCjAwajEw/th
        95wYIdbEsuLK3EOMEhzMSiK8gefmxgjxpiRWVqUW5ccXleakFh9ilOZgURLnXe/gHCMkkJ5Y
        kpqdmlqQWgSTZeLglGpgTDkz8Q5j52Fj1qLPOcz30jPyzVkOXdavTerqFMlbZxYnNcvfOnVT
        p9cJh5nszZNTfOZeU5N34snI3iDq6cSpNenr5MXBW/M3/SgX/2vePEfqc473ReXdmtUszZlu
        hW91og1e/L/43aVd7kj3i2q2o8I39sgumlshuM1P+Lf/F82tpy/MqJunxFKckWioxVxUnAgA
        PJjGursCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAV22C3NjDI7PlLD4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgytj6sJG5YCJrxfrDrawNjAtZuhg5OCQE
        TCQa5lp2MXJxCAnsZJTofzafEcKZySRxcXo3WBGbgKbEhcmlIHERgTmMEj2717OCxJkFyiWm
        bOLsYuTkEBYIkDh+9iILiM0ioCrxeM9NMJtXwEni3ct+ZhBbQkBO4ua5TjCbU8BZ4uP1ZrAa
        IaCatfcb2Ccw8ixgZFjFKJlaUJybnltsVGCYl1quV5yYW1yal66XnJ+7iREYXNsOa/XtYLy/
        JP4QowAHoxIP74ydc2KEWBPLiitzDzFKcDArifAGnpsbI8SbklhZlVqUH19UmpNafIhRmoNF
        SZz3dt6xSCGB9MSS1OzU1ILUIpgsEwenVANjkuTlo8YZ6Tus7j12Xy4bN71V9/epeQqOV04/
        6z/R5uZzievVlgUlT9+o6T1SXdweIX8kY4WTYc/97vRV34U6PCw9hCa8ucD6tOeyUtKn3gMn
        zpis1zNLsu6/Zjw7olfn9PI1cv68u1jYlsfVPuuS9laKPW9s6a97/bkSZ3fui8/62U6/P+xQ
        YinOSDTUYi4qTgQAcNqBAioCAAA=
X-CMS-MailID: 20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752
CMS-TYPE: 101P
X-CMS-RootMailID: 20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752@epcas1p3.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

kernel-mode components can define own write-hints using
"WRITE_LIFE_KERN_MIN" as base.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 29d8e2c..6a2673e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -291,6 +291,8 @@ enum rw_hint {
 	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
 	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
 	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
+/* Kernel should use write-hint starting from this */
+	WRITE_LIFE_KERN_MIN,
 };
 
 #define IOCB_EVENTFD		(1 << 0)
-- 
2.7.4

