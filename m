From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
Date: Mon, 23 Jun 2008 14:31:07 -0600
Message-ID: <20080623203107.GD6239@webber.adilger.int>
References: <20080622201841.669ff882@olorin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kasper Sandberg <lkml@metanurb.dk>
To: FD Cami <francois.cami@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57878 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYFWUbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 16:31:42 -0400
In-reply-to: <20080622201841.669ff882@olorin>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 22, 2008  20:18 +0200, FD Cami wrote:
> This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
> in extX by extX_warning. We now get the device number in the warning message :
> "EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
> It also adds the device information on a pair of printk(KERN_ERR) (this was
> first suggested by Kasper two weeks ago).

The one issue is that KERN_ERR != KERN_WARNING, so these errors might
not be visible on the console, or may not be saved to the syslog.  The
other minor difference is that the function name is also printed, and this
makes the error message very long.

One suggestion is to create a separate macro that passes the KERN_*
flag and __func__ to ext3_console_msg(), and call that from
ext3_warning() and a new ext3_start_error() function.  I always found
it annoying to have to specify __func__ as a parameter for every call.

>  	ext3_warning(sb, __func__,
> -		     "updating to rev %d because of new feature flag, "
> -		     "running e2fsck is recommended",
> -		     EXT3_DYNAMIC_REV);
> +			"updating to rev %d because of new feature flag, "
> +			"running e2fsck is recommended",
> +			EXT3_DYNAMIC_REV);

Please don't change all of the indenting.  The old indending is proper
linux coding style (aligned with previous '('), the new one is not.

Note that you need to split up the patches for ext2, ext3, ext4 into
separate emails.  I'd suggest just sending one of them until we agree
on what is right, then submitting the rest afterward.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

