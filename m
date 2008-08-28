From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 08/11] ext4: Signed arithematic fix
Date: Thu, 28 Aug 2008 14:04:11 -0700
Message-ID: <1219957451.6384.28.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52626 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbYH1VEO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 17:04:14 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SL4BxT026328
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:04:11 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SL4B8Z230676
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:04:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SL4BE6016263
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:04:11 -0400
In-Reply-To: <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> This patch converts some usage of ext4_fsblk_t to s64
> This is needed so that some of the sign conversion works
> as expected in if loops.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Added to patch queue
> ---
>  fs/ext4/balloc.c |   19 ++++++++++---------
>  fs/ext4/ext4.h   |    4 ++--
>  2 files changed, 12 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 53fdb05..7fdc236 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1603,10 +1603,10 @@ ext4_try_to_allocate_with_rsv(struct super_bl=
ock *sb, handle_t *handle,
>  }
>=20
>  int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> -						ext4_fsblk_t nblocks)
> +						s64 nblocks)
>  {
>  	s64 free_blocks, dirty_blocks;
> -	ext4_fsblk_t root_blocks =3D 0;
> +	s64 root_blocks =3D 0;
>  	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
>  	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
>=20
> @@ -1631,7 +1631,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info =
*sbi,
>  	/* Check whether we have space after
>  	 * accounting for current dirty blocks
>  	 */
> -	if (free_blocks < ((s64)(root_blocks + nblocks) + dirty_blocks))
> +	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
>  		/* we don't have free space */
>  		return -ENOSPC;
>=20
> @@ -1650,10 +1650,10 @@ int ext4_claim_free_blocks(struct ext4_sb_inf=
o *sbi,
>   * On success, return nblocks
>   */
>  ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
> -						ext4_fsblk_t nblocks)
> +						s64 nblocks)
>  {
> -	ext4_fsblk_t free_blocks, dirty_blocks;
> -	ext4_fsblk_t root_blocks =3D 0;
> +	s64 free_blocks, dirty_blocks;
> +	s64 root_blocks =3D 0;
>  	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
>  	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
>=20
> @@ -1667,14 +1667,15 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4=
_sb_info *sbi,
>=20
>  	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
>  						EXT4_FREEBLOCKS_WATERMARK) {
> -		free_blocks  =3D percpu_counter_sum_positive(fbc);
> -		dirty_blocks =3D percpu_counter_sum_positive(dbc);
> +		free_blocks  =3D percpu_counter_sum(fbc);
> +		dirty_blocks =3D percpu_counter_sum(dbc);
>  	}
>  	if (free_blocks <=3D (root_blocks + dirty_blocks))
>  		/* we don't have free space */
>  		return 0;
> +
>  	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
> -		return free_blocks - root_blocks;
> +		return free_blocks - (root_blocks + dirty_blocks);
>  	return nblocks;
>  }
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 71a4fde..13c69ed 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1048,9 +1048,9 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *h=
andle, struct inode *inode,
>  extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct ino=
de *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
>  extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> -						ext4_fsblk_t nblocks);
> +						s64 nblocks);
>  extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
> -						ext4_fsblk_t nblocks);
> +						s64  nblocks);
>  extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t block, unsigned long count, int metadata);
>  extern void ext4_free_blocks_sb (handle_t *handle, struct super_bloc=
k *sb,

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
