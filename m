From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Tue, 9 Sep 2008 11:06:30 +0400
Message-ID: <20080909070630.GC5786@x200.localdomain>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu> <20080907164130.GA3376@x200.localdomain> <20080908143951.GH8161@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:46868 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYIIHEo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 03:04:44 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1055236yxm.1
        for <linux-ext4@vger.kernel.org>; Tue, 09 Sep 2008 00:04:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080908143951.GH8161@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2008 at 10:39:51AM -0400, Theodore Tso wrote:
> Here's what I've checked into the ext4 patch queue for submission to
> mainline at the next merge window.  I've added a bit more error
> checking in case proc_mkdir() fails and returns NULL.

Hopefully, Andrew, will pick up original non-broken patch.

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
> +
>  	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
> +	if (!sbi->s_mb_proc)
> +		goto err_create_dir;
>  
>  	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
>  	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
> @@ -2804,7 +2809,6 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
>  	return 0;
>  
>  err_out:
> -	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
>  	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
>  	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
>  	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
> @@ -2813,6 +2817,8 @@ err_out:
>  	remove_proc_entry(EXT4_MB_STATS_NAME, sbi->s_mb_proc);
>  	remove_proc_entry(devname, proc_root_ext4);
>  	sbi->s_mb_proc = NULL;
> +err_create_dir:
> +	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
>  
>  	return -ENOMEM;
>  }
