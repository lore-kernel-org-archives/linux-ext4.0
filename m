From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Thu, 14 Aug 2008 15:16:05 -0700
Message-ID: <1218752165.6362.18.camel@mingming-laptop>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44345 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYHNWQJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Aug 2008 18:16:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7EMG7oW024750
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:16:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7EMG7kT186410
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:16:07 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7EMG6g8020339
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:16:07 -0400
In-Reply-To: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-14=E5=9B=9B=E7=9A=84 23:14 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> mballoc small file block allocation use per cpu prealloc
> space. Use goal block when searching for the right prealloc
> space. Also make sure ext4_da_writepages tries to write
> all the pages for small files in single attempt
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c   |   21 +++++++++++++++------
>  fs/ext4/mballoc.c |   44 +++++++++++++++++++++++++++++++++++++------=
-
>  fs/inode.c        |    1 +
>  3 files changed, 53 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e144896..0b34998 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2318,13 +2318,12 @@ static int ext4_writepages_trans_blocks(struc=
t inode *inode)
>  static int ext4_da_writepages(struct address_space *mapping,
>                                  struct writeback_control *wbc)
>  {
> -	struct inode *inode =3D mapping->host;
>  	handle_t *handle =3D NULL;
> -	int needed_blocks;
> -	int ret =3D 0;
> -	long to_write;
>  	loff_t range_start =3D 0;
> -	long pages_skipped =3D 0;
> +	struct inode *inode =3D mapping->host;
> +	int needed_blocks, ret =3D 0, nr_to_writebump =3D 0;
> +	long to_write, pages_skipped =3D 0;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(mapping->host->i_sb);
>=20
>  	/*
>  	 * No pages to write? This is mainly a kludge to avoid starting
> @@ -2333,6 +2332,16 @@ static int ext4_da_writepages(struct address_s=
pace *mapping,
>  	 */
>  	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIR=
TY))
>  		return 0;
> +	/*
> +	 * Make sure nr_to_write is >=3D sbi->s_mb_stream_request
> +	 * This make sure small files blocks are allocated in
> +	 * single attempt. This ensure that small files
> +	 * get less fragmented.
> +	 */
> +	if (wbc->nr_to_write < sbi->s_mb_stream_request) {
> +		nr_to_writebump =3D sbi->s_mb_stream_request - wbc->nr_to_write;
> +		wbc->nr_to_write =3D sbi->s_mb_stream_request;
> +	}
>=20

do_writepages() could be called with wbc with a specified range, is it
okay  forces da writepages to flush at last 16
pages(sbi->s_mb_stream_request) all the time, which is more than what
the caller asked for?

I assume you trying to address the fragmentation issue with small
request for da_writepages() discussed in previous email? (A little more
description will be helpful here:))

>  	if (!wbc->range_cyclic)
>  		/*
> @@ -2413,7 +2422,7 @@ static int ext4_da_writepages(struct address_sp=
ace *mapping,
>  	}
>=20
>  out_writepages:
> -	wbc->nr_to_write =3D to_write;
> +	wbc->nr_to_write =3D to_write - nr_to_writebump;
>  	wbc->range_start =3D range_start;
>  	return ret;
>  }
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b14a7c7..1afcb11 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3286,6 +3286,29 @@ static void ext4_mb_use_group_pa(struct ext4_a=
llocation_context *ac,
>  	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa=
);
>  }
>=20
> +static struct ext4_prealloc_space *
> +ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
> +			struct ext4_prealloc_space *pa,
> +			struct ext4_prealloc_space *cpa)
> +{
> +	ext4_fsblk_t cur_distance, new_distance;
> +
> +	if (cpa =3D=3D NULL) {
> +		atomic_inc(&pa->pa_count);
> +		return pa;
> +	}
> +	cur_distance =3D abs(goal_block - cpa->pa_pstart);
> +	new_distance =3D abs(goal_block - pa->pa_pstart);
> +
> +	if (cur_distance < new_distance)
> +		return cpa;
> +
> +	/* drop the previous reference */
> +	atomic_dec(&cpa->pa_count);
> +	atomic_inc(&pa->pa_count);
> +	return pa;
> +}
> +
>  /*
>   * search goal blocks in preallocated space
>   */
> @@ -3295,7 +3318,8 @@ ext4_mb_use_preallocated(struct ext4_allocation=
_context *ac)
>  	int order, i;
>  	struct ext4_inode_info *ei =3D EXT4_I(ac->ac_inode);
>  	struct ext4_locality_group *lg;
> -	struct ext4_prealloc_space *pa;
> +	struct ext4_prealloc_space *pa, *cpa =3D NULL;
> +	ext4_fsblk_t goal_block;
>=20
>  	/* only data can be preallocated */
>  	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
> @@ -3338,6 +3362,10 @@ ext4_mb_use_preallocated(struct ext4_allocatio=
n_context *ac)
>  		/* The max size of hash table is PREALLOC_TB_SIZE */
>  		order =3D PREALLOC_TB_SIZE - 1;
>=20
> +	goal_block =3D ac->ac_g_ex.fe_group * EXT4_BLOCKS_PER_GROUP(ac->ac_=
sb) +
> +			ac->ac_g_ex.fe_start +
> +			le32_to_cpu(EXT4_SB(ac->ac_sb)->s_es->s_first_data_block);
> +
>  	for (i =3D order; i < PREALLOC_TB_SIZE; i++) {
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[i],
> @@ -3345,17 +3373,19 @@ ext4_mb_use_preallocated(struct ext4_allocati=
on_context *ac)
>  			spin_lock(&pa->pa_lock);
>  			if (pa->pa_deleted =3D=3D 0 &&
>  					pa->pa_free >=3D ac->ac_o_ex.fe_len) {
> -				atomic_inc(&pa->pa_count);
> -				ext4_mb_use_group_pa(ac, pa);
> -				spin_unlock(&pa->pa_lock);
> -				ac->ac_criteria =3D 20;
> -				rcu_read_unlock();
> -				return 1;
> +
> +				cpa =3D ext4_mb_check_group_pa(goal_block,
> +								pa, cpa);
>  			}

cpa is initalized as NULL, and I could not see where we set cpa any
pointer before calling ext4_mb_check_group_pa().   If I understand
right, the code above passes a  NULL pointer to
ext4_mb_check_group_pa(), which will result in just choose the pa
pointer directly,  and bypass the distance calculation guided by the
goal block.  Did I miss anything?

>  			spin_unlock(&pa->pa_lock);
>  		}
>  		rcu_read_unlock();
>  	}
> +	if (cpa) {
> +		ext4_mb_use_group_pa(ac, cpa);
> +		ac->ac_criteria =3D 20;
> +		return 1;
> +	}
>  	return 0;
>  }
>=20
> diff --git a/fs/inode.c b/fs/inode.c
> index b6726f6..d77f0ee 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -163,6 +163,7 @@ static struct inode *alloc_inode(struct super_blo=
ck *sb)
>  		mapping->a_ops =3D &empty_aops;
>   		mapping->host =3D inode;
>  		mapping->flags =3D 0;
> +		mapping->writeback_index =3D 0;
>  		mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
>  		mapping->assoc_mapping =3D NULL;
>  		mapping->backing_dev_info =3D &default_backing_dev_info;

Could you explain what's this change for?

Regards,
Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
