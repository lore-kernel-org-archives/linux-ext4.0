From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 10:22:47 -0700
Message-ID: <1216401767.6869.19.camel@mingming-laptop>
References: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1216400553.6869.11.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39039 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296AbYGRRWv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 13:22:51 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6IHMn7t022877
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 13:22:49 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IHMnSA150666
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 11:22:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IHMmm9027394
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 11:22:49 -0600
In-Reply-To: <1216400553.6869.11.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-18=E4=BA=94=E7=9A=84 10:02 -0700=EF=BC=8CMingming Cao=
=E5=86=99=E9=81=93=EF=BC=9A
> I tried this patch, with nodelalloc, the kernel did not crash! Previo=
us
> it crashes in a few minutes.
>=20
>  but the test did not stop after fill the file by specified 2G size
>=20
>=20
> I noticed the write() to write to the last fallocate extent(up to 2G)
> returns junk value.
>=20
>=20
> The testcase I got from Shehjart (who originally reported the problem=
)
> is =20
>=20
> http://www.gelato.unsw.edu.au/~shehjart/writefallocate.c
>=20

I forget to mention that I modify the test slight to call fallocate()
with default mode (expnd size) instead of keep size.


> command I use to reproduce the problem is=20
>=20
> ./writefallocate --filesize 2147483648 --wrblksize 65536 --fallocate
> 1048576 --filename /mnt/ext4/a --nounlink
>=20
> .............
> offset: 2147024896, written: 65536^M
> offset: 2147090432, written: 65536^M
> offset: 2147155968, written: 65536^M
> offset: 2147221504, written: 65536^M
> offset: 2147287040, written: 65536^M
> offset: 2147352576, written: 65536^M
> offset: 2147418112, written: 65535^M
> offset: 2147483647, written: 18446744073709551615^M
> fallocate offset: 2147483647^M
> offset: 2147483646, written: 18446744073709551615^M
> offset: 2147483645, written: 18446744073709551615^M
> offset: 2147483644, written: 18446744073709551615^M
> offset: 2147483643, written: 18446744073709551615^M
> offset: 2147483642, written: 18446744073709551615^M
> offset: 2147483641, written: 18446744073709551615^M
> offset: 2147483640, written: 18446744073709551615^M
>=20
>=20
> Appearently the test has fallocate/fill the 2G file, but since the la=
st
> write() returns 18446744073709551615, the offset is decreased, cause =
the
> test continue with a break,  and writes to wrong offset
>=20
>=20
>=20
>=20
> =E5=9C=A8 2008-07-18=E4=BA=94=E7=9A=84 18:47 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > We need to recalucate the path information on extent insert
> > even if depth doesn't change.
> >=20
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/extents.c |   41 +++++++++++++++++++++++------------------
> >  1 files changed, 23 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 7bdaeec..9c8541e 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2462,7 +2462,10 @@ static int ext4_ext_convert_to_initialized(h=
andle_t *handle,
> >  		unsigned int newdepth;
> >  		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
> >  		if (allocated <=3D EXT4_EXT_ZERO_LEN) {
> > -			/* Mark first half uninitialized.
> > +			/*
> > +			 * iblock =3D=3D ee_block is handled by the zerouout
> > +			 * at the beginning.
> > +			 * Mark first half uninitialized.
> >  			 * Mark second half initialized and zero out the
> >  			 * initialized extent
> >  			 */
> > @@ -2485,7 +2488,7 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t *handle,
> >  				ex->ee_len   =3D orig_ex.ee_len;
> >  				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> >  				ext4_ext_dirty(handle, inode, path + depth);
> > -				/* zeroed the full extent */
> > +				/* blocks available from iblock */
> >  				return allocated;
> >=20
> >  			} else if (err)
> > @@ -2513,6 +2516,7 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t *handle,
> >  					err =3D PTR_ERR(path);
> >  					return err;
> >  				}
> > +				/* get the second half extent details */
> >  				ex =3D path[depth].p_ext;
> >  				err =3D ext4_ext_get_access(handle, inode,
> >  								path + depth);
> > @@ -2542,6 +2546,7 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t *handle,
> >  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> >  			ext4_ext_dirty(handle, inode, path + depth);
> >  			/* zeroed the full extent */
> > +			/* blocks available from iblock */
> >  			return allocated;
> >=20
> >  		} else if (err)
> > @@ -2557,23 +2562,22 @@ static int ext4_ext_convert_to_initialized(=
handle_t *handle,
> >  		 */
> >  		orig_ex.ee_len =3D cpu_to_le16(ee_len -
> >  						ext4_ext_get_actual_len(ex3));
> > -		if (newdepth !=3D depth) {
> > -			depth =3D newdepth;
> > -			ext4_ext_drop_refs(path);
> > -			path =3D ext4_ext_find_extent(inode, iblock, path);
> > -			if (IS_ERR(path)) {
> > -				err =3D PTR_ERR(path);
> > -				goto out;
> > -			}
> > -			eh =3D path[depth].p_hdr;
> > -			ex =3D path[depth].p_ext;
> > -			if (ex2 !=3D &newex)
> > -				ex2 =3D ex;
> > -
> > -			err =3D ext4_ext_get_access(handle, inode, path + depth);
> > -			if (err)
> > -				goto out;
> > +		depth =3D newdepth;
> > +		ext4_ext_drop_refs(path);
> > +		path =3D ext4_ext_find_extent(inode, iblock, path);
> > +		if (IS_ERR(path)) {
> > +			err =3D PTR_ERR(path);
> > +			goto out;
> >  		}
> > +		eh =3D path[depth].p_hdr;
> > +		ex =3D path[depth].p_ext;
> > +		if (ex2 !=3D &newex)
> > +			ex2 =3D ex;
> > +
> > +		err =3D ext4_ext_get_access(handle, inode, path + depth);
> > +		if (err)
> > +			goto out;
> > +
> >  		allocated =3D max_blocks;
> >=20
> >  		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
> > @@ -2591,6 +2595,7 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t *handle,
> >  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> >  			ext4_ext_dirty(handle, inode, path + depth);
> >  			/* zero out the first half */
> > +			/* blocks available from iblock */
> >  			return allocated;
> >  		}
> >  	}
>=20
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
