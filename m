Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B88C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 04:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4183620665
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 04:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfBVE3A (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 23:29:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbfBVE3A (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 23:29:00 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1M4SxG7053021
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 23:28:59 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qt8x8tb6g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 23:28:59 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 22 Feb 2019 04:28:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Feb 2019 04:28:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1M4SqRR33489046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 Feb 2019 04:28:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1912B42042;
        Fri, 22 Feb 2019 04:28:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C0204203F;
        Fri, 22 Feb 2019 04:28:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.53.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Feb 2019 04:28:49 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com
Subject: Re: [RFC PATCH 00/10] Consolidate Post read processing code
Date:   Fri, 22 Feb 2019 09:59:31 +0530
Organization: IBM
In-Reply-To: <20190221183827.GA140206@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com> <2420837.hecoV8S9Z6@localhost.localdomain> <20190221183827.GA140206@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19022204-0028-0000-0000-0000034B8FE5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022204-0029-0000-0000-00002409D714
Message-Id: <2245787.mQPMR5rap9@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902220029
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Friday, February 22, 2019 12:08:28 AM IST Eric Biggers wrote:
> On Thu, Feb 21, 2019 at 07:02:03PM +0530, Chandan Rajendra wrote:
> > On Wednesday, February 20, 2019 6:11:07 AM IST Eric Biggers wrote:
> > > On Mon, Feb 18, 2019 at 03:34:23PM +0530, Chandan Rajendra wrote:
> > > > Based on the reviews provided for this patchset, I
> > > > will change F2FS to use mpage_readpage[s] and post the next version of
> > > > this patchset to linux-fsdevel mailing list.
> > > 
> > > Is that really possible?  F2FS has other functionality in its ->readpages(),
> > > such as support for filesystems that use multiple block devices.
> > > 
> > 
> > Hmm. I didn't know that. Thanks for pointing that out. I will read up that
> > code and if it isn't really possible to get F2FS to use mpage_readpage[s](),
> > then I would limit the patchset to Ext4.
> > 
> 
> But we can make F2FS use the shared bio_post_read functions even if it can't use
> mpage_readpage[s](), right?
>

Yes, that should be possible. I will include those changes in the next version
of the patchset.

-- 
chandan



