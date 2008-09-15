From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Mon, 15 Sep 2008 16:30:26 +0200
Message-ID: <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45606 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYIOO3M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 10:29:12 -0400
In-Reply-To: <20080915133604.GA6548@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le lundi 15 septembre 2008 =C3=A0 19:06 +0530, Aneesh Kumar K.V a =C3=A9=
crit :
> On Mon, Sep 15, 2008 at 02:16:47PM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=A9=
 wrote:
> > From: Frederic Bohe <frederic.bohe@bull.net>
> >=20
> > Do not rely on buffer head's uptodate flag to initialize
> > uninitialized bitmap blocks.
> >=20
> > Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
> > ---
> > Sorry there was a copy/paste error in the previous mail !
> >=20
> > This patch makes sure to initialize uninited bitmap blocks.
> > These are two test cases where bugs appear because of uninited bloc=
ks :
> >=20
> > 1- This test case lead to uninited block bitmap and an error messag=
e
> > from the mballocator during the second dd.
> >=20
> > dd if=3D/dev/urandom of=3D/dev/md0 bs=3D1M count=3D300
> > mkfs.ext4 -t ext4dev /dev/md0 1G
> > mount -t ext4dev /dev/md0 /mnt/test
> > resize2fs /dev/md0 2G
> > dd if=3D/dev/zero of=3D/mnt/test/dummy bs=3D1M count=3D1500
> >=20
> > Note that the first dd is to make sure we have random garbage in th=
e
> > uninited blocks. If not, you could miss the issue depending what wa=
s in
> > those blocks before running mkfs.
> >=20
> > 2- This test case lead to uninited inode bitmap blocks, making it
> > impossible to use all the inodes of the fs.
> >=20
> > dd if=3D/dev/urandom of=3D/dev/md0 bs=3D1M count=3D20
> > mkfs.ext4 -t ext4dev /dev/md0 10M
> > mount -t ext4dev /dev/md0 /mnt/test
> > resize2fs /dev/md0 20M
> > for i in $(seq 1 3800); do touch /mnt/test/file${i} 2>&1; done
> >=20
> >  balloc.c  |    4 +++-
> >  ialloc.c  |    4 +++-
> >  mballoc.c |    4 +++-
> >  3 files changed, 9 insertions(+), 3 deletions(-)
> >=20
> > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/balloc.c	2008-09-15 1=
0:59:27.000000000 +0200
> > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c	2008-09-15 14:03:=
04.000000000 +0200
> > @@ -318,9 +318,11 @@ ext4_read_block_bitmap(struct super_bloc
> >  			    block_group, bitmap_blk);
> >  		return NULL;
> >  	}
> > -	if (bh_uptodate_or_lock(bh))
> > +	if (buffer_uptodate(bh) &&
> > +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
> >  		return bh;
> >=20
> > +	lock_buffer(bh);
> >  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
> >  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> >  		ext4_init_block_bitmap(sb, bh, block_group, desc);
>=20
> Why ? I guess resize should mark those buffer_heads as not uptodate s=
o
> that we do a reinit of block bitmap again later. The above change wil=
l
> result in calling ext4_init_block_bitmap everytime we do a
> read_block_bitmap on an uninit group

Thanks for your comment Aneesh. I thought ext4_init_block_bitmap was
setting the EXT4_BG_BLOCK_UNINIT flags, but it seems it is not true.
I will try to fix it on the resize side.


>=20
>=20
>=20
>=20
> > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/ialloc.c	2008-09-15 1=
0:59:27.000000000 +0200
> > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c	2008-09-15 11:12:=
16.000000000 +0200
> > @@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_bloc
> >  			    block_group, bitmap_blk);
> >  		return NULL;
> >  	}
> > -	if (bh_uptodate_or_lock(bh))
> > +	if (buffer_uptodate(bh) &&
> > +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
> >  		return bh;
> >=20
> > +	lock_buffer(bh);
> >  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
> >  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> >  		ext4_init_inode_bitmap(sb, bh, block_group, desc);
> > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/mballoc.c	2008-09-15 =
10:59:27.000000000 +0200
> > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c	2008-09-15 14:02=
:44.000000000 +0200
> > @@ -785,9 +785,11 @@ static int ext4_mb_init_cache(struct pag
> >  		if (bh[i] =3D=3D NULL)
> >  			goto out;
> >=20
> > -		if (bh_uptodate_or_lock(bh[i]))
> > +		if (buffer_uptodate(bh[i]) &&
> > +		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
> >  			continue;
> >=20
> > +		lock_buffer(bh[i]);
> >  		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
> >  		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> >  			ext4_init_block_bitmap(sb, bh[i],
> >=20
>=20
> -aneesh
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
