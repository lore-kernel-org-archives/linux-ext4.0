From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 10:02:33 -0700
Message-ID: <1216400553.6869.11.camel@mingming-laptop>
References: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38737 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbYGRRDF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 13:03:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6IH341I013016
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 13:03:04 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IH33Tx225508
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 13:03:04 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IH33Tw006079
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 13:03:03 -0400
In-Reply-To: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I tried this patch, with nodelalloc, the kernel did not crash! Previous
it crashes in a few minutes.

 but the test did not stop after fill the file by specified 2G size


I noticed the write() to write to the last fallocate extent(up to 2G)
returns junk value.


The testcase I got from Shehjart (who originally reported the problem)
is =20

http://www.gelato.unsw.edu.au/~shehjart/writefallocate.c

command I use to reproduce the problem is=20

=2E/writefallocate --filesize 2147483648 --wrblksize 65536 --fallocate
1048576 --filename /mnt/ext4/a --nounlink

=2E............
offset: 2147024896, written: 65536^M
offset: 2147090432, written: 65536^M
offset: 2147155968, written: 65536^M
offset: 2147221504, written: 65536^M
offset: 2147287040, written: 65536^M
offset: 2147352576, written: 65536^M
offset: 2147418112, written: 65535^M
offset: 2147483647, written: 18446744073709551615^M
fallocate offset: 2147483647^M
offset: 2147483646, written: 18446744073709551615^M
offset: 2147483645, written: 18446744073709551615^M
offset: 2147483644, written: 18446744073709551615^M
offset: 2147483643, written: 18446744073709551615^M
offset: 2147483642, written: 18446744073709551615^M
offset: 2147483641, written: 18446744073709551615^M
offset: 2147483640, written: 18446744073709551615^M


Appearently the test has fallocate/fill the 2G file, but since the last
write() returns 18446744073709551615, the offset is decreased, cause th=
e
test continue with a break,  and writes to wrong offset




=E5=9C=A8 2008-07-18=E4=BA=94=E7=9A=84 18:47 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> We need to recalucate the path information on extent insert
> even if depth doesn't change.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   41 +++++++++++++++++++++++------------------
>  1 files changed, 23 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7bdaeec..9c8541e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2462,7 +2462,10 @@ static int ext4_ext_convert_to_initialized(han=
dle_t *handle,
>  		unsigned int newdepth;
>  		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
>  		if (allocated <=3D EXT4_EXT_ZERO_LEN) {
> -			/* Mark first half uninitialized.
> +			/*
> +			 * iblock =3D=3D ee_block is handled by the zerouout
> +			 * at the beginning.
> +			 * Mark first half uninitialized.
>  			 * Mark second half initialized and zero out the
>  			 * initialized extent
>  			 */
> @@ -2485,7 +2488,7 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
>  				ex->ee_len   =3D orig_ex.ee_len;
>  				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  				ext4_ext_dirty(handle, inode, path + depth);
> -				/* zeroed the full extent */
> +				/* blocks available from iblock */
>  				return allocated;
>=20
>  			} else if (err)
> @@ -2513,6 +2516,7 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
>  					err =3D PTR_ERR(path);
>  					return err;
>  				}
> +				/* get the second half extent details */
>  				ex =3D path[depth].p_ext;
>  				err =3D ext4_ext_get_access(handle, inode,
>  								path + depth);
> @@ -2542,6 +2546,7 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
>  			/* zeroed the full extent */
> +			/* blocks available from iblock */
>  			return allocated;
>=20
>  		} else if (err)
> @@ -2557,23 +2562,22 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t *handle,
>  		 */
>  		orig_ex.ee_len =3D cpu_to_le16(ee_len -
>  						ext4_ext_get_actual_len(ex3));
> -		if (newdepth !=3D depth) {
> -			depth =3D newdepth;
> -			ext4_ext_drop_refs(path);
> -			path =3D ext4_ext_find_extent(inode, iblock, path);
> -			if (IS_ERR(path)) {
> -				err =3D PTR_ERR(path);
> -				goto out;
> -			}
> -			eh =3D path[depth].p_hdr;
> -			ex =3D path[depth].p_ext;
> -			if (ex2 !=3D &newex)
> -				ex2 =3D ex;
> -
> -			err =3D ext4_ext_get_access(handle, inode, path + depth);
> -			if (err)
> -				goto out;
> +		depth =3D newdepth;
> +		ext4_ext_drop_refs(path);
> +		path =3D ext4_ext_find_extent(inode, iblock, path);
> +		if (IS_ERR(path)) {
> +			err =3D PTR_ERR(path);
> +			goto out;
>  		}
> +		eh =3D path[depth].p_hdr;
> +		ex =3D path[depth].p_ext;
> +		if (ex2 !=3D &newex)
> +			ex2 =3D ex;
> +
> +		err =3D ext4_ext_get_access(handle, inode, path + depth);
> +		if (err)
> +			goto out;
> +
>  		allocated =3D max_blocks;
>=20
>  		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
> @@ -2591,6 +2595,7 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
>  			/* zero out the first half */
> +			/* blocks available from iblock */
>  			return allocated;
>  		}
>  	}

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
