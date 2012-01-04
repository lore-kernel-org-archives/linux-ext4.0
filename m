From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 13/15] ext4: add new online resize interface
Date: Wed, 4 Jan 2012 00:03:33 -0500
Message-ID: <20120104050333.GA13438@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-14-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50268 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab2ADFDf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:03:35 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-14-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 07:00:10PM +0800, Yongqiang Yang wrote:
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Online resizing not supported with bigalloc");
> +			return -EOPNOTSUPP;
> +		}

I've also added checks to disable on-line resizing if the meta_bg file
system feature is set, since the on-line resizing code in this patch
series does not support the meta_bg block group descriptor layout
(which is required for file systems > 32-bits).

In addition, I've added a check so that if the requested number of
blocks is greater than 2**32-1, and the 64-bit option is not set, to
bail out with an error.

In theory the resize2fs userspace code will be doing these checks, but
(a) at some point in the future the meta_bg support will be added, and
so if the kernel doesn't support meta_bg, it needs to fail, and not
depend on userspace to do this check.  Also (b) we want to make sure
this code doesn't do something crazy in case someone calls the ioctl
directly.

						- Ted
