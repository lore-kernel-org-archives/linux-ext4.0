From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bad performance of ext4 with kernel 3.0.17
Date: Thu, 1 Mar 2012 21:45:31 -0500
Message-ID: <20120302024531.GJ32588@thunk.org>
References: <CACaf2aaqxM86DtdZMaaQZfrC+WbLwPjOVd=LmVjk+TvfObYUzQ@mail.gmail.com>
 <20120301194735.GD32588@thunk.org>
 <CACaf2aacsH-hd9YmXff+DX8qiDjNGeUv6kNe9JamPH6OpaN1Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 development <linux-ext4@vger.kernel.org>
To: Xupeng Yun <xupeng@xupeng.me>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33456 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab2CBCpe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 21:45:34 -0500
Content-Disposition: inline
In-Reply-To: <CACaf2aacsH-hd9YmXff+DX8qiDjNGeUv6kNe9JamPH6OpaN1Sw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm, it sounds like we're hitting some kind of scaling problem.  How
many CPU's/cores do you have on your server?  And it would be
interesting to try varying the --numjobs parameter and see how the
various file systems behave with 1, 2, 4, 8, and 16 threads.

The other thing that's worth checking is to try using filefrag -v on
the test file after the benchmark has finished, just to make sure the
file layout is sane.  It should be, but I just want to double check...

          	       	      	 	- Ted

On Fri, Mar 02, 2012 at 08:50:55AM +0800, Xupeng Yun wrote:
> On Fri, Mar 2, 2012 at 03:47, Ted Ts'o <tytso@mit.edu> wrote:
> > Two things I'd try:
> >
> > #1) If this is a freshly created file system, the kernel may be
> > initializing the inode table in the background, and this could be
> > interfering with your benchmark workload. =A0To address this, you c=
an
> > either (a) add the mount option noinititable, (b) add the mke2fs
> > option "-E lazy_itable_init=3D0" --- but this will cause the mke2fs=
 to
> > take a lot longer, or (c) mount the file system and wait until
> > "dumpe2fs /dev/md3 | tail" shows that the last block group has the
> > ITABLE_ZEROED flag set. =A0For benchmarking purposes on a scratch
> > workload, option (a) above is the fast thing to do.
> >
>=20
> Thank you Ted, I followed this and got the same result (read IOPS ~95=
0
> / write IOPS ~100)
>=20
> > #2) It could be that the file system is choosing blocks farther awa=
y
> > from the beginning of the disk, which is slower, whereas the fio on
> > the raw disk will use the blocks closest to the beginning of the di=
sk,
> > which are the fastest one. =A0You could try creating the file syste=
m so
> > it is only 10GB, and then try running fio on that small, truncated
> > file system, and see if that makes a difference.
>=20
> I created LVM on top of the RAID10 device, and then created a smaller=
 LV(20GB),
> after that I took benchmarks against the very same LV with different
> filesystems, the
> results are interesting:
>=20
> xfs (read IOPS ~1700 / write IOPS ~200)
> ext4 (read IOPS ~950 / write IOPS ~100)
> ext3( read IOPS ~900 / write IOPS ~100)
> reisferfs (read IOPS ~930 / write IOPS ~100)
> btrfs (read IOPS ~1200 / write IOPS ~120)
>=20
> I got very bad performance from XFS
> (http://www.spinics.net/lists/xfs/msg08688.html) about
> two months ago, which was caused by known bugs of XFS, then I tried
> ext4 on some of
> my servers, it works very well until I got a new server set up with s=
oft RAID10.
>=20
> What should I learn to understand what's happening? any suggestion is
> appreciated.
>=20
> --=20
> Xupeng Yun
> http://about.me/xupeng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
