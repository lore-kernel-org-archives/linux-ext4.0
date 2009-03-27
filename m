From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] ext4: typo leads to small leak
Date: Fri, 27 Mar 2009 09:13:29 -0500
Message-ID: <49CCDF09.3020804@redhat.com>
References: <Pine.LNX.4.64.0809291437490.14101@usbsys.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZC0ONh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 10:13:37 -0400
In-Reply-To: <Pine.LNX.4.64.0809291437490.14101@usbsys.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dan Carpenter wrote:
> This was found by smatch (http://repo.or.cz/w/smatch.git/)
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!  Maybe one for the stable trees.

> --- orig/fs/ext4/mballoc.c	2009-03-26 18:22:30.000000000 +0300
> +++ devel/fs/ext4/mballoc.c	2009-03-26 18:22:56.000000000 +0300
> @@ -2693,7 +2693,7 @@
>  	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
>  	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
>  	if (sbi->s_mb_maxs == NULL) {
> -		kfree(sbi->s_mb_maxs);
> +		kfree(sbi->s_mb_offsets);
>  		return -ENOMEM;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

