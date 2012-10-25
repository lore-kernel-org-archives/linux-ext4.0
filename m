From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix overhead calculations in ext4_statfs, again
Date: Thu, 25 Oct 2012 12:14:23 -0500
Message-ID: <5089736F.1030509@redhat.com>
References: <50896FD6.1010807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935883Ab2JYRO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 13:14:26 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9PHEQKY013133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 13:14:26 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9PHENRZ000811
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 13:14:26 -0400
In-Reply-To: <50896FD6.1010807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sorry that should be "ext4_statfs" in the subject.

On 10/25/12 11:59 AM, Eric Sandeen wrote:
> "overhead" was a write-only variable in this function after commit
> 952fc18e; we set it to 0 for minixdf, or to sbi->s_overhead if !minixdf,
> but never read it again after that.
> 
> We need to use it, not sbi->s_overhead, when subtracting out overhead
> for f_blocks, or we get the wrong answer for minixdf.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> "Once more, with feeling!" ;)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e44b233..2feaf78 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4758,7 +4758,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  	buf->f_type = EXT4_SUPER_MAGIC;
>  	buf->f_bsize = sb->s_blocksize;
> -	buf->f_blocks = ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead);
> +	buf->f_blocks = ext4_blocks_count(es) - EXT4_C2B(sbi, overhead);
>  	bfree = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
>  		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
>  	/* prevent underflow in case that few free space is available */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

