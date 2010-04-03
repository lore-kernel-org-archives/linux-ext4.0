From: tytso@mit.edu
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sat, 3 Apr 2010 12:53:40 -0400
Message-ID: <20100403165340.GA17819@thunk.org>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
 <20100322012758.GE11560@thunk.org>
 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0DCQxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 12:53:49 -0400
Content-Disposition: inline
In-Reply-To: <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jing,

If you're wondering why I'm taking a long time to respond to your
patches, it is because they are very ill-formed.  They don't conform
to the submitting patches guidelines, the patch comments don't
adequately explain the why the patch is needed, and what testing has
been done, and you tend to throw in patches that aren't correctly
submitted in the middle of comments, and in some cases it's not clear
whether this patch is suppose to be in addition to the previous patch,
and combined into a separate commit, or kept as two separate patches,
etc.

As a result, it takes, much, MUCH, MUCH longer for me to review the
patches for correctness.  I will eventually get to them, but I may end
up working on other patches which are better formed and easier for me
to evaluate for correctness and quality.

If you do submit new patches, especially in this thread where you have
already submitted so many different patches, I would appreicate it if
you could explicitly state that a particular patch has been superceded
by another, or has been withdrawn.  I will try to keep score on the
patchwork web site (for example, I rejected your bb_free_cache patch),
but you've been so prolific with patches, some of which haven't been
very well explained, that I may have lost track of all of your
submissions.   

Please bear with me.

Best regards,

					- Ted




On Sun, Mar 28, 2010 at 04:13:51PM +0800, jing zhang wrote:
> 2010/3/26, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> > On Tue, 23 Mar 2010 20:47:39 +0800, jing zhang <zj.barak@gmail.com> wrote:
> >> 2010/3/22, tytso@mit.edu <tytso@mit.edu>:
> >> > On Sun, Mar 21, 2010 at 10:01:06PM +0800, jing zhang wrote:
> >> >> From: Jing Zhang <zj.barak@gmail.com>
> >> >>
> >> >> Date: Sun Mar 21 21:59:35     2010
> >> >>
> >> >> Cc: Theodore Ts'o <tytso@mit.edu>
> >> >> Cc: Andreas Dilger <adilger@sun.com>
> >> >> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> >> >> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> >> >>
> >> >> ---
> >> >>
> >> >> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> >> >> +++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
> >> >> @@ -2360,6 +2360,24 @@ err_freesgi:
> >> >>  	return -ENOMEM;
> >> >>  }
> >> >>
> >> >> +static void ext4_mb_destroy_backend(struct super_block *sb)
> >> >> +{
> >> >> +	ext4_group_t ngroups = ext4_get_groups_count(sb);
> >> >> +	ext4_group_t i;
> >> >> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> >> >> +	int j;
> >> >> +	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
> >> >> +					>> EXT4_DESC_PER_BLOCK_BITS(sb);
> >> >> +	for (i = 0; i < ngroups; i++)
> >> >> +		kfree(ext4_get_group_info(sb, i));
> >> >> +
> >> >> +	for (j = 0; j < num_meta_group_infos; j++)
> >> >> +		kfree(sbi->s_group_info[j]);
> >> >> +
> >> >> +	kfree(sbi->s_group_info);
> >> >> +	iput(sbi->s_buddy_cache);
> >> >> +}
> >> >> +
> >> >
> >> > It would be better if this could be done by making ext4_mb_release()
> >> > more flexible, and then calling ext4_mb_release() if there is an error
> >> > setting up the data structures in ext4_mb_init().
> >> >
> >> > 						- Ted
> >> >
> >>
> >> Yeah, Ted, going through ext4_mb_release() is clearer.
> >>
> >> ---
> >>
> >> diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc3.c
> >> index bba1282..99ca2de 100644
> >> --- a/linux-2.6.32/fs/ext4/mballoc.c
> >> +++ b/ext4_mm_leak/mballoc3.c
> >> @@ -2417,8 +2417,7 @@ int ext4_mb_init(struct super_block *sb, int
> >> needs_recovery)
> >>
> >>  	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
> >>  	if (sbi->s_locality_groups == NULL) {
> >> -		kfree(sbi->s_mb_offsets);
> >> -		kfree(sbi->s_mb_maxs);
> >> +		ext4_mb_release(sb);
> >
> > We may want to make sure that we can safely call ext4_mb_release that
> > early. what i would suggest is to move s_locality_group allocation
> > before ext4_mb_init. that makes error handling easy
> >
> 
> cool idea, Aneesh, and I got it.
> 
> ---
> 
> --- old-linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc3-2.c	2010-03-28 16:13:20.000000000 +0800
> @@ -2397,11 +2397,27 @@ int ext4_mb_init(struct super_block *sb,
>  		i++;
>  	} while (i <= sb->s_blocksize_bits + 1);
> 
> +	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
> +	if (sbi->s_locality_groups == NULL) {
> +		kfree(sbi->s_mb_offsets);
> +		kfree(sbi->s_mb_maxs);
> +		return -ENOMEM;
> +	}
> +	for_each_possible_cpu(i) {
> +		struct ext4_locality_group *lg;
> +		lg = per_cpu_ptr(sbi->s_locality_groups, i);
> +		mutex_init(&lg->lg_mutex);
> +		for (j = 0; j < PREALLOC_TB_SIZE; j++)
> +			INIT_LIST_HEAD(&lg->lg_prealloc_list[j]);
> +		spin_lock_init(&lg->lg_prealloc_lock);
> +	}
> +
>  	/* init file for buddy data */
>  	ret = ext4_mb_init_backend(sb);
>  	if (ret != 0) {
>  		kfree(sbi->s_mb_offsets);
>  		kfree(sbi->s_mb_maxs);
> +		free_percpu(sbi->s_locality_groups);
>  		return ret;
>  	}
> 
> @@ -2415,20 +2431,6 @@ int ext4_mb_init(struct super_block *sb,
>  	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
>  	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
> 
> -	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
> -	if (sbi->s_locality_groups == NULL) {
> -		kfree(sbi->s_mb_offsets);
> -		kfree(sbi->s_mb_maxs);
> -		return -ENOMEM;
> -	}
> -	for_each_possible_cpu(i) {
> -		struct ext4_locality_group *lg;
> -		lg = per_cpu_ptr(sbi->s_locality_groups, i);
> -		mutex_init(&lg->lg_mutex);
> -		for (j = 0; j < PREALLOC_TB_SIZE; j++)
> -			INIT_LIST_HEAD(&lg->lg_prealloc_list[j]);
> -		spin_lock_init(&lg->lg_prealloc_lock);
> -	}
> 
>  	if (sbi->s_proc)
>  		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
> 
> 
> >
> >
> >>  		return -ENOMEM;
> >>  	}
> >>  	for_each_possible_cpu(i) {
> >> @@ -2511,7 +2510,8 @@ int ext4_mb_release(struct super_block *sb)
> >>  				atomic_read(&sbi->s_mb_discarded));
> >>  	}
> >>
> >> -	free_percpu(sbi->s_locality_groups);
> >> +	if (sbi->s_locality_groups)
> >> +		free_percpu(sbi->s_locality_groups);
> >>  	if (sbi->s_proc)
> >>  		remove_proc_entry("mb_groups", sbi->s_proc);
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > -aneesh
> >
