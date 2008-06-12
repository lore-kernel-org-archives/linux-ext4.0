From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 4/6] ext2: tighten restrictions on inode flags
Date: Thu, 12 Jun 2008 03:06:29 -0600
Message-ID: <20080612090629.GX3726@webber.adilger.int>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51934 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbYFLJGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 05:06:34 -0400
In-reply-to: <1213142649-32685-5-git-send-email-duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 11, 2008  01:04 +0100, Duane Griffin wrote:
> At the moment there are few restrictions on which flags may be set on which
> inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
> and APPEND may not be set on links. Tighten that to disallow TOPDIR being
> set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
> NOCOMP, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
> regular files or directories.
> 
> Introduce a flags masking function which masks flags based on mode and use
> it during inode creation and when flags are set via the ioctl to facilitate
> future consistency.

This second set of patches is missing out on the presence of the
"EXT2_FL_USER_MODIFIABLE" mask in ext2_ioctl(EXT2_IOC_SETFLAGS).  This is
what prevents "unsettable" flags from being set from userspace.

I don't have any objection to additional filtering to avoid setting the
USER_MODIFIABLE flags on special files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

