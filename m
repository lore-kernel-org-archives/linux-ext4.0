From: "George Spelvin" <linux@horizon.com>
Subject: Re: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: 15 Nov 2012 10:38:33 -0500
Message-ID: <20121115153833.31569.qmail@science.horizon.com>
References: <20121112063208.16223.qmail@science.horizon.com>
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca, linux@horizon.com, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:41839 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767939Ab2KOPif (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 10:38:35 -0500
In-Reply-To: <20121112063208.16223.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just to follow up to this thread so that anyone searching archives
will know:  DO NOT DO THIS, IT IS BUGGY.  (As of today's mke2fs 1.43-WIP.)


Asking for preallocated space boils down to reserving space in the block
group descriptor table (both the primary and all backups) for the final
total number of block groups.

A block group is as many blocks as can be controlled by a 1-block
allocation bitmap.  So with 4K blocks, that's 32K blocks, or 128 MiB.

Each descriptor is 32 bytes (or 64 bytes for 64-bit), so the largest
possible 32-bit FS, of 2^32 blocks, requires 2^17 block groups, which
requires 2^22 bytes of block group descriptor table.  That's 2^10 =
1024 blocks of 2^12 = 4K size,

mke2fs keeps track of the reserved blocks by allocating them to a
special inode (#7), with each reserved area getting one indirect block,
since that corresponds to the maximum possible size.


But here's the bug!  It turns out that mke2fs *cannot* preallocate more
than 1024 blocks of block group descriptor table, so the maximum
growth is 16 TiB on 32-bit, or 8 TiB on 64-bit (where the descriptors
are twice as large).

(Note that this is the size *in addition to* the current size, not
the final total.)

For 32-bit file systems, this is of course not a problem.  The "1000x
default growth" documented in mke2fs really means that, if you create
a file system of 16 GiB or larger, it preallocates to the 16 TiB max.

However, when using a 64bit file syste, you can sensibly ask for more
preallocation.  But if you do, (as of today; I expect Ted will at least
make it fail in future) mke2fs silently truncates the request to the
maximum it can supply.


Now, I was trying to reallocate from 10 TB to 22 TB, a 12 TB increase,
which is above the 8 TiB limit.

It turns out that there's a second bug in resize2fs which notices the
preallocated space and tries to use it, but when it's not big enough,
it does things wrong and destroys some inodes.  (if flex_bg is also
enabled, which is always is for ext4).


I expect these all to get fixed fairly soon, but please, nobody else have
my data-loss experience.
