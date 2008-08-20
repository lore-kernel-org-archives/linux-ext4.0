From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 13:56:48 -0700
Message-ID: <1219265808.7895.14.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker>  <20080820115331.GA9965@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35664 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYHTU4u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 16:56:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KKo1qL000722
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 16:50:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KKunKn166164
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 14:56:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KKumq8020891
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 14:56:49 -0600
In-Reply-To: <20080820115331.GA9965@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 07:53 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > mpage_da_map_blocks block allocation failed for inode 323784 at l=
ogical
> > > offset 313 with max blocks 11 with error -28
> > > This should not happen.!! Data will be lost
>=20
> We don't actually lose the data if free blocks are subsequently made
> available, correct?
>=20
> > I tried this patch. There are still multiple ways we can get wrong =
free
> > block count. The patch reduced the number of errors. So we are doin=
g
> > better with patch. But I guess we can't use the percpu_counter base=
d
> > free block accounting with delalloc. Without delalloc it is ok even=
 if
> > we find some wrong free blocks count . The actual block allocation =
will fail in
> > that case and we handle it perfectly fine. With delalloc we cannot
> > afford to fail the block allocation. Should we look at a free block
> > accounting rewrite using simple ext4_fsblk_t and and a spin lock ?
>=20
> It would be a shame if we did given that the whole point of the percp=
u
> counter was to avoid a scalability bottleneck.  Perhaps we could take
> a filesystem-level spinlock only when the number of free blocks as
> reported by the percpu_counter falls below some critical level?
>=20

Agree, and perhaps we should fall back to non-delalloc mode if the fs
free blocks below some critical level?

> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct inod=
e *inode, int nrblocks)
> >  	}
> >  	/* reduce fs free blocks counter */
> >  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> > -
> > +	/*
> > +	 * Now check whether the block count has gone negative.
> > +	 * Some other CPU could have reserved blocks in between
> > +	 */
> > +	if (percpu_counter_read(&sbi->s_freeblocks_counter) < 0) {
> > +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +		return -ENOSPC;
> > +	}
>=20
>=20
> I think you want to do the check before calling percpu_counter_sub();
> otherwise when you return ENOSPC the free blocks counter ends up
> getting reduced (and gets left negative).
>=20

The check is done in ext4_has_free_blocks(), which does do the
percpu_counter_read_positive() first, then do a percpu_counter_sum_set
=EF=BC=88=EF=BC=89 if the free blocks are below the threshhold.=20

There is always a window  between ext4_has_free_blocks() and
percpu_counter_sub(&sbi->s_freeblocks_counter, total),  so perhaps we
should introduce a new interface in percpu counter,  which does the sum
and sub together, protected by the global percpu lock.
}
> Also, this is one of the places where it might help if we did
> something like:
>=20
> 	freeblocks =3D percpu_counter_read(&sbi->s_freeblocks_counter);
> 	if (freeblocks < NR_CPUS*4)
> 		freeblocks =3D percpu_counter_sum(&sbi->s_freeblocks_counter);
>=20
> 	if (freeblocks < total) {
> 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 		return -ENOSPC;
> 	}
>=20

This is what currently ext4_has_free_blocks() is trying to do...

> BTW, I was looking at the percpu_counter interface, and I'm confused
> why we have percpu_counter_sum_and_set() and percpu_counter_sum().  I=
f
> we're taking the fbc->lock to calculate the precise value of the
> counter, why not simply set fbc->count? =20
>=20

I added the percpu_count_sum_and _set() interface, when addingdelalloc
block reservation. I agree it make sense to clean up current all the
user of percpu_counter_sum() and replace with
percpu_counter_sum_and_set(), just hasn't get chance to clean up yet.

> Also, it is singularly unfortunate that certain interfaces, such as
> percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
> definitely post-2.6.27, but it seems to me that we probably want
> something like percpu_counter_compare_lt() which does something like =
this:
>=20
> static inline int percpu_counter_compare_lt(struct percpu_counter *fb=
c,
> 					    s64 amount)
> {
> #ifdef CONFIG_SMP
> 	if ((fbc->count - amount) < FBC_BATCH)
> 		percpu_counter_sum_and_set(fbc);
> #endif
> 	return 	(fbc->count < amount);
> }
>=20
Looks better.

> ... which we would then use in ext4_has_free_blocks() and
> ext4_da_reserve_space().
>=20
> 						- Ted
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
