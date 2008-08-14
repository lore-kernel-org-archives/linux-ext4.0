From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6 ]Ext4: journal credits reservation fixes for extent
	file writepage
Date: Thu, 14 Aug 2008 13:58:19 +0530
Message-ID: <20080814082819.GA6422@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558473.6766.44.camel@mingming-laptop> <20080813083749.GB6439@skywalker> <1218673618.6456.18.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41533 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYHNI2r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 04:28:47 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7E8Rfm3011001
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:27:41 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E8ShB0161820
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:28:43 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E8SgNu014739
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:28:43 +1000
Content-Disposition: inline
In-Reply-To: <1218673618.6456.18.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 05:26:58PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 14:07 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > On Tue, Aug 12, 2008 at 09:27:53AM -0700, Mingming Cao wrote:
> >=20
> > ....
> > ....
> >=20
> > >=20
> > >  /*
> > > - * ext4_ext_calc_credits_for_insert:
> > > - * This routine returns max. credits that the extent tree can co=
nsume.
> > > - * It should be OK for low-performance paths like ->writepage()
> > > - * To allow many writing processes to fit into a single transact=
ion,
> > > - * the caller should calculate credits under i_data_sem and
> > > - * pass the actual path.
> > > + * ext4_ext_calc_credits_for_single_extent:
> > > + * This routine returns max. credits that needed to insert an ex=
tent
> > > + * to the extent tree.
> > > + * When pass the actual path, the caller should calculate credit=
s
> > > + * under i_data_sem.
> > >   */
> > > -int ext4_ext_calc_credits_for_insert(struct inode *inode,
> > > +int ext4_ext_calc_credits_for_single_extent(struct inode *inode,=
 int num,
> > >  						struct ext4_ext_path *path)
> > >  {
> > > -	int depth, needed;
> > > +	int depth =3D ext_depth(inode);
> > >=20
> > >  	if (path) {
> > >  		/* probably there is space in leaf? */
> > > -		depth =3D ext_depth(inode);
> > >  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
> > >  				< le16_to_cpu(path[depth].p_hdr->eh_max))
> > > -			return 1;
> > > +			return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
> > >  	}
> > >=20
> > > -	/*
> > > -	 * given 32-bit logical block (4294967296 blocks), max. tree
> > > -	 * can be 4 levels in depth -- 4 * 340^4 =3D=3D 53453440000.
> > > -	 * Let's also add one more level for imbalance.
> > > -	 */
> > > -	depth =3D 5;
> > > -
> > > -	/* allocation of new data block(s) */
> > > -	needed =3D 2;
> > > +	return ext4_ext_writepage_trans_blocks(inode, num, 1);
> >=20
> >=20
> > single extent insert should not look at journaling mode or not
> > In the above with path specified we don't look at journaling mode
> > but ext4_ext_writepage_trans_blocks will do
>=20
> Are you sure about this?
>=20
>  ext4_ext_calc_credits_for_single_extent is actually only called from
> migration and defrag with this set of changes now. In the
> data=3Djournalling mode, since we move data around (for migration and
> defrag),  I think we still need to log the data buffers. I might be
> over-causous.
>=20

Migrate doesn't touch the data buffers at all. It builds new extents
and insert them into the tree. So we don't need to reserve credits for
data blocks with migrate.

But still the code is wrong because we do
	if (path) {
		.....
		.....
		return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);

here we don't account for data blocks needed for the journal mode

and

	return ext4_ext_writepage_trans_blocks(inode, num, 1);

here we account for data blocks.

Also ext4_ext_calc_credits_for_single_extent was not accounting for
data blocks earlier. So I would assume the change in behavior is not
needed

-aneesh

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
