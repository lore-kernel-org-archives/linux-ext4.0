From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 20:45:23 +0530
Message-ID: <20080821151523.GC6509@skywalker>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu> <20080820182741.GA6417@skywalker> <1219268135.7895.30.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:53335 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYHUPP7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 11:15:59 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7LFF7am020591
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:15:07 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LFFvcR245572
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:15:57 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LFFvOA032291
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:15:57 +1000
Content-Disposition: inline
In-Reply-To: <1219268135.7895.30.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 02:35:35PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 23:57 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > On Wed, Aug 20, 2008 at 07:53:31AM -0400, Theodore Tso wrote:
> > > On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > > > mpage_da_map_blocks block allocation failed for inode 323784 =
at logical
> > > > > offset 313 with max blocks 11 with error -28
> > > > > This should not happen.!! Data will be lost
> > >=20
> > > We don't actually lose the data if free blocks are subsequently m=
ade
> > > available, correct?
> > >=20
> > > > I tried this patch. There are still multiple ways we can get wr=
ong free
> > > > block count. The patch reduced the number of errors. So we are =
doing
> > > > better with patch. But I guess we can't use the percpu_counter =
based
> > > > free block accounting with delalloc. Without delalloc it is ok =
even if
> > > > we find some wrong free blocks count . The actual block allocat=
ion will fail in
> > > > that case and we handle it perfectly fine. With delalloc we can=
not
> > > > afford to fail the block allocation. Should we look at a free b=
lock
> > > > accounting rewrite using simple ext4_fsblk_t and and a spin loc=
k ?
> > >=20
> > > It would be a shame if we did given that the whole point of the p=
ercpu
> > > counter was to avoid a scalability bottleneck.  Perhaps we could =
take
> > > a filesystem-level spinlock only when the number of free blocks a=
s
> > > reported by the percpu_counter falls below some critical level?
> > >=20
> > > > --- a/fs/ext4/inode.c
> > > > +++ b/fs/ext4/inode.c
> > > > @@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct =
inode *inode, int nrblocks)
> > > >  	}
> > > >  	/* reduce fs free blocks counter */
> > > >  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> > > > -
> > > > +	/*
> > > > +	 * Now check whether the block count has gone negative.
> > > > +	 * Some other CPU could have reserved blocks in between
> > > > +	 */
> > > > +	if (percpu_counter_read(&sbi->s_freeblocks_counter) < 0) {
> > > > +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > > > +		return -ENOSPC;
> > > > +	}
> > >=20
> > >=20
> > > I think you want to do the check before calling percpu_counter_su=
b();
> > > otherwise when you return ENOSPC the free blocks counter ends up
> > > getting reduced (and gets left negative).
> > >=20
> > > Also, this is one of the places where it might help if we did
> > > something like:
> > >=20
> > > 	freeblocks =3D percpu_counter_read(&sbi->s_freeblocks_counter);
> > > 	if (freeblocks < NR_CPUS*4)
> > > 		freeblocks =3D percpu_counter_sum(&sbi->s_freeblocks_counter);
> > >=20
> > > 	if (freeblocks < total) {
> > > 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > > 		return -ENOSPC;
> > > 	}
> > >=20
> > > BTW, I was looking at the percpu_counter interface, and I'm confu=
sed
> > > why we have percpu_counter_sum_and_set() and percpu_counter_sum()=
=2E  If
> > > we're taking the fbc->lock to calculate the precise value of the
> > > counter, why not simply set fbc->count? =20
> > >=20
> > > Also, it is singularly unfortunate that certain interfaces, such =
as
> > > percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
> > > definitely post-2.6.27, but it seems to me that we probably want
> > > something like percpu_counter_compare_lt() which does something l=
ike this:
> > >=20
> > > static inline int percpu_counter_compare_lt(struct percpu_counter=
 *fbc,
> > > 					    s64 amount)
> > > {
> > > #ifdef CONFIG_SMP
> > > 	if ((fbc->count - amount) < FBC_BATCH)
> > > 		percpu_counter_sum_and_set(fbc);
> > > #endif
> > > 	return 	(fbc->count < amount);
> > > }
> > >=20
> > > ... which we would then use in ext4_has_free_blocks() and
> > > ext4_da_reserve_space().
> > >=20
> >=20
> > Let's say FBC_BATCH =3D 64 and fbc->count =3D 100 and we have four =
cpus and
> > each cpu request for 30 blocks. each CPU does
> >=20
>=20
> But, ext4_da_reserve_space() is called at the prepare_write/write_beg=
in
> time for each page to write, so at most per cpu would request 1 block=
 at
> a time, it is not possible to request reserve 30 blocks at a time.
>=20
> > in ext4_has_free_blocks:
> > free_blocks - nblocks =3D 100 - 30 =3D 70 and is > FBC_BATCH So we =
don't do
>=20
> free_blocks is not necessary 100,=20
>=20
> free_blocks is percpu_counter_read_positive(), which reads the local =
cpu
> counter. In your example, if the global counter is 100, but the local
> cpu counter is 0, then you will get free_blocks =3D 0 here.  nblocks =
=3D 1,
> then you will get
>=20
> free_blocks - nblocks =3D 0-1 =3D-1, which will call
> percpu_counter_sum_and_set() to get more accurate value.
>=20
> > percpu_counter_sum_and_set
> > That means ext4_has_free_blocks return success
> >=20
> > Now while claiming blocks we do
> > __percpu_counter_add(fbc, 30, 64)
> >=20
> > here  30  < 64. That means we don't do fbc->count +=3D count.
> > so fbc->count remains as 100 and we have 4  cpu successfully
> > allocating 30 blocks which means we have to satisfy 120 blocks.
> >=20
>=20
> The situation you described here could happen, but really rare and
> should happen at the case fs is really full. The total number of glob=
al
> free blocks have to be less than  total number of CPU, and there are
> multiple threads write/allocate on each cpu.
>=20

Current code also get it wrong with a parallel directIO and fallocate.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
