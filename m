From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Tue, 9 Sep 2008 11:19:55 +0400
Message-ID: <20080909071955.GA5891@x200.localdomain>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu> <20080907164130.GA3376@x200.localdomain> <20080908143951.GH8161@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:30755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIIHSI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 03:18:08 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1744584fgg.17
        for <linux-ext4@vger.kernel.org>; Tue, 09 Sep 2008 00:18:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080908143951.GH8161@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2008 at 10:39:51AM -0400, Theodore Tso wrote:
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2785,14 +2785,19 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
>  	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct proc_dir_entry *proc;
> -	char devname[64];
> +	char devname[64], *p;
>  
>  	if (proc_root_ext4 == NULL) {
>  		sbi->s_mb_proc = NULL;
>  		return -EINVAL;
>  	}
>  	bdevname(sb->s_bdev, devname);
> +	while (p = strchr(p, '/'))
> +		*p = '!';

This can't work because "p" is uninitialized. And gcc whines about one
more pair of ().
