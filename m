From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 11:06:08 -0700
Message-ID: <1219341968.6342.25.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080821164531.GE6509@skywalker>
	 <1219338457.6342.15.camel@mingming-laptop>
	 <20080821173121.GF6509@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:46028 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbYHUSGT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 14:06:19 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7LI6Igs008606
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 14:06:18 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LI6A9S134052
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 12:06:11 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LI68HV026080
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 12:06:09 -0600
In-Reply-To: <20080821173121.GF6509@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-21=E5=9B=9B=E7=9A=84 23:01 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Thu, Aug 21, 2008 at 10:07:37AM -0700, Mingming Cao wrote:
> >=20
> > =E5=9C=A8 2008-08-21=E5=9B=9B=E7=9A=84 22:15 +0530=EF=BC=8CAneesh K=
umar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > > On Wed, Aug 20, 2008 at 11:13:39AM +0530, Aneesh Kumar K.V wrote:
> > > > Hi,
> > > >=20
> > > > I am getting this even with the latest patch queue. The test pr=
ogram is
> > > > a modified fsstress with fallocate support.
> > > >=20
> > > > mpage_da_map_blocks block allocation failed for inode 377954 at=
 logical
> > > > offset 313 with max blocks 4 with error -28
> > > > mpage_da_map_blocks block allocation failed for inode 336367 at=
 logical
> > > > offset 74 with max blocks 9 with error -28
> > > > mpage_da_map_blocks block allocation failed for inode 345560 at=
 logical
> > > > offset 542 with max blocks 7 with error -28
> > > > This should not happen.!! Data will be lost
> > > > mpage_da_map_blocks block allocation failed for inode 355317 at=
 logical
> > > > offset 152 with max blocks 10 with error -28
> > > > This should not happen.!! Data will be lost
> > > > mpage_da_map_blocks block allocation failed for inode 395261 at=
 logical
> > > > offset 462 with max blocks 1 with error -28
> > > > This should not happen.!! Data will be lost
> > > > mpage_da_map_blocks block allocation failed for inode 323784 at=
 logical
> > > > offset 313 with max blocks 11 with error -28
> > > > This should not happen.!! Data will be lost
> > > >=20
> > >=20
> > > With this patch i am not seeing error. It does the below
> > >=20
> > > a) use ext4_claim_free_blocks that also update the free blocks co=
unt
> > > b) Later after block allocation update the free blocks count if w=
e
> > > allocated less with non-delayed mode
> > > c) Switch to non delay mode if we are low on free blocks.=20
> > >=20
> > I had sent a patch to do c) yesterday, I noticed that we can't swit=
ch to
> > non delayed mode if the inode already have some delalloc dirty page=
s.
> >=20
> >=20
> > > @@ -2462,11 +2464,21 @@ static int ext4_da_write_begin(struct fil=
e *file, struct address_space *mapping,
> > >  	unsigned from, to;
> > >  	struct inode *inode =3D mapping->host;
> > >  	handle_t *handle;
> > > +	s64 free_blocks;
> > > +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> > >=20
> > >  	index =3D pos >> PAGE_CACHE_SHIFT;
> > >  	from =3D pos & (PAGE_CACHE_SIZE - 1);
> > >  	to =3D from + len;
> > >=20
> > > +	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks=
_counter);
> > > +	if (free_blocks < (4 * (FBC_BATCH * nr_cpu_ids))) {
> > > +		/* switch to non delalloc mode */
> > > +		*fsdata =3D (void *)1;
> > > +		return ext4_write_begin(file, mapping, pos,
> > > +					len, flags, pagep, fsdata);
> > > +	}
> > > +	*fsdata =3D (void *)0;
> >=20
> > No, calling ext4_write_begin() directly won't work, as it start a
> > handle, do the block allocation , and leave the handle there.   It
> > expect later the write_end aops  to file the inode to the transacti=
on
> > list, and close that handle.=20
> >=20
> > With your change, the aops write_end still points to the
> > ext4_da_write_end(), which doesn't match the ext4_write_begin. We n=
eed
> > to switch the aop write_begin/write_end  function pointers all toge=
ther.
> >=20
>=20
> My patch does it in a simple way. I am attaching only switch to non
> delalloc patch below. It is still being tested.
>=20

=46or the people on the mailing list, after chatted with Aneesh on IRC =
I
realize how it is handle it now:)  He passed a special flag to
da_write_end() to indicating fall back to normal write_end() in the cas=
e
the ext4_da_write_begin() falls back to normal write_begin.  It's not
very obvious so I missed it in the first place.

Mingming
> commit 490b69bd47b9ea27b1bb86bbdfb85a2911047149
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Thu Aug 21 22:10:50 2008 +0530
>=20
>     switch to non-delalloc
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d965a05..087abca 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1030,11 +1030,17 @@ static void ext4_da_update_reserve_space(stru=
ct inode *inode, int used)
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks - mdb;
>=20
> -	/* Account for allocated meta_blocks */
> -	mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
> +	if (mdb_free) {
> +		/* Account for allocated meta_blocks */
> +		mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
>=20
> -	/* update fs free blocks counter for truncate case */
> -	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
> +		/*
> +		 * We have reserved more blocks.
> +		 * Now free the extra blocks reserved
> +		 */
> +		percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
> +		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> +	}
>=20
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
> @@ -1042,7 +1048,6 @@ static void ext4_da_update_reserve_space(struct=
 inode *inode, int used)
>=20
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> -	EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
>=20
> @@ -2459,11 +2464,21 @@ static int ext4_da_write_begin(struct file *f=
ile, struct address_space *mapping,
>  	unsigned from, to;
>  	struct inode *inode =3D mapping->host;
>  	handle_t *handle;
> +	s64 free_blocks;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>=20
>  	index =3D pos >> PAGE_CACHE_SHIFT;
>  	from =3D pos & (PAGE_CACHE_SIZE - 1);
>  	to =3D from + len;
>=20
> +	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks_cou=
nter);
> +	if (free_blocks < (4 * (FBC_BATCH * nr_cpu_ids))) {
> +		/* switch to non delalloc mode */
> +		*fsdata =3D (void *)1;
> +		return ext4_write_begin(file, mapping, pos,
> +					len, flags, pagep, fsdata);
> +	}
> +	*fsdata =3D (void *)0;
>  retry:
>  	/*
>  	 * With delayed allocation, we don't log the i_disksize update
> @@ -2532,6 +2547,19 @@ static int ext4_da_write_end(struct file *file=
,
>  	handle_t *handle =3D ext4_journal_current_handle();
>  	loff_t new_i_size;
>  	unsigned long start, end;
> +	int low_free_blocks =3D (int)fsdata;
> +
> +	if (low_free_blocks) {
> +		if (ext4_should_order_data(inode)) {
> +			return ext4_ordered_write_end(file, mapping, pos,
> +					len, copied, page, fsdata);
> +		} else if (ext4_should_writeback_data(inode)) {
> +			return ext4_writeback_write_end(file, mapping, pos,
> +					len, copied, page, fsdata);
> +		} else {
> +			BUG();
> +		}
> +	}
>=20
>  	start =3D pos & (PAGE_CACHE_SIZE - 1);
>  	end =3D start + copied -1;
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
