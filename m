From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] avoid NULL deference in ext2_xattr_get
Date: Sat, 10 Jul 2010 11:07:36 +0200
Message-ID: <20100710090736.GR19184@bicker>
References: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: shenghui <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0GJJJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jul 2010 05:09:49 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Good catch.  Your change is correct but can you resend it?

On Sat, Jul 10, 2010 at 04:07:28PM +0800, shenghui wrote:
> >From adc1fa6535034db3b6d8deebda6ec7eaa8bfd2f8 Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui <crosslonelyover@gmail.com>
> Date: Sat, 10 Jul 2010 16:05:53 +0800
> Subject: [PATCH] avoid NULL deference in ext2_xattr_get
> 

The longer description of the bug should go here.

> 
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
>  fs/ext2/xattr.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..81ec1c6 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int
> name_index, const char *name,
^^^^^^

Your email client line wrapped the patch.  Please send it to yourself
and then save the email including headers and everything.
	cd linux-2.6
	cat ~/your-email-text | patch -p1 

If it applies cleanly then resend it to the list.

regards,
dan carpenter


