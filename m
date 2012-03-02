From: Xupeng Yun <xupeng@xupeng.me>
Subject: Re: Bad performance of ext4 with kernel 3.0.17
Date: Fri, 2 Mar 2012 08:50:55 +0800
Message-ID: <CACaf2aacsH-hd9YmXff+DX8qiDjNGeUv6kNe9JamPH6OpaN1Sw@mail.gmail.com>
References: <CACaf2aaqxM86DtdZMaaQZfrC+WbLwPjOVd=LmVjk+TvfObYUzQ@mail.gmail.com>
 <20120301194735.GD32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2CBAvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 19:51:36 -0500
Received: by iagz16 with SMTP id z16so1570322iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Mar 2012 16:51:36 -0800 (PST)
In-Reply-To: <20120301194735.GD32588@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 2, 2012 at 03:47, Ted Ts'o <tytso@mit.edu> wrote:
> Two things I'd try:
>
> #1) If this is a freshly created file system, the kernel may be
> initializing the inode table in the background, and this could be
> interfering with your benchmark workload. =C2=A0To address this, you =
can
> either (a) add the mount option noinititable, (b) add the mke2fs
> option "-E lazy_itable_init=3D0" --- but this will cause the mke2fs t=
o
> take a lot longer, or (c) mount the file system and wait until
> "dumpe2fs /dev/md3 | tail" shows that the last block group has the
> ITABLE_ZEROED flag set. =C2=A0For benchmarking purposes on a scratch
> workload, option (a) above is the fast thing to do.
>

Thank you Ted, I followed this and got the same result (read IOPS ~950
/ write IOPS ~100)

> #2) It could be that the file system is choosing blocks farther away
> from the beginning of the disk, which is slower, whereas the fio on
> the raw disk will use the blocks closest to the beginning of the disk=
,
> which are the fastest one. =C2=A0You could try creating the file syst=
em so
> it is only 10GB, and then try running fio on that small, truncated
> file system, and see if that makes a difference.

I created LVM on top of the RAID10 device, and then created a smaller L=
V(20GB),
after that I took benchmarks against the very same LV with different
filesystems, the
results are interesting:

xfs (read IOPS ~1700 / write IOPS ~200)
ext4 (read IOPS ~950 / write IOPS ~100)
ext3( read IOPS ~900 / write IOPS ~100)
reisferfs (read IOPS ~930 / write IOPS ~100)
btrfs (read IOPS ~1200 / write IOPS ~120)

I got very bad performance from XFS
(http://www.spinics.net/lists/xfs/msg08688.html) about
two months ago, which was caused by known bugs of XFS, then I tried
ext4 on some of
my servers, it works very well until I got a new server set up with sof=
t RAID10.

What should I learn to understand what's happening? any suggestion is
appreciated.

--=20
Xupeng Yun
http://about.me/xupeng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
