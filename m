From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: add make_hugefile feature
Date: Tue, 21 Jan 2014 16:39:43 -0500
Message-ID: <20140121213943.GE31769@thunk.org>
References: <1390285023-23133-1-git-send-email-tytso@mit.edu>
 <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50528 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbaAUVjr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jan 2014 16:39:47 -0500
Content-Disposition: inline
In-Reply-To: <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:45:17AM -0700, Andreas Dilger wrote:
> > Then "mke2fs -T hugefile /dev/sdXX" will create as many 1G files
> > needed to fill the file system.
> 
> How is this different from using fallocate to allocate the files?

There are a couple of differences.  One is that currently using
fallocate to allocate the file results in an embarassingly bad extent
tree:

 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    2047:      34816..     36863:   2048:             unwritten
   1:     2048..    4095:      36864..     38911:   2048:             unwritten
   2:     4096..    6143:      38912..     40959:   2048:             unwritten
   3:     6144..    8191:      40960..     43007:   2048:             unwritten
   4:     8192..   10239:      43008..     45055:   2048:             unwritten
   5:    10240..   12287:      45056..     47103:   2048:             unwritten
   6:    12288..   14335:      47104..     49151:   2048:             unwritten
....

(This we came from running "fallocate -o 0 -l 512M /mnt/foo" on a
freshly formatted file system, running Linux 3.12.)

Compare and contrast that with "mke2fs -T hugefile /tmp/foo.img 1G"
creates:

 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   32767:      24904..     57671:  32768:            
   1:    32768..   65535:      57672..     90439:  32768:            
   2:    65536..   98303:      90440..    123207:  32768:            
   3:    98304..  131071:     123208..    155975:  32768:            

This is a bug in how fallocate and mballoc are working together that
we should fix, of course. :-) And come to think of it, I'm really
surprised that the extent merging code isn't papering over the fact
that mballoc is only handing back block allocations 2048 blocks at a
time.


The other difference is the obvious one from the filefrag output,
which is the data blocks are marked as initialized, instead of
unwritten.  Yes, this brings up the whole controversy over the
NO_HIDE_STALE flag, but if you are creating the fresh file system, the
security issues hopefully not as severe --- and I will eventually add
support for zero'ing the files, or using discard to zero the data
blocks, even if at work we really don't care about this because we
trust the userspace programs that would be using these huge files.


Finally, to help eventually support eventual userspace SMR aware
applicaitons, one reason why it's useful to have mke2fs support
creating the huge file is that it's much easier to make sure the file
is appropriate aligned to begin at an SMR zone boundary.  This is not
something we currently have any kernel/userspace interfaces to do, in
terms of telling fallocate that you want to constrain the starting
block number for the data blocks that you are asking it to
fallocate(2) for you.


> Is this just to create a test image for e2fsck or similar?

It is certainly useful for that, but the mk_hugefiles feature is one
that I expect we would be using on production systems.

It is definitely the case that writing this code has exposed all sorts
of interesting bugs and performance shortcomings in libext2fs and
e2fsprogs in general, so just creating this functionality as part of
mke2fs it was certainly a useful exercise in and of itself.  :-)

>  It might make sense to include f_hugefiles/script and expect.1 for it?

Oh, certainly.  This patch was much more of an RFC than anything else.
And as I said, I'm still trying to figure out whether or not it makes
sense to push this code upstream, or leave it as a Google internal
enhancement.

To the extent that we might want to support an SMR-aware SQLite or
MySQL or PostgreSQL, and where we want to make sure the hugefile is
properly aligned with a zone boundary, that's probably one of the
stronger arguments for making this feature go upstream.

Cheers,

					- Ted
