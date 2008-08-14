From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 5/6 ]Ext4 journal credits reservation fixes
Date: Wed, 13 Aug 2008 18:01:10 -0700
Message-ID: <1218675670.6387.22.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558938.6766.55.camel@mingming-laptop>
	 <20080813094637.GD6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57833 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYHNBBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 21:01:13 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0sdCB006283
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:54:39 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E11C3m139544
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 19:01:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E11B2N016153
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 19:01:12 -0600
In-Reply-To: <20080813094637.GD6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 15:16 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 09:35:38AM -0700, Mingming Cao wrote:
> > Ext4: journal credit fix the delalloc writepages
> >=20
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > Previous delalloc writepages implementation start a new transaction=
 outside
> > a loop call of get_block() to do the block allocation. Due to lack =
of information=20
> > of how many blocks to be allocated, the estimate of the journal cre=
dits is very
> >  Conservative and caused many issues.
> >=20
> > With the reworked delayed allocation, a new transaction is created =
for
> > each get_block(), thus we don't need to guess how many credits for =
the multiple
> > chunk of allocation. Start every transaction with credits for inser=
t a single=20
> > extent is enough. But we still need to consider the journalled mode=
, where
> > it need to account for the number of data blocks.  So we guess max =
number of
> > data blocks for each allocation.
>=20
>=20
> But we don't currently support data=3Djournal with delalloc.
>=20

Ok, I realize that.

But even if we want just a chunk of allocation, we still need to know
how much data blocks to allocate, in order to guess how many credits
need for indirect/index blocks..:(
>=20
> > Due to the current VFS implementation
> > writepages() could only flush PAGEVEC of pages at a time, the max b=
lock
> > allocation is limited and calculated based on that, an the total nu=
mber
> > of reserved delalloc datablocks, whichever is smaller.
>=20
> That is not correct. Currently write_cache_pages do
> while (!done && (index <=3D end) &&
> 		(nr_pages =3D pagevec_lookup_tag(&pvec, mapping, &index,
> 					       PAGECACHE_TAG_DIRTY,
> 					       min(end - index,
> 					      (pgoff_t)PAGEVEC_SIZE-1) + 1)))
> {
>=20
> and mpage_da_submit_io does
> while (index <=3D end) {
> 	/* XXX: optimize tail */
> 	nr_pages =3D pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
>=20
>=20


>=20
> ie we iterate till index > end. So we can very well have more than
> PAGEVEC number of pages in a single transaction.
>=20
Ok, I am glad to see this is not a limit
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/inode.c |   39 ++++++++++++++++++++++++---------------
> >  1 file changed, 24 insertions(+), 15 deletions(-)
> >=20
> > Index: linux-2.6.27-rc1/fs/ext4/inode.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-12 08:15:59.00000=
0000 -0700
> > +++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-12 08:30:41.000000000 =
-0700
> > @@ -2210,17 +2210,28 @@ static int ext4_da_writepage(struct page
> >  }
> >=20
> >  /*
> > - * For now just follow the DIO way to estimate the max credits
> > - * needed to write out EXT4_MAX_WRITEBACK_PAGES.
> > - * todo: need to calculate the max credits need for
> > - * extent based files, currently the DIO credits is based on
> > - * indirect-blocks mapping way.
> > - *
> > - * Probably should have a generic way to calculate credits
> > - * for DIO, writepages, and truncate
> > + * This is called via ext4_da_writepages() to
> > + * calulate the total number of credits to reserve to fit
> > + * a single extent allocation into a single transaction,
> > + * ext4_da_writpeages() will loop calling this before
> > + * the block allocation.
> > + *
> > + * The page vector size limited the max number of pages could
> > + * be writeout at a time. Based on this, the max blocks to pass to
> > + * get_block is calculated
> >   */
> > -#define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> > -#define EXT4_MAX_WRITEBACK_CREDITS    25
> > +
> > +#define		EXT4_MAX_WRITEPAGES_SIZE	PAGEVEC_SIZE
> > +static int ext4_writepages_trans_blocks(struct inode *inode)
> > +{
> > +	int bpp =3D ext4_journal_blocks_per_page(inode);
> > +	int max_blocks =3D EXT4_MAX_WRITEPAGES_SIZE * bpp;
> > +
> > +	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
> > +		max_blocks =3D  EXT4_I(inode)->i_reserved_data_blocks;
>=20
>=20
>=20
> Why are we limiting max_blocks to i_reserved_data_blocks ?
>=20

i_reserved_data_blocks is the total number of "delayed" blocks that nee=
d
block allocation. That's  a counter being adds up at each write_begin()
when the block allocation is defered. That's a accurate counter to
indicate the max number of allocation we need to flush all dirty pages
to disk for this inode,  fits well when we need to calculate the credit=
s
for da_writepages.

Now that we don't have PAGEVEC limit,  we could use this to limit the
total number of blocks to allocate  when estimate the credit.   But if
this i_reserved_data_blocks gets too large, that can't fit into one
single transaction, later get_block() will overflow the journal, we nee=
d
someway to limit the number of pages to flush still:(

>=20
> > +
> > +	return ext4_data_trans_blocks(inode, max_blocks);
> > +}
> >=20
> >  static int ext4_da_writepages(struct address_space *mapping,
> >                                  struct writeback_control *wbc)
> > @@ -2262,7 +2273,7 @@ restart_loop:
> >  		 * by delalloc
> >  		 */
> >  		BUG_ON(ext4_should_journal_data(inode));
> > -		needed_blocks =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > +		needed_blocks =3D ext4_writepages_trans_blocks(inode);
> >=20
>=20
> The BUG_ON above is added to make sure we update this when start
> supporting data=3Djournal mode with delalloc.
>=20
>=20
> >  		/* start a new transaction*/
> >  		handle =3D ext4_journal_start(inode, needed_blocks);
> > @@ -4449,11 +4460,9 @@ static int ext4_writeblocks_trans_credit
> >   * the modification of a single pages into a single transaction,
> >   * which may include multile chunk of block allocations.
> >   *
> > - * This could be called via ext4_write_begin() or later
> > - * ext4_da_writepages() in delalyed allocation case.
> > + * This could be called via ext4_write_begin()
> >   *
> > - * In both case it's possible that we could allocating multiple
> > - * chunks of blocks. We need to consider the worse case, when
> > + * We need to consider the worse case, when
> >   * one new block per extent.
> >   */
> >  int ext4_writepage_trans_blocks(struct inode *inode)
> >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
