From: Andreas Dilger <adilger@sun.com>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Fri, 14 Nov 2008 01:30:00 -0700
Message-ID: <20081114082819.GM16005@webber.adilger.int>
References: <20081101151002.4ed9be99@zest> <20081101194617.0dc131c3@zest>
 <20081107211643.GB3184@webber.adilger.int> <20081111110910.4a6f7941@zest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Michael B. Trausch" <mike@trausch.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37477 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYKNIaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 03:30:19 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAE8U7cf018700
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2008 00:30:08 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAB00I01E5S7Y00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 14 Nov 2008 00:30:07 -0800 (PST)
In-reply-to: <20081111110910.4a6f7941@zest>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  11:09 -0500, Michael B. Trausch wrote:
> I do have an ltrace up and online at:
> 
>   http://fd0man.theunixplace.com/tune2fs.ltrace.bz2
> 
> The bzip2 file is 44 MB, and the uncompressed text is _huge_ (about 3
> GB).  This is a two hour run of "tune2fs -I 256 /dev/sdb" on an
> external 250 GB (235 GiB) drive formatted with the ext3 filesystem.
> I aborted the tune2fs run after 2 hours, though I am sure it would have
> run for far longer.  Hopefully, this will give some insight as to what
> the problem might be.

It looks like the code is just spending hours looking at the bitmaps,
but I have no idea why:

ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e1, 1, 0, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e2, 2, 1, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e3, 4, 2, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e4, 8, 3, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e5, 16, 4, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e6, 32, 5, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e7, 64, 6, 0x1f418b0) = 0
ext2fs_test_generic_bitmap(0x1f3d020, 0xfa31e8, 128, 7, 0x1f418b0) = 0


Possibly the code is very inefficient and is scanning every bit in
the bitmap individually to see if an inode is in use, instead of doing
something fast like just checking an entire bitmap word == 0 and
skipping it.

Unfortunately, ltrace doesn't show what is calling this code, so
a stack trace is needed from GDB.



Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

