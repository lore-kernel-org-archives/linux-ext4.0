From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] Compile warning fix when enable EXT_DEBUG
Date: Wed, 12 Aug 2009 09:10:27 -0700
Message-ID: <1250093427.18329.33.camel@mingming-laptop>
References: <1250091147.18329.10.camel@mingming-laptop>
	 <4A82E41F.2050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44125 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZHLQKk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2009 12:10:40 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7CG5g1F011960
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:05:42 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7CGAUMa164676
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:10:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7CGATZ9025480
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:10:29 -0600
In-Reply-To: <4A82E41F.2050702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> >=20
> > Index: linux-2.6.31-rc4/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.31-rc4.orig/fs/ext4/extents.c
> > +++ linux-2.6.31-rc4/fs/ext4/extents.c
> > @@ -2105,7 +2105,8 @@ ext4_ext_rm_leaf(handle_t *handle, struc
> >  		else
> >  			uninitialized =3D 0;
> > =20
> > -		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
> > +		ext_debug("remove ext %u:[%d]%d\n", ex_ee_block,
> > +			 ext4_ext_is_uninitialized(ex), ex_ee_len);
> >  		path[depth].p_ext =3D ex;
>=20
> Shouldn't part of this be in your next patch, [PATCH]Show unwritten
> extent flag in ext4_ext_show_leaf() ?
>=20
> Thanks,
> -Eric

Updated patch.

When enable EXT_DEBUG I got the following compile warning on PPC64

  CC [M]  fs/ext4/inode.o
  CC [M]  fs/ext4/extents.o
fs/ext4/extents.c: In function =E2=80=98ext4_ext_rm_leaf=E2=80=99:
fs/ext4/extents.c:2097: warning: format =E2=80=98%lu=E2=80=99 expects t=
ype =E2=80=98long unsigned int=E2=80=99, but argument 2 has type =E2=80=
=98ext4_lblk_t=E2=80=99
fs/ext4/extents.c: In function =E2=80=98ext4_ext_get_blocks=E2=80=99:
fs/ext4/extents.c:2789: warning: format =E2=80=98%u=E2=80=99 expects ty=
pe =E2=80=98unsigned int=E2=80=99, but argument 4 has type =E2=80=98lon=
g unsigned int=E2=80=99
fs/ext4/extents.c:2852: warning: format =E2=80=98%lu=E2=80=99 expects t=
ype =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=80=
=98ext4_lblk_t=E2=80=99
fs/ext4/extents.c:2953: warning: format =E2=80=98%lu=E2=80=99 expects t=
ype =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=80=
=98unsigned int=E2=80=99
  CC [M]  fs/ext4/migrate.o

The patch fixed compile warning.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>


Index: linux-2.6.31-rc4/fs/ext4/extents.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -2094,7 +2094,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 		else
 			uninitialized =3D 0;
=20
-		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
+		ext_debug("remove ext %u:%d\n", ex_ee_block, ex_ee_len);
 		path[depth].p_ext =3D ex;
=20
 		a =3D ex_ee_block > start ? ex_ee_block : start;
@@ -2786,7 +2786,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	struct ext4_allocation_request ar;
=20
 	__clear_bit(BH_New, &bh_result->b_state);
-	ext_debug("blocks %u/%u requested for inode %u\n",
+	ext_debug("blocks %u/%u requested for inode %lu\n",
 			iblock, max_blocks, inode->i_ino);
=20
 	/* check in cache */
@@ -2849,7 +2849,7 @@ int ext4_ext_get_blocks(handle_t *handle
 			newblock =3D iblock - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated =3D ee_len - (iblock - ee_block);
-			ext_debug("%u fit into %lu:%d -> %llu\n", iblock,
+			ext_debug("%u fit into %u:%d -> %llu\n", iblock,
 					ee_block, ee_len, newblock);
=20
 			/* Do not put uninitialized extent in the cache */
@@ -2950,7 +2950,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	newblock =3D ext4_mb_new_blocks(handle, &ar, &err);
 	if (!newblock)
 		goto out2;
-	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
+	ext_debug("allocate new block: goal %llu, found %llu/%u\n",
 		  ar.goal, newblock, allocated);
=20
 	/* try to insert new extent into found leaf and return */


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
