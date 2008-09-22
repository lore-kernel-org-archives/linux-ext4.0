From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Mon, 22 Sep 2008 10:09:57 +0200
Message-ID: <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
	 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
	 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
	 <20080921004451.GA15402@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47627 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYIVIJE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 04:09:04 -0400
In-Reply-To: <20080921004451.GA15402@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le samedi 20 septembre 2008 =C3=A0 20:44 -0400, Theodore Tso a =C3=A9cr=
it :
> On Thu, Sep 18, 2008 at 03:45:14PM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=A9=
 wrote:
> > The issue here is that you can't use all inode of the second group =
of
> > the fs.
> >=20
> > This happens because resize2fs make a call to ext2fs_read_bitmaps. =
This
> > function reads all bitmaps while paying attention not to read the
> > uninited bitmap. This works well as long as the fs block size is eq=
ual
> > to the page size. But in the above test case, the fs use 1k blocks =
and
> > we have an issue.=20
> >=20
> > That's because the "read" function issued by ext2fs_read_bitmaps is=
 a
> > call to kernel's block_read_full_page function. So when a single bi=
tmap
> > block is asked for, 4 blocks (for 1k blocks fs on x86) are actually=
 read
> > (including the uninited ones) and their respective buffer set to
> > uptodate.=20
> >=20
> > As we rely on the buffer's uptodate flags to initialize or not this
> > buffer, it may happen that certain bitmap blocks are not initialize=
d at
> > all. So their buffer contains the random garbage that was present o=
n the
> > disk prior to the mkfs ( In the above test case, the inode bitmap o=
f the
> > second group is full a random bits so I can't use all of its inodes=
 ).
>=20
> Actually that's the problem.  We shouldn't be relying on the buffer's
> uptodate flags as a hint to tell mballoc to reload the buddy bitmaps.
> Unfortunately I didn't notice this problem by not carefully auditing
> commit 5f21b0e6 before it went in, but it's seriously buggy by trying
> to overload the use of the buffer's uptodate flag for anything other
> than error handling.
>=20

Maybe I missed something, but I thought the bug I am talking about here=
,
is neither related to buddy nor directly to mballoc. Sorry, I was not
clear enough. In fact, it happens even without using mballoc. It is
related to uninit feature with filesystems using blocks which are
smaller than page size. If any userland process call ext2fs_read_bitmap=
s
function (or try to read a bitmap block directly), you may end up with
those buffers full of garbage. It concerns either block bitmap buffers
or inode bitmap buffers.



> > I am a bit lost on how to fix this. Aneesh was right, I think it's =
an
> > ext2fs_read_bitmaps bug, not a kernel bug. I guess we need a userla=
nd
> > function to read a single block whatever the block size and page si=
ze
> > are. I've made a try using O_DIRECT flag but I was unsuccessful. An=
y
> > ideas/suggestions ?
>=20
> No!!!!  Think about it.  It's always fair for userspace to read from
> the block device.  If this causes the kernel to blow up, then it's a
> kernel bug, not a userspace bug.  And it is a *perfect* demonstration
> why overloading the uptodate flag by using it for *anything* other
> than error signalling from the buffer I/O layer is wrong and horribly
> fragile.

You are probably right, so maybe the patch I sent at the beginning of
this thread makes sense ?

>=20
> Commit 5f21b0e6 should have been split up into separate patches, so i=
t
> would have been easier to audit.  (I'm guessing though that I somehow
> never audited it, since my Signed-off-by wasn't on the patch, and it
> should have been before I pushed it to Linus).  As far as what it was
> trying to do, how this probably should have been solved is that
> mballoc.c should have a new function which causes the out-of-date
> buddy bitmap to be removed, and to have resize.c call that function,
> instead of playing games with the uptodate flag.

Thank you for your comments about this commit, I will give a look at it
later.




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
