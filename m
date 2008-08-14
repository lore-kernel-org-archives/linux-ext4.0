From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/6 ]Ext4: journal credits reservation fixes for extent
	file writepage
Date: Wed, 13 Aug 2008 17:26:58 -0700
Message-ID: <1218673618.6456.18.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558473.6766.44.camel@mingming-laptop>
	 <20080813083749.GB6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57918 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYHNA1B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 20:27:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0R0Vd018191
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:27:00 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E0QwW2218848
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:26:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E0Qwiu027339
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:26:58 -0400
In-Reply-To: <20080813083749.GB6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 14:07 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 09:27:53AM -0700, Mingming Cao wrote:
>=20
> ....
> ....
>=20
> >=20
> >  /*
> > - * ext4_ext_calc_credits_for_insert:
> > - * This routine returns max. credits that the extent tree can cons=
ume.
> > - * It should be OK for low-performance paths like ->writepage()
> > - * To allow many writing processes to fit into a single transactio=
n,
> > - * the caller should calculate credits under i_data_sem and
> > - * pass the actual path.
> > + * ext4_ext_calc_credits_for_single_extent:
> > + * This routine returns max. credits that needed to insert an exte=
nt
> > + * to the extent tree.
> > + * When pass the actual path, the caller should calculate credits
> > + * under i_data_sem.
> >   */
> > -int ext4_ext_calc_credits_for_insert(struct inode *inode,
> > +int ext4_ext_calc_credits_for_single_extent(struct inode *inode, i=
nt num,
> >  						struct ext4_ext_path *path)
> >  {
> > -	int depth, needed;
> > +	int depth =3D ext_depth(inode);
> >=20
> >  	if (path) {
> >  		/* probably there is space in leaf? */
> > -		depth =3D ext_depth(inode);
> >  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
> >  				< le16_to_cpu(path[depth].p_hdr->eh_max))
> > -			return 1;
> > +			return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
> >  	}
> >=20
> > -	/*
> > -	 * given 32-bit logical block (4294967296 blocks), max. tree
> > -	 * can be 4 levels in depth -- 4 * 340^4 =3D=3D 53453440000.
> > -	 * Let's also add one more level for imbalance.
> > -	 */
> > -	depth =3D 5;
> > -
> > -	/* allocation of new data block(s) */
> > -	needed =3D 2;
> > +	return ext4_ext_writepage_trans_blocks(inode, num, 1);
>=20
>=20
> single extent insert should not look at journaling mode or not
> In the above with path specified we don't look at journaling mode
> but ext4_ext_writepage_trans_blocks will do

Are you sure about this?

 ext4_ext_calc_credits_for_single_extent is actually only called from
migration and defrag with this set of changes now. In the
data=3Djournalling mode, since we move data around (for migration and
defrag),  I think we still need to log the data buffers. I might be
over-causous.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
