From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: Commit 94968e74 breaks f_lotsbad
Date: Mon, 27 Jun 2011 23:16:14 -0600
Message-ID: <574FA1C6-62AF-4AF0-B43C-415923D63BB1@whamcloud.com>
References: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com> <20110620015801.GB32133@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1F1FQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 01:16:18 -0400
Received: by pwj7 with SMTP id 7so3355401pwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 22:16:17 -0700 (PDT)
In-Reply-To: <20110620015801.GB32133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-19, at 7:58 PM, Ted Ts'o wrote:
> On Fri, Jun 17, 2011 at 12:28:01AM -0600, Andreas Dilger wrote:
>> 
>> I was going to send some more fixes, but it looks like your commit
>> 94968e74 "libext2fs: teach bitmap functions about bigalloc/cluster"
>> breaks the "f_lotsbad" test, which I found via git bisect and verified
>> is the offending commit:
> 
> The problem was a bug in lib/ext2fs/Makefile.in; the $(SRCS) macro
> included "$(srcdir)/blkmap64_ba.o" (note ".o" instead of ".o"; Oops.)
> 
> As a result we didn't have a dependency for blkmap64_ba.c in the
> Makefile, and so blkmap64_ba.o wasn't getting regenerated when
> bmap64.h changed.  You can fix it by rm'ing blkmap64_ba.o and then
> rebuilding.  I'll fixed the Makefile.in, rerun "make depend", and then
> check in a fix.

I retested after pulling your commit 1ca87790b914a1958f3cbd8b5e1e7037f2cf30ed
"libext2fs: fix makefile dependency problem", but even when I do "make clean"
before each test I still get a failure on the "f_lotsbad" test:

--- ./f_lotsbad/expect.1        2011-06-01 20:25:00.871615457 +0000
+++ f_lotsbad.1.log     2011-06-28 05:09:16.484198659 +0000
@@ -26,6 +26,7 @@
 
 Restarting e2fsck from the beginning...
 Pass 1: Checking inodes, blocks, and sizes
+Illegal block number passed to ext2fs_test_block_bitmap #0 for in-use block map
 Pass 2: Checking directory structure
 Entry 'termcap' in / (2) has deleted/unused inode 12.  Clear? yes

I verified that no "*.o" files remained before rebuilding, but it didn't
fix the problem.  I also tested on both the "maint" and "next" branches
in case they were different, but it failed on both.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



