From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Wed, 9 Jan 2008 13:10:41 +0100
Message-ID: <20080109121041.GA1013@atrey.karlin.mff.cuni.cz>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, bzzz@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44090 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYAIMKm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 07:10:42 -0500
Content-Disposition: inline
In-Reply-To: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> With the multi block allocator when we don't have prealloc space we discard
> the existing preallocaltion data and try to rebuild the buddy cache. While
> discarding the loop through the group specific prealloc list. If we find any
> particular prealloc space being used we mark the space busy. If we are not
> able to find enough free space and if we have any prealloc space busy we loop
> back again. With non preempted kernel this tight loop resulted in watchdog
> timer triggering soft lockup warning.
> 
> 
> Whe we are allocation the block we search the prealloc list and mark the
> prealloc space used via incrementing pa_count value. One after succesffuly
> allocating the block we need to update the block bitmap and this could
> actually involved a disk io if the bitmap need to read from the disk. This
> actually cause prealloc space to be marked used for quiet a long time. This
> inturn results in the discard logic going on tight loop resulting in watchdog
> timer triggering soft lockup warning.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 844765c..cbc8143 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3729,7 +3729,7 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
>  	struct list_head list;
>  	struct ext4_buddy e4b;
>  	int err;
> -	int busy;
> +	int busy = 0;
>  	int free = 0;
>  
>  	mb_debug("discard preallocation for group %lu\n", group);
> @@ -3754,20 +3754,12 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
>  	INIT_LIST_HEAD(&list);
>  
>  repeat:
> -	busy = 0;
>  	ext4_lock_group(sb, group);
>  	list_for_each_entry_safe(pa, tmp,
>  				&grp->bb_prealloc_list, pa_group_list) {
>  		spin_lock(&pa->pa_lock);
>  		if (atomic_read(&pa->pa_count)) {
>  			spin_unlock(&pa->pa_lock);
> -			/* FIXME!!
> -			 * It is quiet natural to have the pa being
> -			 * used on other cpus when we are trying free
> -			 * space
> -			printk(KERN_ERR "uh! busy PA\n");
> -			dump_stack();
> -			*/
>  			busy = 1;
>  			continue;
>  		}
> @@ -3790,7 +3782,9 @@ repeat:
>  
>  	/* if we still need more blocks and some PAs were used, try again */
>  	if (free < needed && busy) {
> +		busy = 0;
>  		ext4_unlock_group(sb, group);
> +		schedule_timeout(HZ);
>  		goto repeat;
>  	}
  Hmm, wouldn't just schedule() be enough here? That would give a good
chance to other processes to proceed and we would avoid this artificial
wait of 1s which is quite ugly IMO.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
