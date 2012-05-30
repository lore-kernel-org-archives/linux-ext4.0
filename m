From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] e2fsck: allow checking on mounted root filesystem
Date: Wed, 30 May 2012 16:55:58 -0600
Message-ID: <73E2624D-36C2-48A6-BF07-06482C85E15A@whamcloud.com>
References: <1337895296-16629-1-git-send-email-adilger@whamcloud.com> <1338403182-2253-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39798 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2E3W4D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2012 18:56:03 -0400
Received: by dady13 with SMTP id y13so416901dad.19
        for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 15:56:02 -0700 (PDT)
In-Reply-To: <1338403182-2253-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-30, at 12:39 PM, Andreas Dilger wrote:
> Commit 732e26b98e5c79a4298dbe341f43b54b354bb241 added checks to
> prevent e2fsck from being run in filesystem-modifying mode against
> a mounted or otherwise busy device, due to several bug reports of
> users doing this even with the verbose warnings in check_mount().
> 
> However, it also prevented e2fsck from checking a mounted root
> filesystem, which will prevent the node from booting.  Once again
> allow e2fsck to run against the mounted root filesystem.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> ---
> e2fsck/unix.c |    7 +++++--
> 1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 6161e46..1c1bae8 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1221,8 +1221,11 @@ restart:
> 			    &old_bitmaps);
> 	if (!old_bitmaps)
> 		flags |= EXT2_FLAG_64BITS;
> -	if ((ctx->options & E2F_OPT_READONLY) == 0)
> -		flags |= EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
> +	if ((ctx->options & E2F_OPT_READONLY) == 0) {
> +		flags |= EXT2_FLAG_RW;
> +		if (!(ctx->mount_flags & EXT2_MF_ISROOT))
> +			flags |= EXT2_FLAG_EXCLUSIVE;
> +	}

This should further exclude root filesystems that are not mounted
read-only.  Another patch on the way.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




