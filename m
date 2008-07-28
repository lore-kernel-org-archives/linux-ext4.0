From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Mon, 28 Jul 2008 12:07:33 -0700
Message-ID: <1217272053.6379.7.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217014002.6322.29.camel@mingming-laptop>
	 <20080728161156.GB4545@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39416 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYG1THg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 15:07:36 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6SJ7ZO0024394
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 15:07:35 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6SJ7Zht227128
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 15:07:35 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6SJ7Yqp001049
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 15:07:35 -0400
In-Reply-To: <20080728161156.GB4545@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-28=E4=B8=80=E7=9A=84 21:41 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Fri, Jul 25, 2008 at 12:26:42PM -0700, Mingming Cao wrote:
> >=20
>=20
> ......
>=20
> > > >   */
> > > >  int ext4_ext_calc_credits_for_insert(struct inode *inode,
> > > >  						struct ext4_ext_path *path)
> > > > @@ -1930,9 +1931,6 @@ int ext4_ext_calc_credits_for_insert(str
> > > >  	 */
> > > >  	needed +=3D (depth * 2) + (depth * 2);
> > > >=20
> > > > -	/* any allocation modifies superblock */
> > > > -	needed +=3D 1;
> > > > -
> > >=20
> > >=20
> > > Why are we dropping the super block modification credit ? An inse=
rt of
> > > an extent can result in super block modification also. If the goa=
l is to
> > > use ext4_writepages_trans_blocks everywhere then this change is c=
orrect.
> > > But i see  many place not using ext4_writepages_trans_blocks.
> > >=20
> > ext4_writepages_trans_blocks() will take care of the credits need f=
or
> > updating superblock, for just once.ext4_ext_calc_credits_for_insert=
()
> > calculate the credits needed for inserting a single extent, You cou=
ld
> > see in ext4_writepages_trans_blocks(), it will multiple it will the
> > total numberof blocks. If we account for superblock credit in
> > ext4_ext_calc_credits_for_insert(),  then super block updates for
> > multiple extents allocation will be overaccounted, and have to remo=
ve
> > that later in ext4_writepages_trans_blocks()
>=20
>=20
>=20
> ext4_ext_calc_credit for insert was not doing it currently with=20
> path !=3D NULL.  I attaching a patch which reflect some of the change=
s
> I suggested.
>=20
>=20
Acked. this fixed another bug in existing code.
> >=20
> > Other places calling  ext4_ext_calc_credits_for_insert() (mostly
> > migrate.c and defrag,c) are updated to add extra 4 credits, includi=
ng
> > superblock, inode block and quota blocks.
>=20
>=20
> I guess it should not be +4 but should be +2 + 2 * EXT4_QUOTA_TRANS_B=
LOCKS(inode->i_sb);
>=20

Yes. =20
> >=20
> > > You also need to update the function comment saying that super bl=
ock
> > > update is not accounted.Also it doesn't account for block bitmap,
> > > group descriptor and inode block update.
> > >=20
> >=20
> > Credits for block bitmap and group descriptors are accounted in
> > ext4_ext_calc_credits_for_insert()
> >=20
> > inode block update is only accounted once per writepages, so it's
> > accounted in
> > ext4_writepages_trans_blocks()/ext4_ext_writepages_trans_blocks()
> >=20
>=20
> ....
>=20
> > > >   *
> > > > @@ -1142,13 +1133,13 @@ int ext4_get_block(struct inode *inode,=
=20
> > > >  	handle_t *handle =3D ext4_journal_current_handle();
> > > >  	int ret =3D 0, started =3D 0;
> > > >  	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits=
;
> > > > +	int dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > >=20
> > > Again this should be
> > > 	int dio_credits =3D ext4_writeblocks_trans(inode, DIO_MAX_BLOCKS=
);
> > >=20
> > No. DIO case is different than writepages(). When get_block() is ca=
lled
> > from DIO path, the get_block()  is called in a loop, and the credit=
 is
> > reserved inside the loop. Each time get_block(),will return a singl=
e
> > extent, so we should use   EXT4_DATA_TRANS_BLOCKS(inode->i_sb) whic=
h is
> > calculate a single chunk of allocation credits.
>=20
>=20
> That is true only for extent format. With noextents we need something
> like below
>=20

Not really, even with non extent format block allocation, ext4_get_bloc=
k() will only allocate/map a chunk of contiguous blocks (i.e. an extent=
), so it will not hit the worse case.

> if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> 	dio_credits =3D ext4_writeblocks_trans_credits_old(inode, max_blocks=
);
> else {
> 	/*
> 	 * For extent format get_block return only one extent
> 	 */
> 	dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> }
>=20
>=20

=2E..

>=20
> > >=20
> > > > -	int bpp =3D ext4_journal_blocks_per_page(inode);
> > > > -	int indirects =3D (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> > > > +	int indirects =3D (EXT4_NDIR_BLOCKS % num) ? 5 : 3;
> > > >  	int ret;
> > > >=20
> > > > -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > > > -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> > > > -
> > > >  	if (ext4_should_journal_data(inode))
> > > > -		ret =3D 3 * (bpp + indirects) + 2;
> > > > +		ret =3D 3 * (num + indirects) + 2;
> > > >  	else
> > > > -		ret =3D 2 * (bpp + indirects) + 2;
> > > > +		ret =3D 2 * (num + indirects) + 2;
> > >=20
> > >=20
> > > With non journalled moded we should just decrease num. I guess th=
e above
> > > should be
> > > 	if (ext4_should_journal_data(inode))
> > > 		ret =3D 3 * (num + indirects) + 2;
> > > 	else
> > > 		ret =3D 3 * (num + indirects) + 2 - num;
> > >=20
> > >=20
> > >=20
> >=20
> > Well, I think in the journalled mode we need to journal the content=
 of
> > the indirect/double indirect blocks also, no?
> >=20
>=20
> With non journalled mode we still need to journal the indirect, dindi=
rect
> and tindirect block so this should be
>=20

yes, changes of indirect blocks are also logged in all journalling
mode.=20



Mingming
> Attaching the patch for easy review
>=20
>=20
>=20
> diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
> index 7c819fd..46e9600 100644
> --- a/fs/ext4/defrag.c
> +++ b/fs/ext4/defrag.c
> @@ -1385,8 +1385,9 @@ ext4_defrag_alloc_blocks(handle_t *handle, stru=
ct inode *org_inode,
>  	struct buffer_head *bh =3D NULL;
>  	int err, i, credits =3D 0;
>=20
> -	credits =3D ext4_ext_calc_credits_for_single_extent(dest_inode, des=
t_path)
> -		  + 4;
> +	credits =3D ext4_ext_calc_credits_for_single_extent(dest_inode,
> +			dest_path) + 2 +
> +			2 * EXT4_QUOTA_TRANS_BLOCKS(dest_inode->i_sb);
>  	err =3D ext4_ext_journal_restart(handle,
>  				credits + EXT4_TRANS_META_BLOCKS);
>  	if (err)
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 77f4f94..969b1e6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1898,6 +1898,9 @@ static int ext4_ext_rm_idx(handle_t *handle, st=
ruct inode *inode,
>   * for old tree and new tree, for every level we need to reserve
>   * credits to log the bitmap and block group descriptors
>   *
> + * This doesn't take into account credit needed for the update of
> + * super block + inode block + quota files
> + *
>   */
>  int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
>  						struct ext4_ext_path *path)
> @@ -1909,7 +1912,8 @@ int ext4_ext_calc_credits_for_single_extent(str=
uct inode *inode,
>  		depth =3D ext_depth(inode);
>  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
>  				< le16_to_cpu(path[depth].p_hdr->eh_max))
> -			return 1;
> +			/* 1 group desc + 1 block bitmap for allocated blocks */
> +			return 2;
>  	}
>=20
>  	/*
> @@ -1919,7 +1923,7 @@ int ext4_ext_calc_credits_for_single_extent(str=
uct inode *inode,
>  	 */
>  	depth =3D 5;
>=20
> -	/* allocation of new data block(s) */
> +	/* 1 group desc + 1 block bitmap for allocated blocks */
>  	needed =3D 2;
>=20
>  	/*
> @@ -2059,9 +2063,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode=
 *inode,
>  			correct_index =3D 1;
>  			credits +=3D (ext_depth(inode)) + 1;
>  		}
> -#ifdef CONFIG_QUOTA
>  		credits +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> -#endif
>=20
>  		err =3D ext4_ext_journal_restart(handle, credits);
>  		if (err)
> @@ -3023,9 +3025,7 @@ int  ext4_ext_writeblocks_trans_credits(struct =
inode *inode, int nrblocks)
>  	else
>  		needed =3D nrblocks * needed  + 2;
>=20
> -#ifdef CONFIG_QUOTA
>  	needed +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> -#endif
>=20
>  	return needed;
>  }
> @@ -3092,7 +3092,7 @@ long ext4_fallocate(struct inode *inode, int mo=
de, loff_t offset, loff_t len)
>  	/*
>  	 * credits to insert 1 extent into extent tree
>  	 */
> -	credits =3D  EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> +	credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
>  	mutex_lock(&inode->i_mutex);
>  retry:
>  	while (ret >=3D 0 && ret < max_blocks) {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5a394c8..d2832a1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1126,18 +1126,29 @@ int ext4_get_blocks_wrap(handle_t *handle, st=
ruct inode *inode, sector_t block,
>  	up_write((&EXT4_I(inode)->i_data_sem));
>  	return retval;
>  }
> +static int ext4_writeblocks_trans_credits_old(struct inode *, int);
>  int ext4_get_block(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create)
>  {
>  	handle_t *handle =3D ext4_journal_current_handle();
>  	int ret =3D 0, started =3D 0;
>  	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;
> -	int dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> +	int dio_credits;
>=20
>  	if (create && !handle) {
>  		/* Direct IO write... */
>  		if (max_blocks > DIO_MAX_BLOCKS)
>  			max_blocks =3D DIO_MAX_BLOCKS;
> +		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +			dio_credits =3D ext4_writeblocks_trans_credits_old(inode,
> +							max_blocks);
> +		else {
> +			/*
> +			 * For extent format get_block return only one extent
> +			 */
> +			dio_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> +		}
> +
>  		handle =3D ext4_journal_start(inode, dio_credits);
>  		if (IS_ERR(handle)) {
>  			ret =3D PTR_ERR(handle);
> @@ -4310,14 +4321,18 @@ static int ext4_writeblocks_trans_credits_old=
(struct inode *inode, int nrblocks)
>=20
>  	if (ext4_should_journal_data(inode))
>  		ret =3D 3 * (nrblocks + indirects) + 2;
> -	else
> -		ret =3D 2 * (nrblocks + indirects) + 2;
> +	else {
> +		/*
> +		 * We still need to journal update for the
> +		 * indirect, dindirect, and tindirect blocks
> +		 * only data blocks are not journalled
> +		 */
> +		ret =3D 3 * (nrblocks + indirects) + 2 - nrblocks;
> +	}
>=20
> -#ifdef CONFIG_QUOTA
>  	/* We know that structure was already allocated during DQUOT_INIT s=
o
>  	 * we will be updating only the data blocks + inodes */
> -	ret +=3D 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> -#endif
> +	ret +=3D 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
>=20
>  	return ret;
>  }
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 3456094..72488ab 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -55,7 +55,8 @@ static int finish_range(handle_t *handle, struct in=
ode *inode,
>  	 *
>  	 * extra 4 credits for: 1 superblock, 1 inode block, 2 quotas
>  	 */
> -	needed =3D ext4_ext_calc_credits_for_single_extent(inode, path) + 4=
;
> +	needed =3D ext4_ext_calc_credits_for_single_extent(inode, path) + 2=
 +
> +				2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);;
>=20
>  	/*
>  	 * Make sure the credit we accumalated is not really high
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
