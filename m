Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEE7C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 16:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8607B2192D
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 16:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OgNX5DmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfBOQZ5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:25:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37114 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfBOQZ5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 11:25:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1FGOOkp046462;
        Fri, 15 Feb 2019 16:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=idnWK4ZGXBsK29pzpZ2O8JJqRQzGBibETdLkPdOCVsA=;
 b=OgNX5DmQCHlrtkfDl3Wx/3pPZXgV5XZtRJ3c8Df95zIu89LDNevBFEEPCwTJBoRiVVuv
 l/sv/qmsltUGtl0f/+dAq2IfscwSKynIHKV3TX3xNQNVCQRJUPUktx5uRDoGcm2+jiRP
 Moph5cMtiOyiC+gfGO518Iph7BU1B1YZz7dIEN0QPrFCNrLbowYEuDcFtqG5wdJ45vjh
 fnEkYRMLwE/V/1FQwSrgfiah0gKtOtyz5eqIIJM/1cbpfOv4f/xHWPJ8D4D2y0YaDbeq
 K+Jogc4UegJACCkxTy4R22HyGADwcVxeml9iQ7W1F58gYGrOuPYt4HPakg9JuL4Bdnho 2Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qhre5xrk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 16:25:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1FGPj6g012376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 16:25:45 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1FGPibK001483;
        Fri, 15 Feb 2019 16:25:44 GMT
Received: from localhost (/10.159.241.149)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Feb 2019 16:25:44 +0000
Date:   Fri, 15 Feb 2019 08:25:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] libext2fs: revert "try to always use PUNCH_HOLE for
 unix_discard"
Message-ID: <20190215162543.GA6471@magnolia>
References: <20190114233708.GA20465@magnolia>
 <20190214210448.GE7387@mit.edu>
 <20190215095007.jx5ol3ss7uhegz3z@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215095007.jx5ol3ss7uhegz3z@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=543 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902150113
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 15, 2019 at 10:50:07AM +0100, Lukas Czerner wrote:
> On Thu, Feb 14, 2019 at 04:04:48PM -0500, Theodore Y. Ts'o wrote:
> > On Mon, Jan 14, 2019 at 03:37:08PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Revert bcca9876a3428c10417c660b78933e6e70e8a5f5, because
> > > fallocate(PUNCH_HOLE) on block devices was changed to use zeroout
> > > instead of discard shortly after block device fallocate was merged.
> > > zeroout isn't necessarily a "drop storage" operation like discard is,
> > > so we prefer to use that on block devices.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Thanks, applied.
> > 
> > 					- Ted
> 
> I just noticed this patch, sorry. I think we can still use fallocate,
> but we need to set the right flags to make sure it uses discard instead
> of zeroout. See fs/block_dev.c
> 
> 	switch (mode) {
> 	case FALLOC_FL_ZERO_RANGE:
> 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
> 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
> 					    GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
> 		break;
> 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
> 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
> 					     GFP_KERNEL, BLKDEV_ZERO_NOFALLBACK);
> 		break;
> 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
> 		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
> 					     GFP_KERNEL, 0);
> 		break;
> 	default:
> 		return -EOPNOTSUPP;
> 	}
> 
> So if we want a discard (meaning we want to unallocate the blocks
> without necessarily making sure we can't read stale data from it) we
> have to use FALLOC_FL_NO_HIDE_STALE.
> 
> So the flags would be FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE

Userspace isn't allowed to pass in _NO_HIDE_STALE; see
FALLOC_FL_SUPPORTED_MASK in include/linux/falloc.h.

The behavior of "no hide stale" isn't defined in the manpages; it's
merely a reserved code point.

--D

> Ted, Darrick what do you think ? Can we keep the
> bcca9876a3428c10417c660b78933e6e70e8a5f5 commit and just change the
> flags ?
> 
> -Lukas
