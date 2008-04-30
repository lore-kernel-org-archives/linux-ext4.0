From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: start seraching for the right extent from the goal
 group.
Date: Wed, 30 Apr 2008 07:58:35 -0500
Message-ID: <48186CFB.8050206@redhat.com>
References: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYD3NGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 09:06:53 -0400
In-Reply-To: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> With mballoc we search for the best extent using different
> criteria. We should always use the goal group when we are
> starting with a new criteria.

Aneesh, is there any testcase etc that will demonstrate the resulting
difference in layout?

It's not clear to me from this changelog (without looking at a lot more
context) exactly what you're changing and why...

thanks,
-eric

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 2a6c814..9b4cde7 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1730,10 +1730,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
>  		spin_unlock(&sbi->s_md_lock);
>  	}
> -
> -	/* searching for the right group start from the goal value specified */
> -	group = ac->ac_g_ex.fe_group;
> -
>  	/* Let's just scan groups to find more-less suitable blocks */
>  	cr = ac->ac_2order ? 0 : 1;
>  	/*
> @@ -1743,6 +1739,12 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  repeat:
>  	for (; cr < 4 && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
>  		ac->ac_criteria = cr;
> +		/*
> +		 * searching for the right group start
> +		 * from the goal value specified
> +		 */
> +		group = ac->ac_g_ex.fe_group;
> +
>  		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
>  			struct ext4_group_info *grp;
>  			struct ext4_group_desc *desc;

