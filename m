From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Thu, 24 Feb 2011 11:04:55 +1100
Message-ID: <20110224000455.GN3166@dastard>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
 <4D6538C6.4090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34460 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1BXAE6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 19:04:58 -0500
Content-Disposition: inline
In-Reply-To: <4D6538C6.4090004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 10:41:42AM -0600, Eric Sandeen wrote:
> On 2/23/11 9:59 AM, Yongqiang Yang wrote:
> > 1] Delayed extents after a hole are neglected.
> >=20
> >    By using find_get_pages() instead of find_get_page() to
> >    lookup pagecache, delayed extents can be found, because
> >    find_get_pages() with nr_pages=3D1 will return the next page
> >    in pagecache.
> >=20
> > 2] Extents after a delayed extent or a hole are neglected as well.
> >=20
> >    Fix it by accurating the request range by the result of
> >    ext4_ext_next_allocated_block().
> >=20
> > Reported by Chris Mason <chris.mason@oracle.com>:
> > We've had reports on btrfs that cp is giving us files full of zeros
> > instead of actually copying them.  It was tracked down to a bug wit=
h
> > the btrfs fiemap implementation where it was returning holes for
> > delalloc ranges.
> >=20
> > Newer versions of cp are trusting fiemap to tell it where the holes
> > are, which does seem like a pretty neat trick.
> >=20
> > I decided to give xfs and ext4 a shot with a few tests cases too, x=
fs
> > passed with all the ones btrfs was getting wrong, and ext4 got the =
basic
> > delalloc case right.
> > $ mkfs.ext4 /dev/xxx
> > $ mount /dev/xxx /mnt
> > $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1
> > $ fiemap-test foo
> > ext:   0 logical: [       0..     255] phys:        0..     255=20
> > flags: 0x007 tot: 256
> >=20
> > Horray!  But once we throw a hole in, things go bad:
> > $ mkfs.ext4 /dev/xxx
> > $ mount /dev/xxx /mnt
> > $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D1
> > $ fiemap-test foo
> > < no output >
> >=20
> > We've got a delalloc extent after the hole and ext4 fiemap didn't f=
ind
> > it.  If I run sync to kick the delalloc out:
> > $sync
> > $ fiemap-test foo
> > ext:   0 logical: [     256..     511] phys:    34048..   34303=20
> > flags: 0x001 tot: 256
> >=20
> > fiemap-test is sitting in my /usr/local/bin, and I have no idea how=
 it
> > got there.  It's full of pretty comments so I know it isn't mine, b=
ut
> > you can grab it here:
> >=20
> > http://oss.oracle.com/~mason/fiemap-test.c
> >=20
> > xfsqa has a fiemap program too.
=2E....
> I think this will fall down if you have:
>=20
> [ HOLE ][ DELALLOC ][ HOLE ][ ALLOCATED ] won't it?
>=20
> i.e. your "end" will be the first block of "allocated" right?

This sound sort of problem indicate=D1=95 to me that we need a generic
fiemap test in xfstests that exercises all these corner cases.
Perhaps something similar to the way I tested all the
XFS_IOC_ZERO_RANGE corner cases in test 242 by setting up all the
different hole/delalloc/unwritten/allocated combinations using
xfs_io and used the fiemap output as the golden output?

That would catch all of these problems in the different filesystems
that implement fiemap and make sure we notice regressions pretty
quickly.....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
