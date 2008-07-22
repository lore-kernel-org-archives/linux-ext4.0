From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
Date: Tue, 22 Jul 2008 10:11:18 -0500
Message-ID: <4885F896.1010506@redhat.com>
References: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYGVPOi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2008 11:14:38 -0400
In-Reply-To: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> NR_CPUS can be really large. We should be using nr_cpu_ids
> instead.

Yep, thanks,  I thought we got rid of these at some point but guess not
(or not all)!

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Acked-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/mballoc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 9db0f4d..5b854b7 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2541,7 +2541,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
>  	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
>  
> -	i = sizeof(struct ext4_locality_group) * NR_CPUS;
> +	i = sizeof(struct ext4_locality_group) * nr_cpu_ids;
>  	sbi->s_locality_groups = kmalloc(i, GFP_KERNEL);
>  	if (sbi->s_locality_groups == NULL) {
>  		clear_opt(sbi->s_mount_opt, MBALLOC);
> @@ -2549,7 +2549,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  		kfree(sbi->s_mb_maxs);
>  		return -ENOMEM;
>  	}
> -	for (i = 0; i < NR_CPUS; i++) {
> +	for (i = 0; i < nr_cpu_ids; i++) {
>  		struct ext4_locality_group *lg;
>  		lg = &sbi->s_locality_groups[i];
>  		mutex_init(&lg->lg_mutex);

