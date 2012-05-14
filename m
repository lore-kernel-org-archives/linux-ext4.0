From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext4: potential NULL dereference on error
Date: Tue, 15 May 2012 00:25:35 +0200
Message-ID: <20120514222535.GW5353@quack.suse.cz>
References: <20120513144104.GA21998@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab2ENWZw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 18:25:52 -0400
Content-Disposition: inline
In-Reply-To: <20120513144104.GA21998@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 13-05-12 17:41:04, Dan Carpenter wrote:
> The ext4_get_group_desc() function returns NULL on error, and
> ext4_free_inodes_count() function dereferences it without checking.
> There is a check on the next line, but it's too late.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker fix.
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a044a9b..1526f33 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -389,7 +389,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
>  	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
> -	unsigned int freei, avefreei, grp_free;
> +	unsigned int freei, avefreei;
>  	ext4_fsblk_t freeb, avefreec;
>  	unsigned int ndirs;
>  	int max_dirs, min_inodes;
> @@ -399,6 +399,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
>  	struct orlov_stats stats;
>  	int flex_size = ext4_flex_bg_size(sbi);
>  	struct dx_hash_info hinfo;
> +	unsigned int grp_free = 0;
>  
>  	ngroups = real_ngroups;
>  	if (flex_size > 1) {
> @@ -508,7 +509,8 @@ fallback_retry:
>  	for (i = 0; i < ngroups; i++) {
>  		grp = (parent_group + i) % ngroups;
>  		desc = ext4_get_group_desc(sb, grp, NULL);
> -		grp_free = ext4_free_inodes_count(sb, desc);
> +		if (desc)
> +			grp_free = ext4_free_inodes_count(sb, desc);
>  		if (desc && grp_free && grp_free >= avefreei) {
  So you it would be more logical to do:
		if (desc) {
			grp_free = ext4_free_inodes_count(sb, desc);
			if (grp_free && grpfree >= avefreei) {
	 			*group = grp;
	 			return 0;
			}
		}

  Wouldn't it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
