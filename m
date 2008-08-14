From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 17:10:53 -0700
Message-ID: <1218672653.6456.14.camel@mingming-laptop>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>
	 <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu>
	 <200808132307.07437.mail@eworm.de>  <20080813220100.GE6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hesse <mail@eworm.de>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36590 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbYHNALC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 20:11:02 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7E0B1gB027991
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:11:01 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E0AsSX209900
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:10:54 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E0ArZq016077
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 20:10:53 -0400
In-Reply-To: <20080813220100.GE6142@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 18:01 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Aug 13, 2008 at 11:07:06PM +0200, Christian Hesse wrote:
> >=20
> > Please look at the bottom of my last two mails... That was with you=
r patch=20
> > applied.
>=20
> Sorry, I missed it.  The new BUG s without checking there is notch we=
ems to be a bug in the delayed
> allocation code, specifically here, in fs/ext4/inode.c:ext4_da_releas=
e_space():
>=20
> 	   /* figure out how many metablocks to release */
> 	   BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> 	   mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks - mdb;
>=20
> I've quickly looked at the code, and how i_reserved_meta_blocks gets
> updated, and nothing *obviously* wrong is jumping out at me.  Anyone
> else have time to investigate this a bit more deeply?
>=20

I could reproduce it. =20

This patch works for me on top of Ted's change.  Christian, could you
try it?


---------------------------------------------------

Ext4: Fix delalloc release block reservation for truncate

=46rom: Mingming Cao <cmm@us.ibm.com>

Ext4 will release the reserved blocks for delalloc=20
when inode is truncated/unlinked.  If there is no reserved block at all=
,
we  shouldn't  need to do so.  But current code still tries to release =
the
reserved blocks regardless whether the counters's value is 0.=20
Continue doing that causes the later calculation went wrong and a kerne=
l BUG_ON()
catched that. This doesn't happen for originally extent format file, as=
 the calculation
for 0 reserved blocks was right for  extent based file.

This patch fixed the kernel BUG() due to above reason. It adds checks f=
or 0 to
avoid unnecessary release and fix calculation for non extent files.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Index: linux-2.6.27-rc1/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-13 15:29:35.000000000=
 -0700
+++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-13 16:22:14.000000000 -070=
0
@@ -1007,6 +1007,9 @@ static int ext4_indirect_calc_metadata_a
  */
 static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
 {
+	if (!blocks)
+		return 0;
+
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
 		return ext4_ext_calc_metadata_amount(inode, blocks);
=20
@@ -1553,8 +1556,27 @@ static void ext4_da_release_space(struct
 	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
 	int total, mdb, mdb_free, release;
=20
+	if (!to_free){
+		/* Nothing to release, exit */
+		return;
+	}
+
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
=20
+	if (!EXT4_I(inode)->i_reserved_data_blocks){
+		/*
+		 * if there is no reserved blocks, but we try to free some
+		 * then the counter is messed up somewhere.
+		 * but since this function is called from invalidate
+		 * page, it's harmless to return without any action
+		 */
+		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
+			    "blocks for inode %lu, but there is no reserved"
+			    "data blocks\n", inode->i_ino, to_free);
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		return;
+	}
+
 	/* recalculate the number of metablocks still need to be reserved */
 	total =3D EXT4_I(inode)->i_reserved_data_blocks - to_free;
 	mdb =3D ext4_calc_metadata_amount(inode, total);
@@ -3592,7 +3614,7 @@ void ext4_truncate(struct inode *inode)
 	 * ext4 *really* writes onto the disk inode.
 	 */
 	ei->i_disksize =3D inode->i_size;
-=09
+
 	if (n =3D=3D 1) {		/* direct blocks */
 		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
 			       i_data + EXT4_NDIR_BLOCKS);


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
