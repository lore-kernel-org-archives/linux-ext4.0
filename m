Return-Path: <SRS0=vXfq=2J=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A90C43603
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Dec 2019 22:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC35C24676
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Dec 2019 22:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gX4eAr2B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLSWjW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:39:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSWjV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2019 17:39:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJMTMDP039246;
        Thu, 19 Dec 2019 22:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=VrcMSVWGdXazy+FEfdmjoiYUrjsvdGjYiUgp4QoqORg=;
 b=gX4eAr2BcgbBOTrvXsXamR1JvYksrayZ3Lx7Sk3ON/GzgiJ5sGC7ksFXtSPtNzrhmnk/
 pifZZ96CBQy/6QDAvqbf9lUDWb4KZmvT9thDf60qbfj8Ql3VXqqN4x+VUkdt3gO80Si3
 63G5/qcRweWmDhZV/FUshw7QSFGWN+R+3ZsEBQt9Qpp2gBLGgXblsSaGCwr1SHNl2I49
 S6r1h2bWc1f31YQhHarhLd8f0ozI7iDnwXee4IBRJcWr/xRFpjHzK+grL9DzaEQxCju3
 dN/lys/s9X9Vem/XV+OcmockKPhuF+0VDg2Ix0R4RsgYoN9HUB3jjRKeJrrD/UgqJync sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x01knnpnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 22:37:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJMTI0L136325;
        Thu, 19 Dec 2019 22:37:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x0bgmj1yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 22:37:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBJMbqXa025302;
        Thu, 19 Dec 2019 22:37:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 14:37:52 -0800
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
Date:   Thu, 19 Dec 2019 17:37:47 -0500
In-Reply-To: <3f2e341b-dea4-c5d0-8eb0-568b6ad2f17b@virtuozzo.com> (Kirill
        Tkhai's message of "Thu, 19 Dec 2019 14:07:16 +0300")
Message-ID: <yq1a77oc56s.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=916
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190168
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Kirill,

> Hm. BLKDEV_ZERO_NOUNMAP is used in __blkdev_issue_write_zeroes() only.
> So, do I understand right that we should the below two?:
>
> 1) Introduce a new flag BLKDEV_ZERO_ALLOCATE for
> blkdev_issue_write_zeroes().

> 2) Introduce a new flag REQ_NOZERO in enum req_opf.

Something like that. If zeroing is a problem for you.

Right now we offer the following semantics:

	Deallocate, no zeroing (discard)

	Optionally deallocate, zeroing (zeroout)

	Allocate, zeroing (zeroout + NOUNMAP)

Some devices also implement a fourth option which would be:

	Anchor: Allocate, no zeroing

> Won't this confuse a reader that we have blkdev_issue_write_zeroes(),
> which does not write zeroes sometimes? Maybe we should rename
> blkdev_issue_write_zeroes() in some more generic name?

Maybe. The naming is what it is for hysterical raisins and reflects how
things are implemented in the storage protocols. I wouldn't worry too
much about that. We can rename things if need be but we shouldn't plumb
an essentially identical operation through the block stack just to
expose a different name at the top.

-- 
Martin K. Petersen	Oracle Linux Engineering
