From: Theodore Tso <tytso@mit.edu>
Subject: Re: Performance of ext4
Date: Wed, 11 Jun 2008 09:54:43 -0400
Message-ID: <20080611135443.GK8397@mit.edu>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754734AbYFKNzM@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 11, 2008 at 08:02:32AM +0000, Holger Kiehl wrote:
>
> Doing some performance test between ext3 and ext4 I noticed that ext4
> is not much faster or in some cases slower then ext3. Two years ago when
> I tested ext4 it was a lot faster then ext3 (see my mail:
> http://lkml.org/lkml/2006/6/6/65). Doing some simple tests with bonnie++
> I got the following results:

Hi Holger,

You didn't say exactly which version of the kernel/ext4 you were
testing, but a recent change which we made to ext4, but which hasn't
been made to ext3 yet is that barrier support has been enabled to
improve filesystem safety; unfortunately this does imply with it a
slight performance slowdown, which would be more pronounced on
benchmarks with small filesystems.  So when you mount the filesystem
for ext3 and ext4 for benchmarking purposes, you should consistently
use a mount options of barrier=1 or barrier=0.  With ext4, you can use
the mount option "barrier=1,journal_async_commit" which should
ameliorate part of the performance decrease.  The reason why it is not
yet the default is it requires support from e2fsprogs that has not
been released except in development git branches; but as long as you
don't require running e2fsck on uncleanly shutdown systems (probably
not necessary if you are just benchmarking), you can use
journal_async_commit in good health.

Another change which might help out the bonnie benchmark, but which
again requires the latest version of e2fsprogs is to create the
filesystem with flex_bg filesystem feature.  In fact, for
convenience's sake, if you are using the latest development version of
e2fsprogs, you can just use the command "mke2fs -t ext4dev /dev/hdXX"
and it will set up the filesystem with the correct filesystem features
for ext4.  (The "ext4dev" sets the test_fs feature, and is basically
there so it's clear we are still trying to finish up ext4 support.)

> 2 years ago I used 2.6.16.8 but the hardware is still the same. So what has
> happened with the performance of ext4? I noticed that 2 years ago I could
> use extents+mballoc+delalloc, now there is only extents+mballoc in the
> current kernels. Could delalloc make the big difference? I saw that
> in Andrew Morton mm tree delalloc is included. Unfortunately when I tried 
> using
> 2.6.26-rc2-mm1 a sync would never return and there where lot of other
> odd things, so I could not do any tests with delalloc.

As Aneesh has mentioned, there were some bugs in version of ext4's
delalloc caused by insufficient testing of the ext4 patch queue some
changes to our locking strategy went in.  That's been fixed in the
latest patch queue, and we're in the process of cleaning up delalloc
before merging it into the mainline kernel.  (When you tested ext4 two
years ago, none of this was yet in mainline, so it's not a matter of
things delalloc "disappearing", but rather that we've been slow
getting to the point where it was ready for merging.

	       	     	      	  - Ted
