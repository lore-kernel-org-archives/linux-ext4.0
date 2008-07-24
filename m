From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] ext4: improve ext4_fill_flex_info() a bit
Date: Thu, 24 Jul 2008 12:09:38 -0500
Message-ID: <20080724120938.59bd2220@ichigo>
References: <4887DB2C.1080403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39269 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbYGXRJl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2008 13:09:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6OH9e08003853
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2008 13:09:40 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6OH9esj204056
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2008 13:09:40 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6OH9dPl008114
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2008 13:09:40 -0400
In-Reply-To: <4887DB2C.1080403@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 24 Jul 2008 09:30:20 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> - use kzalloc() instead of kmalloc() + memset()
> - improve a printk info

Nicer - Thanks

Acked-by: Jose R. Santos <jrs@us.ibm.com>

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/ext4/super.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1cb371d..33eab31 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1506,14 +1506,13 @@ static int ext4_fill_flex_info(struct super_block *sb)
> 
>  	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
>  		groups_per_flex;
> -	sbi->s_flex_groups = kmalloc(flex_group_count *
> +	sbi->s_flex_groups = kzalloc(flex_group_count *
>  				     sizeof(struct flex_groups), GFP_KERNEL);
>  	if (sbi->s_flex_groups == NULL) {
> -		printk(KERN_ERR "EXT4-fs: not enough memory\n");
> +		printk(KERN_ERR "EXT4-fs: not enough memory for "
> +				"%lu flex groups\n", flex_group_count);
>  		goto failed;
>  	}
> -	memset(sbi->s_flex_groups, 0, flex_group_count *
> -	       sizeof(struct flex_groups));
> 
>  	gdp = ext4_get_group_desc(sb, 1, &bh);
>  	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
