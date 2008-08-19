From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Code cleanups
Date: Tue, 19 Aug 2008 11:29:18 -0700
Message-ID: <1219170558.6416.4.camel@mingming-laptop>
References: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219128494-10402-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50215 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYHSS3h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 14:29:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7JITWqm016856
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:29:32 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7JITKHg238864
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:29:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7JITJEK001673
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:29:20 -0400
In-Reply-To: <1219128494-10402-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-19=E4=BA=8C=E7=9A=84 12:18 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> a) rename num to nrblocks to clearly indicate we expecting block coun=
t as argument.
> b) renmae ext4_writepages_trans_blocks to ext4_da_writepages_trans_bl=
ocks to
> indicate it is the delayed allocation writepages transaction credit.
> c) Add some comments. remove some stale comments.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Acked-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/extents.c |    8 ++++----
>  fs/ext4/inode.c   |   14 ++++++++------
>  2 files changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 73bb308..bf612a7 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1893,7 +1893,7 @@ static int ext4_ext_rm_idx(handle_t *handle, st=
ruct inode *inode,
>   * When pass the actual path, the caller should calculate credits
>   * under i_data_sem.
>   */
> -int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int=
 num,
> +int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int=
 nrblocks,
>  						struct ext4_ext_path *path)
>  {
>  	if (path) {
> @@ -1912,12 +1912,12 @@ int ext4_ext_calc_credits_for_single_extent(s=
truct inode *inode, int num,
>  			 *  and other metadat blocks still need to be
>  			 *  accounted.
>  			 */
> -			/* 1 one bitmap, 1 block group descriptor */
> +			/* 1 bitmap, 1 block group descriptor */
>  			ret =3D 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
>  		}
>  	}
>=20
> -	return ext4_chunk_trans_blocks(inode, num);
> +	return ext4_chunk_trans_blocks(inode, nrblocks);
>  }
>=20
>  /*
> @@ -1931,7 +1931,7 @@ int ext4_ext_calc_credits_for_single_extent(str=
uct inode *inode, int num,
>   * If the nrblocks are discontiguous, they could cause
>   * the whole tree split more than once, but this is really rare.
>   */
> -int ext4_ext_index_trans_blocks(struct inode *inode, int num, int ch=
unk)
> +int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks, i=
nt chunk)
>  {
>  	int index;
>  	int depth =3D ext_depth(inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a10f8e5..b32a723 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2321,16 +2321,18 @@ static int ext4_da_writepage(struct page *pag=
e,
>   * a single extent allocation into a single transaction,
>   * ext4_da_writpeages() will loop calling this before
>   * the block allocation.
> - *
> - * The page vector size limited the max number of pages could
> - * be writeout at a time. Based on this, the max blocks to pass to
> - * get_block is calculated
>   */
>=20
> -static int ext4_writepages_trans_blocks(struct inode *inode)
> +static int ext4_da_writepages_trans_blocks(struct inode *inode)
>  {
>  	int max_blocks =3D EXT4_I(inode)->i_reserved_data_blocks;
>=20
> +	/*
> +	 * With noextent format the journal credit needed to
> +	 * insert nrblocks contiguous block is dependent on
> +	 * number of contiguous block. So we will limit
> +	 * number of contiguous block to a sane value
> +	 */
>  	if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
>  	    (max_blocks > EXT4_MAX_TRANS_DATA))
>  		max_blocks =3D EXT4_MAX_TRANS_DATA;
> @@ -2387,7 +2389,7 @@ static int ext4_da_writepages(struct address_sp=
ace *mapping,
>  		 * by delalloc
>  		 */
>  		BUG_ON(ext4_should_journal_data(inode));
> -		needed_blocks =3D ext4_writepages_trans_blocks(inode);
> +		needed_blocks =3D ext4_da_writepages_trans_blocks(inode);
>=20
>  		/* start a new transaction*/
>  		handle =3D ext4_journal_start(inode, needed_blocks);

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
