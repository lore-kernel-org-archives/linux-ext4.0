From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 3/6 ]Ext4: journal credits reservation fixes for DIO,
	fallocate
Date: Wed, 13 Aug 2008 17:50:56 -0700
Message-ID: <1218675056.6387.10.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558590.6766.47.camel@mingming-laptop>
	 <20080813085307.GC6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48605 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbYHNAvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 20:51:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0p5T3027732
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:51:05 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E0owgQ230794
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:50:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E0owC0018513
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:50:58 -0400
In-Reply-To: <20080813085307.GC6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 14:23 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A=20
> On Tue, Aug 12, 2008 at 09:29:50AM -0700, Mingming Cao wrote:
> >=20
> ......
> ....
>=20
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Index: linux-2.6.27-rc1/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc1.orig/fs/ext4/extents.c	2008-08-11 22:25:39.000=
000000 -0700
> > +++ linux-2.6.27-rc1/fs/ext4/extents.c	2008-08-11 22:25:55.00000000=
0 -0700
> > @@ -2799,7 +2799,7 @@ void ext4_ext_truncate(struct inode *ino
> >  	/*
> >  	 * probably first extent we're gonna free will be last in block
> >  	 */
> > -	err =3D ext4_writepage_trans_blocks(inode) + 3;
> > +	err =3D ext4_writepage_trans_blocks(inode);
> >  	handle =3D ext4_journal_start(inode, err);
> >  	if (IS_ERR(handle))
> >  		return;
> > @@ -2951,10 +2951,9 @@ long ext4_fallocate(struct inode *inode,
> >  	max_blocks =3D (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbit=
s)
> >  							- block;
> >  	/*
> > -	 * credits to insert 1 extent into extent tree + buffers to be ab=
le to
> > -	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
> > +	 * credits to insert 1 extent into extent tree
> >  	 */
> > -	credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
> > +	credits =3D ext4_data_trans_blocks(inode, max_blocks);
>=20
>=20
> Why do we need to consider data=3Djournaled mode here. We are not wri=
ting
> any data here. Instead we are just inserting an extent.
>=20

Actually the change here is not mean to support data=3Djournalled here.
The ext4_data_trans_blocks() is intended for calculate credits for a
chunk of allocation, used for DIO and fallocate, regardless of delalloc
or not.=20
 We should remove the considering of data journal in the
ext4_data_trans_blocks(), I agree.

Now that I realize the data=3Djournalled code doesn't work for delalloc
(or delalloc da writepages doesn' t support the journalled mode, due to
the lock ordering issue),  I am not sure if there is plan to do so (or
there is need to support journalled mode on delalloc).  We still need t=
o
keep the data=3Djournalled consideration for writepage/write_begin, jus=
t
to help user move from ext3 to ext4 I guess.

>=20
> >  	mutex_lock(&inode->i_mutex);
> >  retry:
> >  	while (ret >=3D 0 && ret < max_blocks) {
> > Index: linux-2.6.27-rc1/fs/ext4/inode.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-11 22:18:31.00000=
0000 -0700
> > +++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-11 22:25:55.000000000 =
-0700
> > @@ -1041,18 +1041,6 @@ static void ext4_da_update_reserve_space
> >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> >  }
> >=20
> > -/* Maximum number of blocks we map for direct IO at once. */
> > -#define DIO_MAX_BLOCKS 4096
> > -/*
> > - * Number of credits we need for writing DIO_MAX_BLOCKS:
> > - * We need sb + group descriptor + bitmap + inode -> 4
> > - * For B blocks with A block pointers per block we need:
> > - * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indire=
ct).
> > - * If we plug in 4096 for B and 256 for A (for 1KB block size), we=
 get 25.
> > - */
> > -#define DIO_CREDITS 25
> > -
> > -
> >  /*
> >   * The ext4_get_blocks_wrap() function try to look up the requeste=
d blocks,
> >   * and returns if the blocks are already mapped.
> > @@ -1164,19 +1152,23 @@ int ext4_get_blocks_wrap(handle_t *handl
> >  	return retval;
> >  }
> >=20
> > +/* Maximum number of blocks we map for direct IO at once. */
> > +#define DIO_MAX_BLOCKS 4096
> > +
> >  static int ext4_get_block(struct inode *inode, sector_t iblock,
> >  			struct buffer_head *bh_result, int create)
> >  {
> >  	handle_t *handle =3D ext4_journal_current_handle();
> >  	int ret =3D 0, started =3D 0;
> >  	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;
> > +	int dio_credits;
> >=20
> >  	if (create && !handle) {
> >  		/* Direct IO write... */
> >  		if (max_blocks > DIO_MAX_BLOCKS)
> >  			max_blocks =3D DIO_MAX_BLOCKS;
> > -		handle =3D ext4_journal_start(inode, DIO_CREDITS +
> > -			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> > +		dio_credits =3D ext4_data_trans_blocks(inode, max_blocks);
> > +		handle =3D ext4_journal_start(inode, dio_credits);
>=20
> Even in data=3Djournal mode directIO will put the buffer_heads to jou=
rnal
> right ? . So should we use ext4_data_trans_blocks here ?
>=20
>=20
>=20
> >  		if (IS_ERR(handle)) {
> >  			ret =3D PTR_ERR(handle);
> >  			goto out;
> > @@ -2222,7 +2214,7 @@ static int ext4_da_writepage(struct page
> >   * for DIO, writepages, and truncate
> >   */
> >  #define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> > -#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
> > +#define EXT4_MAX_WRITEBACK_CREDITS    25
> >=20
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  				struct writeback_control *wbc)
> > @@ -4429,7 +4421,8 @@ static int ext4_writeblocks_trans_credit
> >=20
> >  /*
> >=20
>=20
> ....
> ....
>=20
> -aneesh

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
