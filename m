Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346FEC4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 13:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDDE920830
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 13:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qxO5vLay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfDCNmr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:42:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32258 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfDCNmq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2019 09:42:46 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190403134243epoutp04ff9d1fa03046bc58d218db20388cb3af~R_qwPMY4i1314213142epoutp04O
        for <linux-ext4@vger.kernel.org>; Wed,  3 Apr 2019 13:42:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190403134243epoutp04ff9d1fa03046bc58d218db20388cb3af~R_qwPMY4i1314213142epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1554298963;
        bh=D1ZWEnG2iRu2oBwBLrAYsXl2ecmc43Kxq7h9Dsh+SC4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=qxO5vLay8V+0wxJ//1JPdFDv56Nf7lPf61f3QvnJymBAv+x8h4bi8BAeXOJSLUIBl
         y/b3xMDeE/q7gZk3XEPgDJjCRByjKFeDWGDNc/TsbEvNK58bQbrZ/2iFCseGgTwtbo
         VnoX4jLO8rWpFQXOZuqCJpFdWUD0Mqao97qrgTVw=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190403134242epcas5p2f53b5e2081e804a8703c6da696c11eb1~R_qvpmvft2682626826epcas5p29;
        Wed,  3 Apr 2019 13:42:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.25.04071.258B4AC5; Wed,  3 Apr 2019 22:42:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20190403134241epcas5p4743b5b4e1584213856f1f963fa236b68~R_quTvmXO0924609246epcas5p48;
        Wed,  3 Apr 2019 13:42:41 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190403134241epsmtrp1f0baa8bbeeef8abba95713cd11048a28~R_quS8ADk0645006450epsmtrp16;
        Wed,  3 Apr 2019 13:42:41 +0000 (GMT)
X-AuditID: b6c32a49-59fff70000000fe7-9d-5ca4b852b136
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.62.03662.158B4AC5; Wed,  3 Apr 2019 22:42:41 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190403134239epsmtip1551bea397b0e6d3ebbc9ccd78bfe2b23~R_qs1ATaI0586605866epsmtip1w;
        Wed,  3 Apr 2019 13:42:39 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <axboe@fb.com>,
        <prakash.v@samsung.com>, <anshul@samsung.com>,
        <joshiiitr@gmail.com>
In-Reply-To: <yq14l7fokx0.fsf@oracle.com>
Subject: RE: [PATCH v3 7/7] fs/ext4,jbd2: add support for passing write-hint
 with journal
