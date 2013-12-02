From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: enable punch hole for bigalloc
Date: Mon, 2 Dec 2013 12:29:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1312021225080.3930@localhost.localdomain>
References: <1385820218-4673-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab3LBL3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 06:29:41 -0500
In-Reply-To: <1385820218-4673-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 30 Nov 2013, Zheng Liu wrote:

> Date: Sat, 30 Nov 2013 22:03:38 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
>     Lukas Czerner <lczerner@redhat.com>, Zheng Liu <wenqing.lz@taobao.com>
> Subject: [PATCH] ext4: enable punch hole for bigalloc
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After applied this commit (d23142c6), ext4 has supported punch hole for
> a file system with bigalloc feature.  But we forgot to enable it.  This
> commit fixes it.

Hi,

I actually send out this patch as a part of the series which
implemented it and it even got review for Jan Kara

http://www.spinics.net/lists/linux-ext4/msg37914.html

however Ted noticed that xfstest shared/298 failed, but that was not
due to bug in the code,but rather the problem with the test itself,
see:

https://lkml.org/lkml/2013/6/18/329

So I am not sure why it was not merged a long time ago. Ted probably
just overlooked my response.

Ted can we have my or this patch (they are the same) merged ?
Thanks!

-Lukas



> 
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/inode.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0757634..2d73587 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3513,11 +3513,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	if (!S_ISREG(inode->i_mode))
>  		return -EOPNOTSUPP;
>  
> -	if (EXT4_SB(sb)->s_cluster_ratio > 1) {
> -		/* TODO: Add support for bigalloc file systems */
> -		return -EOPNOTSUPP;
> -	}
> -
>  	trace_ext4_punch_hole(inode, offset, length);
>  
>  	/*
> 
