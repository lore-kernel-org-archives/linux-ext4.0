From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH-e2fsprogs] filefrag: fix fm_start in filefrag_fiemap	loop
Date: Tue, 02 Jun 2009 12:35:13 -0600
Message-ID: <20090602183513.GK3218@webber.adilger.int>
References: <1243965783-31950-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59736 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZFBSf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2009 14:35:27 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n52IZS8R009388
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jun 2009 11:35:29 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKM00M00J677T00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 02 Jun 2009 11:35:28 -0700 (PDT)
In-reply-to: <1243965783-31950-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you please provide some more details of the problem this solves.

On Jun 03, 2009  02:03 +0800, Peng Tao wrote:
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
>  misc/filefrag.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 6bea2cd..7786646 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -239,7 +239,7 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  			n++;
>  		}
>  
> -		fiemap->fm_start += fm_ext[i-1].fe_logical +
> +		fiemap->fm_start = fm_ext[i-1].fe_logical +
>  							fm_ext[i-1].fe_length;
>  	} while (last == 0);
>  
> -- 
> 1.6.2.GIT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

