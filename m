From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH v5] ext4: make quota as first class supported feature
Date: Thu, 12 Jan 2012 11:55:55 +0100
Message-ID: <20120112105555.GA5374@granier.hd.free.fr>
References: <1326309116-28723-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53837 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2ALKz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2012 05:55:59 -0500
Received: by wgbds12 with SMTP id ds12so1643614wgb.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 02:55:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1326309116-28723-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:11:56AM -0800, Aditya Kali wrote:
> This patch is an attempt towards supporting quotas as first class
> feature in ext4. It is based on the proposal at:
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4
> This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA which, when
> turned on, enables quota accounting at mount time iteself. Also, the
> quota inodes are stored in two additional superblock fields.
> Some changes introduced by this patch that should be pointed out are:
> 1) Two new ext4-superblock fields - s_usr_quota_inum and s_grp_quota_inum
>    for storing the quota inodes in use.
> 2) Default quota inodes are: inode#3 for tracking userquota and inode#4 for
>    tracking group quota. The superblock fields can be set to use other inodes
>    as well.
> 3) If the QUOTA feature and corresponding quota inodes are set in superblock,
>    the quota usage tracking is turned on at mount time. On 'quotaon' ioctl, the
>    quota limits enforcement is turned on. 'quotaoff' ioctl turns off only the
>    limits enforcement in this case.
> 4) When QUOTA feature is in use, the quota mount options 'quota', 'usrquota',
>    'grpquota' are ignored by the kernel.
> 5) mke2fs or tune2fs can be used to set the QUOTA feature and initialize quota
>    inodes. The default reserved inodes will not be visible to user as
>    regular files.
> 6) The quota-tools will need to be modified to support hidden quota files on
>    ext4. E2fsprogs will also include support for creating and fixing quota
>    files.
> 7) Support is only for the new V2 quota file format.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Looks good to me.
Reviewed-by: Johann Lombardi <johann@whamcloud.com>

Johann
