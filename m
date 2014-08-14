From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: include journal blocks of internal journal in df
 overhead calcs
Date: Wed, 13 Aug 2014 20:21:00 -0700
Message-ID: <53EC2B1C.1090806@redhat.com>
References: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chin-Tsung Cheng <chintzung@gmail.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaHNDVH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2014 23:21:07 -0400
In-Reply-To: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/13/14, 6:37 AM, Chin-Tsung Cheng wrote:
> The journal blocks of external journal device should not
> be counted as overhead.
> 
> Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>

Yep, I added this and didn't consider external journals, oops.	

Agree with Darrick that whitespace (and parens) aren't ideal...

Is this a shorter test?

	if (sbi->s_journal && !sbi->journal_bdev) {
		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);


*sbi gets kzalloced and I *think* journal_bdev is only filled in for
external journals...

ext3_statfs probably needs the same treatment, it unconditionally does:


                /* Add the journal blocks as well */
                overhead += sbi->s_journal->j_maxlen;

-Eric

> ---
>  fs/ext4/super.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 32b43ad..03b2f62 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3316,9 +3316,10 @@ int ext4_calculate_overhead(struct super_block *sb)
>  			memset(buf, 0, PAGE_SIZE);
>  		cond_resched();
>  	}
> -	/* Add the journal blocks as well */
> -	if (sbi->s_journal)
> -		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
> +	/* Add the internal journal blocks as well */
> +	if ((sbi->s_journal) &&
> +		(sbi->s_journal->j_fs_dev == sbi->s_journal->j_dev))
> +			overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
>  
>  	sbi->s_overhead = overhead;
>  	smp_wmb();
> 

