From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sat, 06 Sep 2008 01:57:13 -0600
Message-ID: <20080906075713.GM3086@webber.adilger.int>
References: <20080905210652.GE11569@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ralf.hildebrandt@charite.de, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56609 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYIFH5X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Sep 2008 03:57:23 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m867vGBx021837
	for <linux-ext4@vger.kernel.org>; Sat, 6 Sep 2008 00:57:16 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6R00701KQCTU00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 06 Sep 2008 00:57:15 -0700 (PDT)
In-reply-to: <20080905210652.GE11569@x200.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 06, 2008  01:06 +0400, Alexey Dobriyan wrote:
> [PATCH] ext4: fix #11321: create /proc/ext4/*/stats more carefully
> 
> ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
> basis is taken from bdevname, which, surprise, can contain slash.
> 
> However, proc while allowing to use proc_create("a/b", parent) form of
> PDE creation, assumes that parent/a was already created.
> 
> bdevname in question is 'cciss/c0d0p9', directory is not created and all
> this stuff goes directly into /proc (which is real bug).
> 
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2792,6 +2792,15 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
>  		return -EINVAL;
>  	}
>  	bdevname(sb->s_bdev, devname);
> +	{
> +		char *p = devname;
> +
> +		while (*p != '\0') {
> +			if (*p == '/')
> +				*p = '!';
> +			p++;
> +		}
> +	}

Why not use strchr(), which is normally optimized assembly:

	char *p = devname;
	while ((p = strchr(p, '/'))
		*p = '_';

Using '!' as the separator makes it harder to use from shells I suspect,
so I'd suggest '_' instead.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

