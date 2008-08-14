From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/6 ]Ext4 credits caclulation cleanup and fix that for
	nonextent writepage
Date: Wed, 13 Aug 2008 17:30:51 -0700
Message-ID: <1218673851.6456.22.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558354.6766.40.camel@mingming-laptop>
	 <20080813083132.GA6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43490 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbYHNAax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 20:30:53 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0Uquq017498
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:30:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E0UqWD230876
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:30:52 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E0UpsN009341
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:30:52 -0400
In-Reply-To: <20080813083132.GA6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 14:01 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 09:25:54AM -0700, Mingming Cao wrote:
>=20
> ....
>=20
>=20
> > - * and dindirect block, and the "5" above becomes "3".
> > + * Also account for superblock, inode, quota and xattr blocks
> > + */
> > +int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int =
idxblocks)
> > +{
> > +	int groups, gdpblocks;
> > +	int ret =3D 0;
> > +
> > +	groups =3D nrblocks + idxblocks;
> > +	gdpblocks =3D groups;
> > +	if (groups > EXT4_SB(inode->i_sb)->s_groups_count)
> > +		groups =3D EXT4_SB(inode->i_sb)->s_groups_count;
> > +	if (groups > EXT4_SB(inode->i_sb)->s_gdb_count)
> > +		gdpblocks =3D EXT4_SB(inode->i_sb)->s_gdb_count;
> > +
> > +	/* bitmaps and block group descriptor blocks */
> > +	ret +=3D groups + gdpblocks;
>=20
>=20
> 	ret =3D groups + gdpblocks;
>=20
> > +
> > +	ret +=3D idxblocks;
> > +
> > +	/* journalled mode, include buffer to modify data blocks */
> > +	if (ext4_should_journal_data(inode))
> > +		ret +=3D nrblocks;
> > +
> > +	/* Blocks for super block, inode, quota and xattr blocks */
> > +	ret +=3D EXT4_META_TRANS_BLOCKS(inode->i_sb);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ext4_indirect_trans_blocks(struct inode *inode, int nrb=
locks,
> > +				      int chunk)
> > +{
>=20
> .....
> .....
>=20
> >=20
> > +/*
> > + * Define the number of metadata blocks we need to account to modi=
fy data.
> > + *
> > + * This include super block, inode block, quota blocks and xattr b=
locks
> > + */
> > +#define EXT4_META_TRANS_BLOCKS(sb)	(EXT4_XATTR_TRANS_BLOCKS + \
> > +					2*EXT4_QUOTA_TRANS_BLOCKS(sb))
> > +
>=20
> Do EXT4_XATTR_TRANS_BLOCKS blocks really account for super block
> and inode block ?
Yes, here is the define

/* Extended attribute operations touch at most two data buffers,
 * two bitmap buffers, and two group summaries, in addition to the inod=
e
 * and the superblock, which are already accounted for. */

#define EXT4_XATTR_TRANS_BLOCKS         6U


>  Looking at EXT4_DATA_TRANS_BLOCKS which also use
> EXT4_XATTR_TRANS_BLOCKS I think it doesn't.

It's pretty clear from the comment. =20

/* Define the minimum size for a transaction which modifies data.  This
 * needs to take into account the fact that we may end up modifying two
 * quota files too (one for the group, one for the user quota).  The
 * superblock only gets updated once, of course, so don't bother
 * counting that again for the quota updates. */

#define EXT4_DATA_TRANS_BLOCKS(sb)
(EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
                                         EXT4_XATTR_TRANS_BLOCKS - 2 + =
\
                                         2*EXT4_QUOTA_TRANS_BLOCKS(sb))

It does have  "-2" in  EXT4_DATA_TRANS_BLOCKS to remove double accounte=
d
super and inode block


Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