Date:   Wed, 3 Apr 2019 19:12:00 +0530
Message-ID: <11cd01d4ea23$1bb6b260$53241720$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQE0pJf9fllz3AfCWkxgRsQT/9U6SAH+2IJzAfiHPhcCU6VO6ac4nyvg
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsWy7bCmhm7QjiUxBtdeKVn8nj6F1eL/nmNs
        FuffHmay2HtL22LmvDtsFnv2nmSxuLxrDpvF/GVP2S2WH//HZHFlyiJmBy6Pic3v2D12zrrL
        7rF5Sb3Hx6e3WDz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr49alfYwFV/gqpq5/xNrA2MnT
        xcjBISFgItH3u6yLkYtDSGA3o8SNt4eZIZxPjBJ/Hy6Gcr4xSsy+sh7I4QTr2LCzhQkisReo
        5XEzG0hCSOA5o0TXCiMQm01AVeLej16wuIiAucTECUdZQBqYBf4xShye+ZIdJMEpoCnx5HQP
        I4gtLBAt8fjDXLAGFgEViSNNzUwgNq+ApcTjW5ugbEGJkzOfsIDYzALyEtvfzoG6SEFi96ej
        rBDL3CQWNZ1ihqgRl3h59Ag7yGIJgW52ie/b37FDNLhI/Pl/gw3CFpZ4dXwLVFxK4mV/G5Rd
        LPHrzlFmiOYORonrDTNZIBL2Ehf3/GUChR4z0Afrd+lDLOOT6P39hAkSqLwSHW1CENWKEvcm
        PWWFsMUlHs5YAmV7SLyY9oZtAqPiLCSvzULy2iwkL8xCWLaAkWUVo2RqQXFuemqxaYFhXmq5
        XnFibnFpXrpecn7uJkZwstLy3ME465zPIUYBDkYlHt4fq5fECLEmlhVX5h5ilOBgVhLhPdO/
        IEaINyWxsiq1KD++qDQntfgQozQHi5I471zZudFCAumJJanZqakFqUUwWSYOTqkGRiPWxvny
        Jm+/XcozMBRhNr21vku4eMb8p8d8nNJmu23s2fZ8yoKSqY94SlZdn782Wf8kr+f/VVYPzyzf
        VRm3Xzb+SoFS9o3G0P9scRn1+2/XSVYY8/RO1PM5p6hutzVNYY1sZZdJ9JSXRtfuzPQTdHGM
        3vtouVTxpVzdi2lTtrfW/L2ao2hxS4mlOCPRUIu5qDgRAObnvEBSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWy7bCSnG7gjiUxBpcPcVr8nj6F1eL/nmNs
        FuffHmay2HtL22LmvDtsFnv2nmSxuLxrDpvF/GVP2S2WH//HZHFlyiJmBy6Pic3v2D12zrrL
        7rF5Sb3Hx6e3WDz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr49alfYwFV/gqpq5/xNrA2MnT
        xcjJISFgIrFhZwtTFyMXh5DAbkaJp9/PMEIkxCWar/1gh7CFJVb+ew5mCwk8ZZTYtCgExGYT
        UJW496OXDcQWETCXmDjhKAvIIGaBDiaJVUchBgkJvGCU+PmlCMTmFNCUeHK6BywuLBApcePW
        F2YQm0VAReJIUzMTiM0rYCnx+NYmKFtQ4uTMJ0BDOYCG6km0bQRrZRaQl9j+dg4zxG0KErs/
        HWWFuMFNYlHTKWaIGnGJl0ePsE9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi3PTcYsMCo7zU
        cr3ixNzi0rx0veT83E2M4HjT0trBeOJE/CFGAQ5GJR7eBSuXxAixJpYVV+YeYpTgYFYS4T3T
        vyBGiDclsbIqtSg/vqg0J7X4EKM0B4uSOK98/rFIIYH0xJLU7NTUgtQimCwTB6dUAyNr/+q6
        FAaGTe9OPnKNMbiV8K9DRf+oz8eKHvPazscinI2df0Tm7jR9cDvDc6/wtcO++TLJvx459itv
        kJA0yq04kfot38QgwF3N+KsK2+2517+f+XL/wdfOK9wyu65dvNjyPOJn7JSd/HuC4y/9f+Q7
        f1/bl2gjsbPTKwwWp4vKlQguOvW010iJpTgj0VCLuag4EQCEmH9rswIAAA==
X-CMS-MailID: 20190403134241epcas5p4743b5b4e1584213856f1f963fa236b68
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3@epcas2p4.samsung.com>
        <1553846032-4451-8-git-send-email-joshi.k@samsung.com>
        <yq14l7fokx0.fsf@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Martin,

> Why not just introduce REQ_JOURNAL and let the device driver decide how to
turn that into something appropriate for the device?

It began with that kind of thought/goal i.e.  introduce something just for
FS journal. But it seems to have evolved for good. 
Current approach extends write-hint infra so that whole thing becomes
extensible for other kind of use-cases (than FS journal) as well. 	
Also in this approach, driver will do little, while block-layer will do
majority of the work.

> That's what I'll need for SCSI. Existing SCSI streams are not a good fit.

Do you see that it's difficult for SCSI to use write-hint infrastructure for
streams? 


  
-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com] 
Sent: Wednesday, April 03, 2019 8:28 AM
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: linux-kernel@vger.kernel.org; linux-block@vger.kernel.org;
linux-nvme@lists.infradead.org; linux-fsdevel@vger.kernel.org;
linux-ext4@vger.kernel.org; axboe@fb.com; prakash.v@samsung.com;
anshul@samsung.com; joshiiitr@gmail.com
Subject: Re: [PATCH v3 7/7] fs/ext4,jbd2: add support for passing write-hint
with journal


Kanchan,

> For NAND based SSDs, mixing of data with different life-time reduces 
> efficiency of internal garbage-collection. During FS operations, 
> series of journal updates will follow/precede series of data/meta 
> updates, causing intermixing inside SSD. By passing a write-hint with 
> journal, its write can be isolated from other data/meta writes, 
> leading to endurance/performance benefit on SSD.

Why not just introduce REQ_JOURNAL and let the device driver decide how to
turn that into something appropriate for the device?

That's what I'll need for SCSI. Existing SCSI streams are not a good fit.

-- 
Martin K. Petersen	Oracle Linux Engineering

