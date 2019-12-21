Return-Path: <SRS0=IFrT=2L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CA9C2D0C3
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Dec 2019 18:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6FD20665
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Dec 2019 18:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YNcJqv62"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfLUS5p (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 21 Dec 2019 13:57:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfLUS5p (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Dec 2019 13:57:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBLIsYgC105795;
        Sat, 21 Dec 2019 18:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=D2wcasH1ZhiCVNdqmYp9V03i7PEyRJEfWju3qTFe+5A=;
 b=YNcJqv62W9/CZb6j+sLKFv8RjQJTMAMnpPgtc8agrx8zDCLYh0M/2VSc4RD0EcBxuCkT
 qcx0O8gPGM/L1Ck8vp87nnMLr3OWmFEBbAaUY0FjlqvIeDuEvJJn1MRl6Iymgu2a5m+1
 H2NOdQkL6IRUuxbWEkRPPOWp6vPU//khGOnt12U+Nn1XQoju7xqrY1yDrYHdl2se0ChA
 X0Ff9V33AFUX5vdSNnLRUpIGQ6gFop/SIbYJ8Q6VaJODL9Sn4E+ETyUSC5dfZvm3LUwr
 yIWfsermwHsVUUwiZJMRT3hVavh/0R+D+YtrK5B0Y5f2AMzbIKBvhy+xzSHe05WuaKbH Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x1att9mv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Dec 2019 18:57:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBLIn6jb110474;
        Sat, 21 Dec 2019 18:55:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x19f5ku4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Dec 2019 18:55:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBLIssO7006659;
        Sat, 21 Dec 2019 18:54:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 21 Dec 2019 10:54:54 -0800
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ming.lei@redhat.com, osandov@fb.com,
        jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com,
        andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org,
        ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com,
        chaitanya.kulkarni@wdc.com, bvanassche@acm.org,
        dhowells@redhat.com, asml.silence@gmail.com
Subject: Re: [PATCH RFC 1/3] block: Add support for REQ_OP_ASSIGN_RANGE operation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <157599668662.12112.10184894900037871860.stgit@localhost.localdomain>
        <157599696813.12112.14140818972910110796.stgit@localhost.localdomain>
        <yq1woatc8zd.fsf@oracle.com>
        <3f2e341b-dea4-c5d0-8eb0-568b6ad2f17b@virtuozzo.com>
        <yq1a77oc56s.fsf@oracle.com>
        <625c9ee4-bedb-ff60-845e-2d440c4f58aa@virtuozzo.com>
Date:   Sat, 21 Dec 2019 13:54:50 -0500
In-Reply-To: <625c9ee4-bedb-ff60-845e-2d440c4f58aa@virtuozzo.com> (Kirill
        Tkhai's message of "Fri, 20 Dec 2019 14:55:09 +0300")
Message-ID: <yq1pngh7blx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9478 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912210166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9478 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912210167
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Kirill,

> One more thing to discuss. The new REQ_NOZERO flag won't be supported
> by many block devices (their number will be even less, than number of
> REQ_OP_WRITE_ZEROES supporters). Will this be a good thing, in case of
> we will be completing BLKDEV_ZERO_ALLOCATE bios in
> __blkdev_issue_write_zeroes() before splitting? I mean introduction of
> some flag in struct request_queue::limits.  Completion of them with
> -EOPNOTSUPP in block devices drivers looks suboptimal for me.

We already have the NOFALLBACK flag to let the user make that decision.

If that flag is not specified, and I receive an allocate request for a
SCSI device that does not support ANCHOR, my expectation would be that I
would do a regular write same.

If it's a filesystem that is the recipient of the operation and not a
SCSI device, how to react would depend on how the filesystem handles
unwritten extents, etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
