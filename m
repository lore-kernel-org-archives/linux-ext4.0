From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 04/11] ext4: Add percpu dirty block accounting.
Date: Thu, 28 Aug 2008 13:56:13 -0700
Message-ID: <1219956973.6384.14.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45753 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522AbYH1U4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 16:56:30 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SKuNr1028948
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:56:23 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SKuGgj232754
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:56:16 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SKuGs2016584
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:56:16 -0400
In-Reply-To: <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to patch queue

=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> This patch add dirty block accounting using percpu_counters.
> Delayed allocation block reservation is now done by updating
> dirty block counter. In the later patch we switch to non
> delalloc mode if the filesystem free blocks is < that
> 150 % of total filesystem  dirty blocks
>=20


Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |   59 +++++++++++++++++++++++++++++++++----------=
---------
>  fs/ext4/ext4_sb.h |    1 +
>  fs/ext4/inode.c   |   22 +++++++++---------
>  fs/ext4/mballoc.c |   17 ++------------
>  fs/ext4/super.c   |    8 ++++++-
>  5 files changed, 59 insertions(+), 48 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 5767332..b19346a 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1605,26 +1605,38 @@ ext4_try_to_allocate_with_rsv(struct super_bl=
ock *sb, handle_t *handle,
>  int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>  						ext4_fsblk_t nblocks)
>  {
> -	s64 free_blocks;
> +	s64 free_blocks, dirty_blocks;
>  	ext4_fsblk_t root_blocks =3D 0;
>  	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
> +	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
>=20
> -	free_blocks =3D percpu_counter_read(fbc);
> +	free_blocks  =3D percpu_counter_read_positive(fbc);
> +	dirty_blocks =3D percpu_counter_read_positive(dbc);
>=20
>  	if (!capable(CAP_SYS_RESOURCE) &&
>  		sbi->s_resuid !=3D current->fsuid &&
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
>  		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>=20
> -	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMA=
RK)
> -		free_blocks =3D percpu_counter_sum(&sbi->s_freeblocks_counter);
> -
> -	if (free_blocks < (root_blocks + nblocks))
> +	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
> +						EXT4_FREEBLOCKS_WATERMARK) {
> +		free_blocks  =3D percpu_counter_sum(fbc);
> +		dirty_blocks =3D percpu_counter_sum(dbc);
> +		if (dirty_blocks < 0) {
> +			printk(KERN_CRIT "Dirty block accounting "
> +					"went wrong %lld\n",
> +					dirty_blocks);
> +		}
> +	}
> +	/* Check whether we have space after
> +	 * accounting for current dirty blocks
> +	 */
> +	if (free_blocks < ((s64)(root_blocks + nblocks) + dirty_blocks))
>  		/* we don't have free space */
>  		return -ENOSPC;
>=20
> -	/* reduce fs free blocks counter */
> -	percpu_counter_sub(fbc, nblocks);
> +	/* Add the blocks to nblocks */
> +	percpu_counter_add(dbc, nblocks);
>  	return 0;
>  }
>=20
> @@ -1640,23 +1652,28 @@ int ext4_claim_free_blocks(struct ext4_sb_inf=
o *sbi,
>  ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  						ext4_fsblk_t nblocks)
>  {
> -	ext4_fsblk_t free_blocks;
> +	ext4_fsblk_t free_blocks, dirty_blocks;
>  	ext4_fsblk_t root_blocks =3D 0;
> +	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
> +	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
>=20
> -	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks_cou=
nter);
> +	free_blocks  =3D percpu_counter_read_positive(fbc);
> +	dirty_blocks =3D percpu_counter_read_positive(dbc);
>=20
>  	if (!capable(CAP_SYS_RESOURCE) &&
>  		sbi->s_resuid !=3D current->fsuid &&
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
>  		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>=20
> -	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMA=
RK)
> -		free_blocks =3D percpu_counter_sum_positive(&sbi->s_freeblocks_cou=
nter);
> -
> -	if (free_blocks <=3D root_blocks)
> +	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
> +						EXT4_FREEBLOCKS_WATERMARK) {
> +		free_blocks  =3D percpu_counter_sum_positive(fbc);
> +		dirty_blocks =3D percpu_counter_sum_positive(dbc);
> +	}
> +	if (free_blocks <=3D (root_blocks + dirty_blocks))
>  		/* we don't have free space */
>  		return 0;
> -	if (free_blocks - root_blocks < nblocks)
> +	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
>  		return free_blocks - root_blocks;
>  	return nblocks;
>  }
> @@ -1943,13 +1960,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
ndle, struct inode *inode,
>  	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
>  	gdp->bg_checksum =3D ext4_group_desc_csum(sbi, group_no, gdp);
>  	spin_unlock(sb_bgl_lock(sbi, group_no));
> -	if (!EXT4_I(inode)->i_delalloc_reserved_flag && (*count !=3D num)) =
{
> -		/*
> -		 * we allocated less blocks than we
> -		 * claimed. Add the difference back.
> -		 */
> -		percpu_counter_add(&sbi->s_freeblocks_counter, *count - num);
> -	}
> +	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
> +	/*
> +	 * Now reduce the dirty block count also. Should not go negative
> +	 */
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, num);
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group =3D ext4_flex_group(sbi, group_no);
>  		spin_lock(sb_bgl_lock(sbi, flex_group));
> diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
> index 6300226..0fa3762 100644
> --- a/fs/ext4/ext4_sb.h
> +++ b/fs/ext4/ext4_sb.h
> @@ -59,6 +59,7 @@ struct ext4_sb_info {
>  	struct percpu_counter s_freeblocks_counter;
>  	struct percpu_counter s_freeinodes_counter;
>  	struct percpu_counter s_dirs_counter;
> +	struct percpu_counter s_dirtyblocks_counter;
>  	struct blockgroup_lock s_blockgroup_lock;
>=20
>  	/* root of the per fs reservation window tree */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 98a998b..14ec7d1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1030,19 +1030,20 @@ static void ext4_da_update_reserve_space(stru=
ct inode *inode, int used)
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks - mdb;
>=20
> -	/* Account for allocated meta_blocks */
> -	mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
> -
> -	/* update fs free blocks counter for truncate case */
> -	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
> +	if (mdb_free) {
> +		/* Account for allocated meta_blocks */
> +		mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
> +
> +		/* update fs dirty blocks counter */
> +		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> +		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> +		EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> +	}
>=20
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
>  	EXT4_I(inode)->i_reserved_data_blocks -=3D used;
>=20
> -	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> -	EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
>=20
> @@ -1588,8 +1589,8 @@ static void ext4_da_release_space(struct inode =
*inode, int to_free)
>=20
>  	release =3D to_free + mdb_free;
>=20
> -	/* update fs free blocks counter for truncate case */
> -	percpu_counter_add(&sbi->s_freeblocks_counter, release);
> +	/* update fs dirty blocks counter for truncate case */
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
>=20
>  	/* update per-inode reservations */
>  	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
> @@ -2471,7 +2472,6 @@ static int ext4_da_write_begin(struct file *fil=
e, struct address_space *mapping,
>  	index =3D pos >> PAGE_CACHE_SHIFT;
>  	from =3D pos & (PAGE_CACHE_SIZE - 1);
>  	to =3D from + len;
> -
>  retry:
>  	/*
>  	 * With delayed allocation, we don't log the i_disksize update
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 419009f..4da4b9a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2971,22 +2971,11 @@ ext4_mb_mark_diskspace_used(struct ext4_alloc=
ation_context *ac,
>  	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
>  	gdp->bg_checksum =3D ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group=
, gdp);
>  	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
> -
> +	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
>  	/*
> -	 * free blocks account has already be reduced/reserved
> -	 * at write_begin() time for delayed allocation
> -	 * do not double accounting
> +	 * Now reduce the dirty block count also. Should not go negative
>  	 */
> -	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
> -			ac->ac_o_ex.fe_len !=3D ac->ac_b_ex.fe_len) {
> -		/*
> -		 * we allocated less blocks than we calimed
> -		 * Add the difference back
> -		 */
> -		percpu_counter_add(&sbi->s_freeblocks_counter,
> -				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
> -	}
> -
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len)=
;
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group =3D ext4_flex_group(sbi,
>  							  ac->ac_b_ex.fe_group);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ed77786..7b9db51 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -520,6 +520,7 @@ static void ext4_put_super(struct super_block *sb=
)
>  	percpu_counter_destroy(&sbi->s_freeblocks_counter);
>  	percpu_counter_destroy(&sbi->s_freeinodes_counter);
>  	percpu_counter_destroy(&sbi->s_dirs_counter);
> +	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
>  	brelse(sbi->s_sbh);
>  #ifdef CONFIG_QUOTA
>  	for (i =3D 0; i < MAXQUOTAS; i++)
> @@ -2259,6 +2260,9 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
>  		err =3D percpu_counter_init(&sbi->s_dirs_counter,
>  				ext4_count_dirs(sb));
>  	}
> +	if (!err) {
> +		err =3D percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
> +	}
>  	if (err) {
>  		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
>  		goto failed_mount3;
> @@ -2491,6 +2495,7 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
>  	percpu_counter_destroy(&sbi->s_freeblocks_counter);
>  	percpu_counter_destroy(&sbi->s_freeinodes_counter);
>  	percpu_counter_destroy(&sbi->s_dirs_counter);
> +	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
>  failed_mount2:
>  	for (i =3D 0; i < db_count; i++)
>  		brelse(sbi->s_group_desc[i]);
> @@ -3164,7 +3169,8 @@ static int ext4_statfs(struct dentry *dentry, s=
truct kstatfs *buf)
>  	buf->f_type =3D EXT4_SUPER_MAGIC;
>  	buf->f_bsize =3D sb->s_blocksize;
>  	buf->f_blocks =3D ext4_blocks_count(es) - sbi->s_overhead_last;
> -	buf->f_bfree =3D percpu_counter_sum_positive(&sbi->s_freeblocks_cou=
nter);
> +	buf->f_bfree =3D percpu_counter_sum_positive(&sbi->s_freeblocks_cou=
nter) -
> +		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
>  	ext4_free_blocks_count_set(es, buf->f_bfree);
>  	buf->f_bavail =3D buf->f_bfree - ext4_r_blocks_count(es);
>  	if (buf->f_bfree < ext4_r_blocks_count(es))

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
