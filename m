From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC][PATCH] ext4: introduce reserved space
Date: Fri, 5 Apr 2013 16:01:37 -0300
Message-ID: <20130405190136.GA20196@andromeda.usersys.redhat.com>
References: <1363776287-6115-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162492Ab3DETBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 15:01:42 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r35J1g6X022116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 5 Apr 2013 15:01:42 -0400
Content-Disposition: inline
In-Reply-To: <1363776287-6115-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,

the patch is really good IMHO, but, there is one thing I think I should comment:

>  	if (blks < 0) {
>  		struct super_block *sb = mpd->inode->i_sb;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9379b7f..6ef160ae 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -81,6 +81,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
>  static void ext4_destroy_lazyinit_thread(void);
>  static void ext4_unregister_li_request(struct super_block *sb);
>  static void ext4_clear_request_list(void);
> +static int ext4_reserve_clusters(struct ext4_sb_info *, ext4_fsblk_t);
>  
>  #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
>  static struct file_system_type ext2_fs_type = {
> @@ -2375,6 +2376,17 @@ struct ext4_attr {
>  	int offset;
>  };
>  
> +static int parse_strtoull(const char *buf,
> +		unsigned long long max, unsigned long long *value)
> +{
> +	int ret;
> +
> +	ret = kstrtoull(skip_spaces(buf), 0, value);
> +	if (!ret && *value > max)

		^^^ IMHO this should be replaced by a logical OR, instead of
		    AND, I believe both conditions here should fail to a
		    -EINVAL

> +		ret = -EINVAL;
> +	return ret;
> +}
> +
>  static int parse_strtoul(const char *buf,
>  		unsigned long max, unsigned long *value)
>  {
> @@ -2459,6 +2471,27 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
>  	return count;
>  }
>  
> +static ssize_t reserved_clusters_show(struct ext4_attr *a,
> +				  struct ext4_sb_info *sbi, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%lu\n",
> +			atomic64_read(&sbi->s_resv_clusters));
> +}
> +
> +static ssize_t reserved_clusters_store(struct ext4_attr *a,
> +				   struct ext4_sb_info *sbi,
> +				   const char *buf, size_t count)
> +{
> +	unsigned long long val;
> +	int ret;
> +
> +	if (parse_strtoull(buf, -1ULL, &val))
> +		return -EINVAL;
> +	ret = ext4_reserve_clusters(sbi, val);
> +
> +	return ret ? ret : count;
> +}
> +
>  static ssize_t trigger_test_error(struct ext4_attr *a,
>  				  struct ext4_sb_info *sbi,
>  				  const char *buf, size_t count)
> @@ -2496,6 +2529,7 @@ static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
>  EXT4_RO_ATTR(delayed_allocation_blocks);
>  EXT4_RO_ATTR(session_write_kbytes);
>  EXT4_RO_ATTR(lifetime_write_kbytes);
> +EXT4_RW_ATTR(reserved_clusters);
>  EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
>  		 inode_readahead_blks_store, s_inode_readahead_blks);
>  EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
> @@ -2513,6 +2547,7 @@ static struct attribute *ext4_attrs[] = {
>  	ATTR_LIST(delayed_allocation_blocks),
>  	ATTR_LIST(session_write_kbytes),
>  	ATTR_LIST(lifetime_write_kbytes),
> +	ATTR_LIST(reserved_clusters),
>  	ATTR_LIST(inode_readahead_blks),
>  	ATTR_LIST(inode_goal),
>  	ATTR_LIST(mb_stats),
> @@ -3188,6 +3223,40 @@ int ext4_calculate_overhead(struct super_block *sb)
>  	return 0;
>  }
>  
> +
> +static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
> +{
> +	ext4_fsblk_t resv_clusters;
> +
> +	/*
> +	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
> +	 * This should cover the situations where we can not afford to run
> +	 * out of space like for example punch hole, or converting
> +	 * uninitialized extents in delalloc path. In most cases such
> +	 * allocation would require 1, or 2 blocks, higher numbers are
> +	 * very rare.
> +	 */
> +	resv_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
> +
> +	do_div(resv_clusters, 50);
> +	resv_clusters = min_t(ext4_fsblk_t, resv_clusters, 4096);
> +
> +	return resv_clusters;
> +}
> +
> +
> +static int ext4_reserve_clusters(struct ext4_sb_info *sbi, ext4_fsblk_t count)
> +{
> +	s64 free_clusters = percpu_counter_sum_positive(
> +				&sbi->s_freeclusters_counter);
> +
> +	if (count >= free_clusters)
> +		return -EINVAL;
> +
> +	atomic64_set(&sbi->s_resv_clusters, count);
> +	return 0;
> +}
> +
>  static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  {
>  	char *orig_data = kstrdup(data, GFP_KERNEL);
> @@ -3907,6 +3976,13 @@ no_journal:
>  			 "available");
>  	}
>  
> +	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sbi));
> +	if (err) {
> +		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
> +			 "reserved pool", ext4_calculate_resv_clusters(sbi));
> +		goto failed_mount4a;
> +	}
> +
>  	err = ext4_setup_system_zone(sb);
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "failed to initialize system "
> @@ -4738,9 +4814,10 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	struct super_block *sb = dentry->d_sb;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_super_block *es = sbi->s_es;
> -	ext4_fsblk_t overhead = 0;
> +	ext4_fsblk_t overhead = 0, resv_blocks;
>  	u64 fsid;
>  	s64 bfree;
> +	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
>  
>  	if (!test_opt(sb, MINIX_DF))
>  		overhead = sbi->s_overhead;
> @@ -4752,8 +4829,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
>  	/* prevent underflow in case that few free space is available */
>  	buf->f_bfree = EXT4_C2B(sbi, max_t(s64, bfree, 0));
> -	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
> -	if (buf->f_bfree < ext4_r_blocks_count(es))
> +	buf->f_bavail = buf->f_bfree -
> +			(ext4_r_blocks_count(es) + resv_blocks);
> +	if (buf->f_bfree < (ext4_r_blocks_count(es) + resv_blocks))
>  		buf->f_bavail = 0;
>  	buf->f_files = le32_to_cpu(es->s_inodes_count);
>  	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
