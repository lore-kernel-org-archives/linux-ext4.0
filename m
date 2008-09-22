From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Mon, 22 Sep 2008 14:17:21 +0530
Message-ID: <20080922084721.GA6691@skywalker>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr> <1221481007.6733.32.camel@frecb007923.frec.bull.fr> <20080915133604.GA6548@skywalker> <1221489026.6733.36.camel@frecb007923.frec.bull.fr> <1221745514.3550.83.camel@frecb007923.frec.bull.fr> <20080921004451.GA15402@mit.edu> <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51721 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYIVIvf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 04:51:35 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m8M8nvtA012446
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 18:49:57 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8M8mOva114864
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 18:48:25 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8M8mLoQ025903
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 18:48:22 +1000
Content-Disposition: inline
In-Reply-To: <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 22, 2008 at 10:09:57AM +0200, Fr=E9d=E9ric Boh=E9 wrote:
> Le samedi 20 septembre 2008 =E0 20:44 -0400, Theodore Tso a =E9crit :
> > On Thu, Sep 18, 2008 at 03:45:14PM +0200, Fr=E9d=E9ric Boh=E9 wrote=
:
> > > The issue here is that you can't use all inode of the second grou=
p of
> > > the fs.
> > >=20
> > > This happens because resize2fs make a call to ext2fs_read_bitmaps=
=2E This
> > > function reads all bitmaps while paying attention not to read the
> > > uninited bitmap. This works well as long as the fs block size is =
equal
> > > to the page size. But in the above test case, the fs use 1k block=
s and
> > > we have an issue.=20
> > >=20
> > > That's because the "read" function issued by ext2fs_read_bitmaps =
is a
> > > call to kernel's block_read_full_page function. So when a single =
bitmap
> > > block is asked for, 4 blocks (for 1k blocks fs on x86) are actual=
ly read
> > > (including the uninited ones) and their respective buffer set to
> > > uptodate.=20
> > >=20
> > > As we rely on the buffer's uptodate flags to initialize or not th=
is
> > > buffer, it may happen that certain bitmap blocks are not initiali=
zed at
> > > all. So their buffer contains the random garbage that was present=
 on the
> > > disk prior to the mkfs ( In the above test case, the inode bitmap=
 of the
> > > second group is full a random bits so I can't use all of its inod=
es ).
> >=20
> > Actually that's the problem.  We shouldn't be relying on the buffer=
's
> > uptodate flags as a hint to tell mballoc to reload the buddy bitmap=
s.
> > Unfortunately I didn't notice this problem by not carefully auditin=
g
> > commit 5f21b0e6 before it went in, but it's seriously buggy by tryi=
ng
> > to overload the use of the buffer's uptodate flag for anything othe=
r
> > than error handling.
> >=20
>=20
> Maybe I missed something, but I thought the bug I am talking about he=
re,
> is neither related to buddy nor directly to mballoc. Sorry, I was not
> clear enough. In fact, it happens even without using mballoc. It is
> related to uninit feature with filesystems using blocks which are
> smaller than page size. If any userland process call ext2fs_read_bitm=
aps
> function (or try to read a bitmap block directly), you may end up wit=
h
> those buffers full of garbage. It concerns either block bitmap buffer=
s
> or inode bitmap buffers.
>=20
>=20
>=20
> > > I am a bit lost on how to fix this. Aneesh was right, I think it'=
s an
> > > ext2fs_read_bitmaps bug, not a kernel bug. I guess we need a user=
land
> > > function to read a single block whatever the block size and page =
size
> > > are. I've made a try using O_DIRECT flag but I was unsuccessful. =
Any
> > > ideas/suggestions ?
> >=20
> > No!!!!  Think about it.  It's always fair for userspace to read fro=
m
> > the block device.  If this causes the kernel to blow up, then it's =
a
> > kernel bug, not a userspace bug.  And it is a *perfect* demonstrati=
on
> > why overloading the uptodate flag by using it for *anything* other
> > than error signalling from the buffer I/O layer is wrong and horrib=
ly
> > fragile.
>=20
> You are probably right, so maybe the patch I sent at the beginning of
> this thread makes sense ?
>=20

What you can do is make ext4_group_info generic for both mballoc and
oldalloc. We can then add bg_flag to the in memory ext4_group_info
that would indicate whether the group is initialized or not. Here
initialized for an UNINIT_GROUP indicate we have done
ext4_init_block_bitmap on the buffer_head. Then=20
instead of depending on the buffer_head uptodate flag we can check
for the ext4_group_info bg_flags and decided whether the block/inode
bitmap need to be initialized.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
