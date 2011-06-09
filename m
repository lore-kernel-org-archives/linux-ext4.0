From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch]check NULL pointer
Date: Thu, 9 Jun 2011 11:24:44 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>
References: <1307590292.15392.71.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1FIJYu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 05:24:50 -0400
In-Reply-To: <1307590292.15392.71.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 9 Jun 2011, Shaohua Li wrote:

> orig_data could be NULL.

Now, that is the commit description :). Could you please be more
descriptive in the "descritpion" ? Also the subject is not right either,
please see Documentation/SubmittingPatches

Thanks!
-Lukas

> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cc5c157..45fc255 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3057,6 +3057,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
>  
> +	if (!orig_data)
> +		return ret;

Again no data, no reason for backing off.

>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		goto out_free_orig;
> @@ -4285,6 +4287,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  #endif
>  	char *orig_data = kstrdup(data, GFP_KERNEL);
>  
> +	if (!orig_data)
> +		return -ENOMEM;


This does not seem right, it there is no data we will end with ENOMEM
for no reason.

>  	/* Store the original options */
>  	lock_super(sb);
>  	old_sb_flags = sb->s_flags;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
