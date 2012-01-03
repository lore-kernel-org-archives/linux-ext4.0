From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Report max_batch_time option correctly
Date: Tue, 03 Jan 2012 09:46:24 -0600
Message-ID: <4F0322D0.2070403@redhat.com>
References: <1325513582.13595.213.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	654206@bugs.debian.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab2ACPqq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 10:46:46 -0500
In-Reply-To: <1325513582.13595.213.camel@deadeye>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/2/12 8:13 AM, Ben Hutchings wrote:
> Currently the value reported for max_batch_time is really the
> value of min_batch_time.
> 
> Reported-by: Russell Coker <russell@coker.com.au>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

whoops, yep!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3e1329e..410e993 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1096,7 +1096,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	}
>  	if (sbi->s_max_batch_time != EXT4_DEF_MAX_BATCH_TIME) {
>  		seq_printf(seq, ",max_batch_time=%u",
> -			   (unsigned) sbi->s_min_batch_time);
> +			   (unsigned) sbi->s_max_batch_time);
>  	}
>  
>  	/*

