From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 4/6] ext2: tighten restrictions on inode flags
Date: Thu, 12 Jun 2008 10:38:53 +0100
Message-ID: <e9e943910806120238k73736218k8aa34857497b348a@mail.gmail.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <20080612090629.GX3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:7210 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYFLJix (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 05:38:53 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3533654wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 02:38:53 -0700 (PDT)
In-Reply-To: <20080612090629.GX3726@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/12 Andreas Dilger <adilger@sun.com>:
> On Jun 11, 2008  01:04 +0100, Duane Griffin wrote:
>> At the moment there are few restrictions on which flags may be set on which
>> inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
>> and APPEND may not be set on links. Tighten that to disallow TOPDIR being
>> set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
>> NOCOMP, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
>> regular files or directories.
>>
>> Introduce a flags masking function which masks flags based on mode and use
>> it during inode creation and when flags are set via the ioctl to facilitate
>> future consistency.
>
> This second set of patches is missing out on the presence of the
> "EXT2_FL_USER_MODIFIABLE" mask in ext2_ioctl(EXT2_IOC_SETFLAGS).  This is
> what prevents "unsettable" flags from being set from userspace.
>
> I don't have any objection to additional filtering to avoid setting the
> USER_MODIFIABLE flags on special files.

OK, thanks. I convinced myself that the patch wouldn't actually change
behaviour in the ioctl case, but thought it best to use it anyway for
consistency and to avoid future problems. I should probably have
mentioned that in the ChangeLog; I never know quite how exhaustive to
be in these things...

> Cheers, Andreas

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
