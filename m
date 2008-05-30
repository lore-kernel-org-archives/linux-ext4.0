From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: remove redundant code in ext4_fill_super()
Date: Fri, 30 May 2008 13:57:27 -0700
Message-ID: <1212181047.3719.10.camel@localhost.localdomain>
References: <483F8D31.7090505@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51522 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYE3U5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 16:57:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4UKvXfn027989
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 16:57:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UKvX6r156670
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 16:57:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UKvWIo024433
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 16:57:32 -0400
In-Reply-To: <483F8D31.7090505@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-05-30 at 13:14 +0800, Li Zefan wrote:
> The previous sb_min_blocksize() has already set the block size.
> 
> This piece of code was introduced in commit:
> 	afc7cbca5bfd556c3e12d3acefbee5ab0cbd4670
> 	(ext4: Support large blocksize up to PAGESIZE)
> And it should be a mistake.
> 
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Added to  ext4 patch queue http://repo.or.cz/w/ext4-patch-queue.git
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/ext4/super.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 09d9359..5d07aa9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1843,11 +1843,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>  		goto out_fail;
>  	}
> 
> -	if (!sb_set_blocksize(sb, blocksize)) {
> -		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
> -		goto out_fail;
> -	}
> -
>  	/*
>  	 * The ext4 superblock will not be buffer aligned for other than 1kB
>  	 * block sizes.  We need to calculate the offset from buffer start.

