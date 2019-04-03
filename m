Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC94C4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 02:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20D12084B
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 02:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZBLv6WX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfDCC5v (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 22:57:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfDCC5v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 22:57:51 -0400
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2019 22:57:50 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x332sdmD077761;
        Wed, 3 Apr 2019 02:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=3QNUYX/6CiPJimN19TLvqEDYljNHcDYiKAec+w9jsk0=;
 b=sZBLv6WXTh457gmNEHTd1YdlrdH/4ikmI6AJk9owGon5CXXKpb4vCGwYSeYk1nfWtvSV
 F1MI7WOgl1beWefYY3+lRZnObzeCkocDH513AdPyuWEVeuB35ic9xTGdsnXkqvorJcLP
 1wwdm0XLoNCzMq+bVsO05qQrGBdGKSTZa8aE2wm69CK1rIIT9zGSbmCQ52atxCWABUsK
 HoZPLetndXT3EtcErW9znz5QOIpZLfxWOxaw4WDqrDCdxRUKhyWJ6UbjDeDfrv873XRY
 sU1/ej4OwkHJImQVneXrS+/qdG6PXCVB0vGlFfacMv9XaF/TfR4H9WsrbSw5EZM6BT5Z fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2rj0dnnf22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 02:57:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x332vYVc035843;
        Wed, 3 Apr 2019 02:57:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rm9mht0mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 02:57:35 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x332vYwF011060;
        Wed, 3 Apr 2019 02:57:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 19:57:33 -0700
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, axboe@fb.com, prakash.v@samsung.com,
        anshul@samsung.com, joshiiitr@gmail.com
Subject: Re: [PATCH v3 7/7] fs/ext4,jbd2: add support for passing write-hint with journal
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3@epcas2p4.samsung.com>
        <1553846032-4451-8-git-send-email-joshi.k@samsung.com>
Date:   Tue, 02 Apr 2019 22:57:31 -0400
In-Reply-To: <1553846032-4451-8-git-send-email-joshi.k@samsung.com> (Kanchan
        Joshi's message of "Fri, 29 Mar 2019 13:23:52 +0530")
Message-ID: <yq14l7fokx0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=597
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030016
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=642 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030016
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Kanchan,

> For NAND based SSDs, mixing of data with different life-time reduces
> efficiency of internal garbage-collection. During FS operations,
> series of journal updates will follow/precede series of data/meta
> updates, causing intermixing inside SSD. By passing a write-hint with
> journal, its write can be isolated from other data/meta writes,
> leading to endurance/performance benefit on SSD.

Why not just introduce REQ_JOURNAL and let the device driver decide how
to turn that into something appropriate for the device?

That's what I'll need for SCSI. Existing SCSI streams are not a good
fit.

-- 
Martin K. Petersen	Oracle Linux Engineering
