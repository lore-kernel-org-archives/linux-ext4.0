From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/6 ]Ext4 credits caclulation cleanup and fix that for
	nonextent writepage
Date: Wed, 13 Aug 2008 18:02:06 -0700
Message-ID: <1218675726.6387.23.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558354.6766.40.camel@mingming-laptop>
	 <20080813101943.GF6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58852 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbYHNBCJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 21:02:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0ta0T007355
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:55:36 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E128Nr028830
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 19:02:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E128OQ018346
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 19:02:08 -0600
In-Reply-To: <20080813101943.GF6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 15:49 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 09:25:54AM -0700, Mingming Cao wrote:
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
>=20
>=20
> I guess we should pass chunk to ext4_meta_trans_blocks also.
> if (chunk) we should update only one group descriptor and one
> bitmap block ie,=20
> if(chunk)
> 	groups =3D 1 + idxblocks;
>=20
>=20

Agree. will update the patch to do that
Mingming
>=20
> > +
> > +	/* bitmaps and block group descriptor blocks */
> > +	ret +=3D groups + gdpblocks;
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
> ....
> ...
>=20
> > +static int ext4_writeblocks_trans_credits_old(struct inode *inode,=
 int nrblocks,
> > +					      int chunk)
> >  {
> > -	int bpp =3D ext4_journal_blocks_per_page(inode);
> > -	int indirects =3D (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> > +	int indirects;
> >  	int ret;
> >=20
> > -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> > -
> > -	if (ext4_should_journal_data(inode))
> > -		ret =3D 3 * (bpp + indirects) + 2;
> > -	else
> > -		ret =3D 2 * (bpp + indirects) + 2;
> > +	/*
> > +	 * How many index blocks need to touch to modify nrblocks?
> > +	 * The "Chunk" flag indicating whether the nrblocks is
> > +	 * physically contigous on disk
> > +	 *
> > + 	 * For Direct IO and fallocate, they calls get_block to allocate
> > + 	 * one single extent at a time, so they could set the "Chunk" fl=
ag
> > +	 */
> > +	indirects =3D ext4_indirect_trans_blocks(inode, nrblocks, chunk);
> >=20
> > -#ifdef CONFIG_QUOTA
> > -	/* We know that structure was already allocated during DQUOT_INIT=
 so
> > -	 * we will be updating only the data blocks + inodes */
> > -	ret +=3D 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> > -#endif
> > +	/* Account for block group bitmaps and block groups
> > +	 * descriptors.Worse case, the nrblocks+indirects blocks spread
> > +	 * over different block groups
> > +	 */
> > +	ret =3D ext4_meta_trans_blocks(inode, nrblocks, indirects);
> >=20
> >  	return ret;
> >  }
>=20
> -aneesh

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
