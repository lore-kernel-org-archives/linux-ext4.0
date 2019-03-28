Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D6FC4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 21:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF30D2184C
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 21:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfC1V3x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:29:53 -0400
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:26737 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbfC1V3x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 17:29:53 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 29 Mar 2019 07:59:50 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h9caq-0008Bp-Ef; Fri, 29 Mar 2019 08:29:48 +1100
Date:   Fri, 29 Mar 2019 08:29:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: don't allow most setxattr to immutable files
Message-ID: <20190328212948.GL23020@dastard>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
 <155379545404.24796.5019142212767521955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155379545404.24796.5019142212767521955.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 28, 2019 at 10:50:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> However, we don't actually check the immutable flag in the setattr code,
> which means that we can update project ids and extent size hints on
> supposedly immutable files.  Therefore, reject a setattr call on an
> immutable file except for the case where we're trying to unset
> IMMUTABLE.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2bd1c5ab5008..9cf0bc0ae2bd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1067,6 +1067,14 @@ xfs_ioctl_setattr_xflags(
>  	    !capable(CAP_LINUX_IMMUTABLE))
>  		return -EPERM;
>  
> +	/*
> +	 * If immutable is set and we are not clearing it, we're not allowed
> +	 * to change anything else in the inode.
> +	 */
> +	if ((ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
> +	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
> +		return -EPERM;
> +
>  	/* diflags2 only valid for v3 inodes. */
>  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
>  	if (di_flags2 && ip->i_d.di_version < 3)

Looks fine - catches both FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR
for XFS.

Do the other filesystems that implement FS_IOC_FSSETXATTR have
the same bug?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
