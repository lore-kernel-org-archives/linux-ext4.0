From: Andreas Dilger <adilger@sun.com>
Subject: Re: >16TB issues
Date: Fri, 03 Jul 2009 16:38:13 +0200
Message-ID: <20090703143729.GJ20343@webber.adilger.int>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52649 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGCOia (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jul 2009 10:38:30 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n63EcHIv010677
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jul 2009 07:38:32 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KM700500N6E4Z00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 03 Jul 2009 07:38:17 -0700 (PDT)
In-reply-to: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 02, 2009  15:23 -0700, Justin Maggard wrote:
> I've been toying with ext4 and e2fsprogs pu branch (pulled from git
> yesterday) on very large volumes, and I've run into some issues.  What
> I've found so far with an 19TB MD RAID0 volume, running 2.6.29.4 (I'm
> planning on trying 2.6.30 soon):
> 
> -  mkfs.ext4 *appears* to work fine, reporting no errors.  Examining
> the superblock info with dumpe2fs -h looks normal -- although I'm
> unfamiliar with "Lifetime writes" field, and I'm not sure why it's at
> 73GB immediately after doing mkfs, before ever mount it.
> 
> -  Immediately running e2fsck on the volume before ever mounting it
> will not complete, and results in the following:
> # e2fsck -n /dev/md2
> e2fsck 1.41.7 (29-June-2009)
> Error reading block 2435874816 (Attempt to read block from filesystem
> resulted in short read).  Ignore error? no
> /dev/md2: Attempt to read block from filesystem resulted in short read
> while reading block 2435874816
> /dev/md2: Attempt to read block from filesystem resulted in short read
> reading journal superblock
> e2fsck: Attempt to read block from filesystem resulted in short read
> while checking ext3 journal for /dev/md2

It looks like there may be some problem with the underlying device?
I posted a program here a few months ago called "ll_ver_dev" which
can quickly (or slowly) verify that writes and reads to different
offsets in a block device return consistent data.  The quick version
will detect such problems as 32-bit overflows, but if you are having
strange problems you might need to run the full version.

You could also try running with a filesystem just under 16TB and
verifying that works.

> -  Mounting with -o noload does appear to work, and reading and
> writing seems to work fine.

That's because the journal is not being used, which is what seems to
be having the problem.  I wonder if the journal is beyond 8TB or
beyond 16TB for some reason and this is causing grief?

> -  Setting default mount options with tune2fs works fine, as expected.
> 
> -  Then, I went on to check out filesystem resizing.  I created an LVM
> 15TB LV, and ran mkfs.ext4 on it.  Looking at the superblock info, it
> did not contain the 64bit flag, which I assume is expected behavior.
> I extended the LV to ~18TB and tried resize2fs, and got this error:
> resize2fs: Can't read an block bitmap while trying to resize /dev/data/data0

This is known not to work, AFAIR.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

