From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Mon, 22 Sep 2008 11:32:40 +0200
Message-ID: <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
	 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
	 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
	 <20080921004451.GA15402@mit.edu>
	 <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
	 <20080922084721.GA6691@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36250 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIVJbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 05:31:42 -0400
In-Reply-To: <20080922084721.GA6691@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le lundi 22 septembre 2008 =C3=A0 14:17 +0530, Aneesh Kumar K.V a =C3=A9=
crit :
> On Mon, Sep 22, 2008 at 10:09:57AM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=A9=
 wrote:
> > Le samedi 20 septembre 2008 =C3=A0 20:44 -0400, Theodore Tso a =C3=A9=
crit :
> > > On Thu, Sep 18, 2008 at 03:45:14PM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=
=A9 wrote:
> > > > The issue here is that you can't use all inode of the second gr=
oup of
> > > > the fs.
> > > >=20
> > > > This happens because resize2fs make a call to ext2fs_read_bitma=
ps. This
> > > > function reads all bitmaps while paying attention not to read t=
he
> > > > uninited bitmap. This works well as long as the fs block size i=
s equal
> > > > to the page size. But in the above test case, the fs use 1k blo=
cks and
> > > > we have an issue.=20
> > > >=20
> > > > That's because the "read" function issued by ext2fs_read_bitmap=
s is a
> > > > call to kernel's block_read_full_page function. So when a singl=
e bitmap
> > > > block is asked for, 4 blocks (for 1k blocks fs on x86) are actu=
ally read
> > > > (including the uninited ones) and their respective buffer set t=
o
> > > > uptodate.=20
> > > >=20
> > > > As we rely on the buffer's uptodate flags to initialize or not =
this
> > > > buffer, it may happen that certain bitmap blocks are not initia=
lized at
> > > > all. So their buffer contains the random garbage that was prese=
nt on the
> > > > disk prior to the mkfs ( In the above test case, the inode bitm=
ap of the
> > > > second group is full a random bits so I can't use all of its in=
odes ).
> > >=20
> > > Actually that's the problem.  We shouldn't be relying on the buff=
er's
> > > uptodate flags as a hint to tell mballoc to reload the buddy bitm=
aps.
> > > Unfortunately I didn't notice this problem by not carefully audit=
ing
> > > commit 5f21b0e6 before it went in, but it's seriously buggy by tr=
ying
> > > to overload the use of the buffer's uptodate flag for anything ot=
her
> > > than error handling.
> > >=20
> >=20
> > Maybe I missed something, but I thought the bug I am talking about =
here,
> > is neither related to buddy nor directly to mballoc. Sorry, I was n=
ot
> > clear enough. In fact, it happens even without using mballoc. It is
> > related to uninit feature with filesystems using blocks which are
> > smaller than page size. If any userland process call ext2fs_read_bi=
tmaps
> > function (or try to read a bitmap block directly), you may end up w=
ith
> > those buffers full of garbage. It concerns either block bitmap buff=
ers
> > or inode bitmap buffers.
> >=20
> >=20
> >=20
> > > > I am a bit lost on how to fix this. Aneesh was right, I think i=
t's an
> > > > ext2fs_read_bitmaps bug, not a kernel bug. I guess we need a us=
erland
> > > > function to read a single block whatever the block size and pag=
e size
> > > > are. I've made a try using O_DIRECT flag but I was unsuccessful=
=2E Any
> > > > ideas/suggestions ?
> > >=20
> > > No!!!!  Think about it.  It's always fair for userspace to read f=
rom
> > > the block device.  If this causes the kernel to blow up, then it'=
s a
> > > kernel bug, not a userspace bug.  And it is a *perfect* demonstra=
tion
> > > why overloading the uptodate flag by using it for *anything* othe=
r
> > > than error signalling from the buffer I/O layer is wrong and horr=
ibly
> > > fragile.
> >=20
> > You are probably right, so maybe the patch I sent at the beginning =
of
> > this thread makes sense ?
> >=20
>=20
> What you can do is make ext4_group_info generic for both mballoc and
> oldalloc. We can then add bg_flag to the in memory ext4_group_info
> that would indicate whether the group is initialized or not. Here
> initialized for an UNINIT_GROUP indicate we have done
> ext4_init_block_bitmap on the buffer_head. Then=20
> instead of depending on the buffer_head uptodate flag we can check
> for the ext4_group_info bg_flags and decided whether the block/inode
> bitmap need to be initialized.
>=20

That makes sense ! I agree with you, we need an additional in-memory
flag to know whether buffers are initialized or not. Anyway, making
ext4_group_info generic will lead to unneeded memory consumption for
oldalloc. Maybe a simple independent bits array could do the trick. Is
there any advantage to re-use ext4_group_info ?




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
