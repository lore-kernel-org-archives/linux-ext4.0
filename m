From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] libext2fs: fix inode cache overruns
Date: Thu, 29 Nov 2012 18:14:13 -0500
Message-ID: <20121129231413.GA26246@wallace>
References: <20121117183745.GA8489@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60420 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2K2XOT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2012 18:14:19 -0500
Received: by mail-gh0-f174.google.com with SMTP id g15so2626173ghb.19
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2012 15:14:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121117183745.GA8489@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Whitney <enwlinux@gmail.com>:
> 
> An inode cache slot will be overrun if a caller to ext2fs_read_inode_full()
> or ext2fs_write_inode_full() attempts to read or write a full sized 156
> byte inode when the target filesystem contains 128 byte inodes.  Limit the
> copied inode to the smaller of the target filesystem's or the caller's
> requested inode size.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  lib/ext2fs/inode.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> index 0ea210e..e47d664 100644
> --- a/lib/ext2fs/inode.c
> +++ b/lib/ext2fs/inode.c
> @@ -582,7 +582,8 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
>  	/* Check to see if it's in the inode cache */
>  	for (i = 0; i < fs->icache->cache_size; i++) {
>  		if (fs->icache->cache[i].ino == ino) {
> -			memcpy(inode, fs->icache->cache[i].inode, bufsize);
> +			memcpy(inode, fs->icache->cache[i].inode,
> +			       (bufsize > length) ? length : bufsize);
>  			return 0;
>  		}
>  	}
> @@ -649,7 +650,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
>  	/* Update the inode cache bookkeeping */
>  	fs->icache->cache_last = cache_slot;
>  	fs->icache->cache[cache_slot].ino = ino;
> -	memcpy(inode, iptr, bufsize);
> +	memcpy(inode, iptr, (bufsize > length) ? length : bufsize);
>  
>  	return 0;
>  }
> @@ -705,7 +706,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
>  		for (i=0; i < fs->icache->cache_size; i++) {
>  			if (fs->icache->cache[i].ino == ino) {
>  				memcpy(fs->icache->cache[i].inode, inode,
> -				       bufsize);
> +				       (bufsize > length) ? length : bufsize);
>  				break;
>  			}
>  		}
> -- 
> 1.7.10.4
> 

Ted:

Here's some additional background for this patch for a regression
introduced in e2fsprogs commit 91db7e206d as found in 1.43-WIP
(master branch).

e2fsprog's f_dup4 test fails when run on a Pandaboard installed with
Ubuntu 12.10 Server and running custom 3.7-rc* kernels.  glibc detects
a heap problem and emits this message:

*** glibc detected *** ../debugfs/debugfs: double free or corruption (out):
 0x0004b6f8 ***

This happens at the beginning of the f_dup4 test in debugfs, which is
used to modify/prepare a test filesystem for subsequent fsck'ing (object
of the test) - the failure occurs after debugfs has made some but not all
of the mods, and then causes debugfs to abort.  The test script doesn't
check for trouble, so fsck then proceeds to run (successfully) on a
partially-modified filesystem.  The resulting fsck output does not match
the output expected for a fully-modified filesystem, and the test fails.

The root cause is the inode cache is being overrun.  The test filesystem
contains 128 byte inodes, so the inode cache is allocated with 128 byte
inodes.  However, debugfs's do_set_inode() passes a bufsize of
sizeof(ext2_inode_large) - 156 bytes - down to ext2fs_{read|write}_inode_full.
Since the bufsize is used to determine how much data to read from or write
to the inode cache, we get overruns.

f_dup4 does not fail when run on an x86_64 test system, even though the 
test filesystem still contains 128 byte inodes.  glibc does not detect an
error, debugfs runs to completion, and the fsck output is as expected.
However, if f_dup4 is run with --valgrind after modifying the f_dup4
script to capture the debugfs output rather than direct it to /dev/null,
valgrind reports inode cache overruns (same is true on the Pandaboard).

Interestingly, f_dup4 does fail when run on a 32 bit x86 system - glibc
detects and reports the heap problem and forces debugfs to abort in a
manner identical to that seen on the Pandaboard.  So, we see failures
on the 32 bit systems but not on the 64 bit.  It's not yet clear to me
why glibc isn't catching the overruns on x86_64, but that's what's behind
my reports of different f_dup4 test behavior in recent ext4 concalls.

Thanks,
Eric

