Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F92BC4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 04:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BFB206DD
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 04:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dVN34tq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfC2ECa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 00:02:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfC2ECa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 00:02:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2T3whWq107708;
        Fri, 29 Mar 2019 04:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=u01ttpO1CNLjAEDYksWHTKEjyHSBV2Sue3sQFqhEFl4=;
 b=dVN34tq6HtCv36WRYsQrQ9AuxOEQQDZjohx3wShwVgBesFMRwEUxLmixuGfX2OHhN50Z
 VvCNugd5TDovuLz7qp47gyx6pAkxblAn2t3gYEkKImJKceyXBb24EFcwKc/hoFd0m4WU
 HV9bIQsgfZlIbRWb9QBPQTcL8b4pOKJmbww6aMAMqeUOaTjQm5A2JFSsBaDalhccc1Pv
 u/2qnXPA9UCygfQ99jfeUV7o3lFHdyRlUlvmkwnjyerfpG5FRQ/CeJGfirCCXu4FCPrG
 f6d/gVIxHm6/PoqcSUoHvWbpgUoUky31lWdz0u+9rS5Qyt4lB8EDHeipWQAwsr/1SNAw 6A== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2re6djt6h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 04:02:26 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2T42PCp027427
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 04:02:25 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2T42O3b001680;
        Fri, 29 Mar 2019 04:02:24 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 21:02:24 -0700
Date:   Thu, 28 Mar 2019 21:02:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: don't allow most setxattr to immutable files
Message-ID: <20190329040222.GC18833@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
 <155379545404.24796.5019142212767521955.stgit@magnolia>
 <20190328212948.GL23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328212948.GL23020@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9210 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290029
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 29, 2019 at 08:29:48AM +1100, Dave Chinner wrote:
> On Thu, Mar 28, 2019 at 10:50:54AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The chattr manpage has this to say about immutable files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > However, we don't actually check the immutable flag in the setattr code,
> > which means that we can update project ids and extent size hints on
> > supposedly immutable files.  Therefore, reject a setattr call on an
> > immutable file except for the case where we're trying to unset
> > IMMUTABLE.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 2bd1c5ab5008..9cf0bc0ae2bd 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1067,6 +1067,14 @@ xfs_ioctl_setattr_xflags(
> >  	    !capable(CAP_LINUX_IMMUTABLE))
> >  		return -EPERM;
> >  
> > +	/*
> > +	 * If immutable is set and we are not clearing it, we're not allowed
> > +	 * to change anything else in the inode.
> > +	 */
> > +	if ((ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
> > +	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
> > +		return -EPERM;
> > +
> >  	/* diflags2 only valid for v3 inodes. */
> >  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> >  	if (di_flags2 && ip->i_d.di_version < 3)
> 
> Looks fine - catches both FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR
> for XFS.
> 
> Do the other filesystems that implement FS_IOC_FSSETXATTR have
> the same bug?

Yes.  I'm not even 100% sure I've finished playing xfs whackamole yet.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
