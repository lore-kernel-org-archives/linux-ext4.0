Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFDCC10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A6DC2084B
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hPwRA2z/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfDYLYA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54309 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfDYLYA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190425112356epoutp0241c59a3d1d9bb5101b36ed6214063732~Ys93cum5Q1144111441epoutp02Y;
        Thu, 25 Apr 2019 11:23:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190425112356epoutp0241c59a3d1d9bb5101b36ed6214063732~Ys93cum5Q1144111441epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191436;
        bh=a2P0lf+DiayoNKdNvyjb4q1Kc0v/LfWtzOzEep8KjgU=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=hPwRA2z/bhnm9RYLLODycRwErUA1v2MIjW8Ukk5UMGPli1mDJo/cGTn88QbFOJGXO
         3RBr+ySnnMnwR81HgcJd92PhsGj4eHN6zRy1hOMdUWVVQVuJnmOalNBdJVWkdN8+uE
         +7byW7KT+TQ1SMwXBNEeYUMplpDW+XqM3V7PAYd8=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20190425112355epcas2p3f4375e6c54426beaa92f424d5a4df42d~Ys92lI5MA3170231702epcas2p3O;
        Thu, 25 Apr 2019 11:23:55 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.9C.04207.BC891CC5; Thu, 25 Apr 2019 20:23:55 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112355epcas2p11e197c8fc33698feb7150d1f4148407e~Ys92Unmtp1705417054epcas2p17;
        Thu, 25 Apr 2019 11:23:55 +0000 (GMT)
X-AuditID: b6c32a48-689ff7000000106f-7f-5cc198cbbdef
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 87.4D.03620.BC891CC5; Thu, 25 Apr
        2019 20:23:55 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:23:55 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 2/7] block: increase stream count for in-kernel use
Date:   Thu, 25 Apr 2019 16:49:57 +0530
Message-id: <1556191202-3245-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCmhe7pGQdjDA7c0bb4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGXue/GcsOMpacabpBGsD40mWLkZODgkBE4mbK78ydTFycQgJ7GCUeP7yHwuE
        851RomvBMXaYqi+3+qGqNjBK7FhzmxnCmc4ksfv5dKAWDg42AU2JC5NLQeIiAnMYJZbtm8YM
        0s0sECKx4skqsBphATeJvgtVIGEWAVWJ17c2sYLYvAJOEs2NX1khlslJ3DzXCdbKKeAs8eLH
        M7DFEgKNbBIfd3dCFblIvFqykgnClpZ4tmojI4RdLPHrzlFmiIYORonrDTOhHrWXuLjnLxPE
        QXwSHYf/soMcJCHAK9HRJgRR4iEx++lKqMemMUq8m7SYbQKjxAJGhlWMYqkFxbnpqcVGBSZ6
        xYm5xaV56XrJ+bmbGMGRpeWxg/HAOZ9DjAIcjEo8vAqRB2KEWBPLiitzDzFKcDArifCqmx6M
        EeJNSaysSi3Kjy8qzUktPsQozcGiJM77UHputJBAemJJanZqakFqEUyWiYNTqoFRqbC80bzd
        cUL/Z47N8m8uGm5bK3L+5vNrM00sUlc0XhV5mNqSwvX80WeBUyeYX3yIlnzw9J7V2+bYhi0V
        vcy2O8OufZm/d8Px1wkKrsXtD61vzHrzWenl+eaVv2NXB25pzHk6+frDN7OXNnEHrXW7H/GI
        28js84et3zUWWqzhTd17vav1tv+tm0osxRmJhlrMRcWJANU/jFWoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xoO7pGQdjDA7dlbH4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGXue/GcsOMpacabpBGsD40mWLkZODgkBE4kvt/qZuhi5OIQE1jFK/H1wlQ3C
        mckkcWz5OiCHg4NNQFPiwuRSkLiIwBxGiZ7d61lBupkFQiRmPXsMViMs4CbRd6EKJMwioCrx
        +tYmsBJeASeJ5savrBDL5CRunutkBrE5BZwlXvx4xgRiCwHVXJu2iX0CI88CRoZVjJKpBcW5
        6bnFRgVGeanlesWJucWleel6yfm5mxiBYbPtsFb/DsbHS+IPMQpwMCrx8CpEHogRYk0sK67M
        PcQowcGsJMKrbnowRog3JbGyKrUoP76oNCe1+BCjNAeLkjgvf/6xSCGB9MSS1OzU1ILUIpgs
        EwenVAOj5CyWp/G1y43lX7fOfP3Ob7pTUerH9pnzOtwMpW2TGFOCDiVFqPWvbVSXW8di+sWh
        YvGhVf+2FW9t7Wku6tdQN/bbPZPDqrvHKPTSVzOu3y77jZIeCIgcSnPun/GE0XTRv3gZd6aH
        J40u7Kzh2SH/6qtm5+m1B7/Z5OhsTlFddf/+Xr25soeVWIozEg21mIuKEwE2tYWXFwIAAA==
X-CMS-MailID: 20190425112355epcas2p11e197c8fc33698feb7150d1f4148407e
CMS-TYPE: 102P
X-CMS-RootMailID: 20190425112355epcas2p11e197c8fc33698feb7150d1f4148407e
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112355epcas2p11e197c8fc33698feb7150d1f4148407e@epcas2p1.samsung.com>
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
index 317ab30..2826225 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -565,7 +565,9 @@ struct request_queue {
 
 	struct work_struct	release_work;
 
-#define BLK_MAX_WRITE_HINTS	5
+#define BLK_MAX_USER_HINTS     (WRITE_LIFE_KERN_MIN - 2)
+#define BLK_MAX_KERN_HINTS     4
+#define BLK_MAX_WRITE_HINTS    (1 + BLK_MAX_USER_HINTS + BLK_MAX_KERN_HINTS)
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
 };
 
-- 
2.7.4

