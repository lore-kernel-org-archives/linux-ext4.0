From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 16:58:47 -0700
Message-ID: <1219276727.7895.69.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
	 <1219265808.7895.14.camel@mingming-laptop>
	 <1219274535.7895.55.camel@mingming-laptop>
	 <20080820234208.GO3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46168 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbYHTX6t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 19:58:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KNwmJc018437
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 19:58:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KNwmIP199626
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 19:58:48 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KNwlSq028072
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 19:58:47 -0400
In-Reply-To: <20080820234208.GO3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 17:42 -0600=EF=BC=8CAndreas Dilg=
er=E5=86=99=E9=81=93=EF=BC=9A
> On Aug 20, 2008  16:22 -0700, Mingming Cao wrote:
> > ext4: fall back to non delalloc mode if filesystem is almost full
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > In the case of filesystem is close to full (free blocks is below=20
> > the watermark NRCPUS *4) and there is not enough to reserve blocks =
for
> > delayed allocation, instead of return user back with ENOSPC error, =
with
> > this patch, it tries to fall back to non delayed allocation mode.
>=20
> I don't think that making a low watermark of only 4 blocks is enough,
> because each of the per-CPU counters could be off by as much as FBC_B=
ATCH.
> I think dropping delalloc support earlier is safer, something like
> (FBC_BATCH * NR_CPUS).
>=20
Okay, make sense.

> > +static int ext4_write_begin_nondelalloc(struct file *file,
> > +				struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned flags,
> > +				struct page **pagep, void **fsdata)
> > +{
> > +	struct inode *inode =3D mapping->host;
> > +
> > +	/* turn off delalloc for this inode*/
> > +	ext4_set_aops(inode, 0);
> > +
> > +	return mapping->a_ops->write_begin(file, mapping, pos, len,
> > +					   flags, pagep, fsdata);
> > +}
>=20
> Hmm, I don't understand this - isn't delalloc already off here, becau=
se
> this is "ext4_write_begin_nondelalloc()"?
>=20

This function probably should be called
ext4_wb_fall_back_to_nondelalloc().  it is called when we detect ENOSPC
and trying to fall back to non delalloc.

This function eventually will call nondelalloc write_begin function
ext4_write_begin().

> > +void ext4_set_aops(struct inode *inode, int delalloc)
> >  {
> > +	if (test_opt(inode->i_sb, DELALLOC)) {
> > +		if (ext4_has_free_blocks(EXT4_SB(inode->i_sb),
> > +			 EXT4_MIN_FREE_BLOCKS) > EXT4_MIN_FREE_BLOCKS)
> > +			delalloc =3D 0;
> > +
> > +		if (delalloc) {
> > +			inode->i_mapping->a_ops =3D &ext4_da_aops;
> > +			return;
> > +		} else
> > +			printk(KERN_INFO "filesystem is close to full, "
> > +				"delayed allocation is turned off for "
> > +				" inode %lu\n", inode->i_ino);
> > +	}
>=20
> Also, if you are doing this by changing the aops on the inode, isn't
> it possible that a large write starts outside the EXT4_MIN_FREE_BLOCK=
S
> boundary and then still runs out of space without changing the aops?
>=20

> Instead it is maybe better to do the check at the start of
> ext4_da_write_begin() and if it fails then call the non-delalloc
> write_begin from there?
>=20

Yeah that's better.

But I realize  a problem. Actually now I think we can't fall back to
nondelalloc mode if the inode has any dirty pages in the page cache, as
those pages need delalloc aops ->ext4_da_writepages() to handle delayed
allocation writeout..


> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
