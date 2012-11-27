From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Date: Tue, 27 Nov 2012 14:14:38 +1100
Message-ID: <20121127031438.GK6434@dastard>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
 <alpine.LFD.2.00.1211261442490.18234@localhost>
 <20121126145559.GK31891@thunk.org>
 <CAPxxNQmgOmEzkmzL7Tei4KAxaP49yx1fmhNgxvwaFNiYVosGtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Ryan Wang <openspace.wang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28812 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755614Ab2K0DOl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 22:14:41 -0500
Content-Disposition: inline
In-Reply-To: <CAPxxNQmgOmEzkmzL7Tei4KAxaP49yx1fmhNgxvwaFNiYVosGtA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 09:20:47AM +0800, Ryan Wang wrote:
> 2012/11/26 Theodore Ts'o <tytso@mit.edu>:
> > On Mon, Nov 26, 2012 at 02:43:40PM +0100, Luk=C3=A1=C5=A1 Czerner w=
rote:
> >> > The I checked the script common.rc, and found that it uses
> >> > df to determine the filesystem type and it uses the realpath
> >> > "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> >> > shows "devtmpfs" instead of "ext4" for /dev/dm-0.
> >> >
> >> > I run "mount" and found that devtmpfs is mount on /dev/ on opens=
use
> >> > ***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /=
somedir",
> >> > df still showed devtmpfs.
> >> >
> >> > Any ideas to kick off the xfstests?
> >
> > At least with the df which ships with Debian Testing, df will displ=
ay
> > the file system in use if it matches the device name which is
> > /etc/mtab.  It looks the issue is that mount is canonicalizing the
> > device name to be the human friendly version:
> >
> > # ls -l /dev/mapper/closure-bigscratch
> > 0 lrwxrwxrwx 1 root root 7 Nov 16 15:15 /dev/mapper/closure-bigscra=
tch -> ../dm-7
> > <tytso.root@closure> {/home/tytso/bin}, level 2
> > # mount /dev/dm-7 /u2
> > # df /u2
> > Filesystem                     1K-blocks   Used Available Use% Moun=
ted on
> > /dev/mapper/closure-bigscratch  52403200 224772  52178428   1% /u2
> > # grep /u2 /etc/mtab
> > /dev/mapper/closure-bigscratch /u2 xfs rw,relatime,attr2,inode64,no=
quota 0 0
> >
> > So the simplest solution is to just use /dev/mapper/mpatha instead =
of
> > insisting on using /dev/dm-0.  That's what I do....
>=20
> In xfstests/common.rc, it will use realpath to obtain /dev/dm-0, even=
 if you
> specified /dev/mapper/mpatha.
> My problem is in SuSE, the devtmpfs is mounted on /dev by default, se=
ems
> used by udev. And df reports devtmpfs on /dev/dm-0, instead of ext4.

What version of xfstests are you using? Do you have a
"README.device-mapper" file in the base directory? If not, upgrade
to the latest version and retry.

$ gl -n 1 -p 0a81886
commit 0a818862bb74932e15971ec8bedb55765ec3a3f6
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed May 4 16:28:32 2011 +0200

    xfstests: support post-udev device mapper nodes

    Because of udevs complaining device mapper now creates /dev/dm-N as=
 the real
    device nodes, and just symlinks the /dev/mapper/ names to it.  This=
 would be
    easy if everything used the /dev/mapper clear names, but most syste=
m utilities
    translate them back to the /dev/mapper/ names and thus confuse vari=
ous test
    cases.  Add support to _is_block_dev to read symlinks, and add docu=
mentation
    on how to run xfstests on device mapper volumes.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Alex Elder <aelder@sgi.com>

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
