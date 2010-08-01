From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and
 later
Date: Sun, 1 Aug 2010 19:02:25 -0400
Message-ID: <20100801230225.GC27573@thunk.org>
References: <4C508A54.7070002@uni-konstanz.de>
 <20100730022055.GL4506@thunk.org>
 <4C533DB0.5020608@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35833 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0HAXC1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Aug 2010 19:02:27 -0400
Content-Disposition: inline
In-Reply-To: <4C533DB0.5020608@uni-konstanz.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 30, 2010 at 11:01:36PM +0200, Kay Diederichs wrote:
> whereas for 2.6.32.16 the result is typically
> Filesystem type is: ef53
> File size of
> /mnt/md5/scratch/nfs-test/tmp/xds/frames/h2g28_1_00000.cbf is
> 6229688 (1521 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0 826376200            1521 eof
> /mnt/md5/scratch/nfs-test/tmp/xds/frames/h2g28_1_00000.cbf: 1 extent found

OK, so 2.6.32 is actually doing a better job laying out the files....

The blktrace will be interesting, but at this point I'm wondering if
this is a generic kernel-wide writeback regression.  At $WORK we've
noticed some performance regressions between 2.6.26-based kernels and
2.6.33- and 2.6.34-based kernels with both ext2 and ext4 (in no
journal mode) that we've been trying to track down.  We have a pretty
large number of patches applied to both 2.6.26 and 2.6.33/34 which is
why I haven't mentioned it up until now, but at this point it seems
pretty clear there are some writeback issues in the mainline kernel.

There are half a dozen or so patch series on LKML that are addressing
writeback in one way or another, and writeback is a major topic at the
upcoming Linux Storage and Filesystem workshop.  So if this is the
cause, hopefully there will be some improvements in this area in the
near future.

						- Ted
