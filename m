From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Ext4: Fix delalloc enospace handling counter update
	race
Date: Mon, 14 Jul 2008 10:54:36 -0700
Message-ID: <1216058076.6468.11.camel@mingming-laptop>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
	 <20080714010828.GD7938@mit.edu> <1216052897.7937.1.camel@mingming-laptop>
	 <20080714165324.GA3545@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53656 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbYGNRy6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 13:54:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EHsp3F011126
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 13:54:51 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EHsgWT193964
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 13:54:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EHsckQ021405
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 13:54:41 -0400
In-Reply-To: <20080714165324.GA3545@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-14=E4=B8=80=E7=9A=84 22:23 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Jul 14, 2008 at 09:28:17AM -0700, Mingming Cao wrote:
> >=20
> > Ext4: Fix delalloc enospace handling counter update race
> >=20
> > From: Mingming Cao <cmm@us.ibm.com>

> > Also in the case of truncate, we should not clear the per-allocatio=
n allocated
> > metablocks counter as that may be in-use by parallel allocation. Th=
e patch
> > only clear the per-allocation allocated metablocks when allocation =
is successfully returned.
> >=20
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>=20
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> > @@ -1519,7 +1529,8 @@ void ext4_da_release_space(struct inode=20
> >=20
> >  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> >  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> > -	EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> > +	if (used)
> > +		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> >  }
> >=20

After think again, this part of race fix may not needed, when the first
part of patch is applied. Since truncate is also hold the i_data_sem, s=
o
it could be assured that when truncate is releasing the page's  reserve=
d
blocks, there is no parallel block allocation.

Updated patch with only the first race fix,=20

If no objection I will fold this to the parent patch
delalloc-ext4-ENOSPC-handling.patch in the patch queue.

Regards,
Mingming

Ext4: Fix delalloc enospace handling counter update race

=46rom: Mingming Cao <cmm@us.ibm.com>

Ext4 delalloc reserve meta blocks ahead of time so later when real bloc=
k
allocation fs will not short of free blocks for allocating meta blocks.
It keeps track of the real number of new allocated meta data blocks, so
after block allocation it will update how much meta data blocks still
need to be reserved for that inode.

Both per inode reserved metadata blocks and per-allocation allocated me=
tablocks
are protected by the per inode delalloc reservation lock. The per-alloc=
ation
allocated metablocks counter should be protected by the i_data_sem as w=
ell,
so that it could avoid race with other block allocation to the same ino=
de
in parallel. The patch moves the code under the i_data_sem protection.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6.26-rc9/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.26-rc9.orig/fs/ext4/inode.c	2008-07-14 08:54:25.000000000=
 -0700
+++ linux-2.6.26-rc9/fs/ext4/inode.c	2008-07-14 10:51:00.000000000 -070=
0
@@ -1060,8 +1060,18 @@ int ext4_get_blocks_wrap(handle_t *handl
 							~EXT4_EXT_MIGRATE;
 		}
 	}
-	if (flag)
+
+	if (flag) {
 		EXT4_I(inode)->i_delalloc_reserved_flag =3D 0;
+		/*
+		 * Update reserved blocks/metadata blocks
+		 * after successful block allocation
+		 * which were deferred till now
+		 */
+		if ((retval > 0) && buffer_delay(bh))
+			ext4_da_release_space(inode, retval, 0);
+	}
+
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
@@ -2005,10 +2015,6 @@ static int ext4_da_get_block_write(struc
 	if (ret > 0) {
 		bh_result->b_size =3D (ret << inode->i_blkbits);
=20
-		/* release reserved-but-unused meta blocks */
-		if (buffer_delay(bh_result))
-			ext4_da_release_space(inode, ret, 0);
