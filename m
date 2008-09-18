From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Thu, 18 Sep 2008 15:45:14 +0200
Message-ID: <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
	 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52080 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYIRNn7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2008 09:43:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 8B1AE1A18AC
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2008 15:43:51 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 11203-03 for <linux-ext4@vger.kernel.org>;
 Thu, 18 Sep 2008 15:43:48 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 0A2191A18D2
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2008 15:43:48 +0200 (CEST)
Received: from [129.183.101.223] (dhcp129183101223.frec.bull.fr [129.183.101.223])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 262C527291
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2008 15:43:45 +0200 (CEST)
In-Reply-To: <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am not very confident with buffer's behavior, but I think I have
understood what happens. Correct me if I am wrong.
Let's see the second test case, which was :

dd if=3D/dev/urandom of=3D/dev/md0 bs=3D1M count=3D20
mkfs.ext4 -t ext4dev /dev/md0 10M
mount -t ext4dev /dev/md0 /mnt/test
resize2fs /dev/md0 20M
for i in $(seq 1 3800); do touch /mnt/test/file${i} 2>&1; done
touch: cannot touch `/mnt/test/file3188': No space left on device
touch: cannot touch `/mnt/test/file3189': No space left on device
=2E..
=2E..


The issue here is that you can't use all inode of the second group of
the fs.

This happens because resize2fs make a call to ext2fs_read_bitmaps. This
function reads all bitmaps while paying attention not to read the
uninited bitmap. This works well as long as the fs block size is equal
to the page size. But in the above test case, the fs use 1k blocks and
we have an issue.=20

That's because the "read" function issued by ext2fs_read_bitmaps is a
call to kernel's block_read_full_page function. So when a single bitmap
block is asked for, 4 blocks (for 1k blocks fs on x86) are actually rea=
d
(including the uninited ones) and their respective buffer set to
uptodate.=20

As we rely on the buffer's uptodate flags to initialize or not this
buffer, it may happen that certain bitmap blocks are not initialized at
all. So their buffer contains the random garbage that was present on th=
e
disk prior to the mkfs ( In the above test case, the inode bitmap of th=
e
second group is full a random bits so I can't use all of its inodes ).

If the bitmap block corresponding to this buffer is later changed, its
UNINIT flag will be cleared and the content of the buffer written to th=
e
disk, including the garbage.


I am a bit lost on how to fix this. Aneesh was right, I think it's an
ext2fs_read_bitmaps bug, not a kernel bug. I guess we need a userland
function to read a single block whatever the block size and page size
are. I've made a try using O_DIRECT flag but I was unsuccessful. Any
ideas/suggestions ?

=46red


Le lundi 15 septembre 2008 =C3=A0 16:30 +0200, Fr=C3=A9d=C3=A9ric Boh=C3=
=A9 a =C3=A9crit :
> Le lundi 15 septembre 2008 =C3=A0 19:06 +0530, Aneesh Kumar K.V a =C3=
=A9crit :
> > On Mon, Sep 15, 2008 at 02:16:47PM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=
=A9 wrote:
> > > From: Frederic Bohe <frederic.bohe@bull.net>
> > >=20
> > > Do not rely on buffer head's uptodate flag to initialize
> > > uninitialized bitmap blocks.
> > >=20
> > > Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
> > > ---
> > > Sorry there was a copy/paste error in the previous mail !
> > >=20
> > > This patch makes sure to initialize uninited bitmap blocks.
> > > These are two test cases where bugs appear because of uninited bl=
ocks :
> > >=20
> > > 1- This test case lead to uninited block bitmap and an error mess=
age
> > > from the mballocator during the second dd.
> > >=20
> > > dd if=3D/dev/urandom of=3D/dev/md0 bs=3D1M count=3D300
> > > mkfs.ext4 -t ext4dev /dev/md0 1G
> > > mount -t ext4dev /dev/md0 /mnt/test
> > > resize2fs /dev/md0 2G
> > > dd if=3D/dev/zero of=3D/mnt/test/dummy bs=3D1M count=3D1500
> > >=20
> > > Note that the first dd is to make sure we have random garbage in =
the
> > > uninited blocks. If not, you could miss the issue depending what =
was in
> > > those blocks before running mkfs.
> > >=20
> > > 2- This test case lead to uninited inode bitmap blocks, making it
> > > impossible to use all the inodes of the fs.
> > >=20
> > > dd if=3D/dev/urandom of=3D/dev/md0 bs=3D1M count=3D20
> > > mkfs.ext4 -t ext4dev /dev/md0 10M
> > > mount -t ext4dev /dev/md0 /mnt/test
> > > resize2fs /dev/md0 20M
> > > for i in $(seq 1 3800); do touch /mnt/test/file${i} 2>&1; done
> > >=20
> > >  balloc.c  |    4 +++-
> > >  ialloc.c  |    4 +++-
> > >  mballoc.c |    4 +++-
> > >  3 files changed, 9 insertions(+), 3 deletions(-)
> > >=20
> > > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/balloc.c	2008-09-15=
 10:59:27.000000000 +0200
> > > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c	2008-09-15 14:0=
3:04.000000000 +0200
> > > @@ -318,9 +318,11 @@ ext4_read_block_bitmap(struct super_bloc
> > >  			    block_group, bitmap_blk);
> > >  		return NULL;
> > >  	}
> > > -	if (bh_uptodate_or_lock(bh))
> > > +	if (buffer_uptodate(bh) &&
> > > +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
> > >  		return bh;
> > >=20
> > > +	lock_buffer(bh);
> > >  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
> > >  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> > >  		ext4_init_block_bitmap(sb, bh, block_group, desc);
> >=20
> > Why ? I guess resize should mark those buffer_heads as not uptodate=
 so
> > that we do a reinit of block bitmap again later. The above change w=
ill
> > result in calling ext4_init_block_bitmap everytime we do a
> > read_block_bitmap on an uninit group
>=20
> Thanks for your comment Aneesh. I thought ext4_init_block_bitmap was
> setting the EXT4_BG_BLOCK_UNINIT flags, but it seems it is not true.
> I will try to fix it on the resize side.
>=20
>=20
> >=20
> >=20
> >=20
> >=20
> > > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/ialloc.c	2008-09-15=
 10:59:27.000000000 +0200
> > > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c	2008-09-15 11:1=
2:16.000000000 +0200
> > > @@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_bloc
> > >  			    block_group, bitmap_blk);
> > >  		return NULL;
> > >  	}
> > > -	if (bh_uptodate_or_lock(bh))
> > > +	if (buffer_uptodate(bh) &&
> > > +	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
> > >  		return bh;
> > >=20
> > > +	lock_buffer(bh);
> > >  	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
> > >  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> > >  		ext4_init_inode_bitmap(sb, bh, block_group, desc);
> > > Index: linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/mballoc.c	2008-09-1=
5 10:59:27.000000000 +0200
> > > +++ linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c	2008-09-15 14:=
02:44.000000000 +0200
> > > @@ -785,9 +785,11 @@ static int ext4_mb_init_cache(struct pag
> > >  		if (bh[i] =3D=3D NULL)
> > >  			goto out;
> > >=20
> > > -		if (bh_uptodate_or_lock(bh[i]))
> > > +		if (buffer_uptodate(bh[i]) &&
> > > +		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
> > >  			continue;
> > >=20
> > > +		lock_buffer(bh[i]);
> > >  		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
> > >  		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> > >  			ext4_init_block_bitmap(sb, bh[i],
> > >=20
> >=20
> > -aneesh
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
