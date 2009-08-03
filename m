From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: Fix device too big bug in mainline?
Date: Mon, 3 Aug 2009 16:11:00 -0400
Message-ID: <20090803201100.GD10853@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZHCULB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 16:11:01 -0400
Content-Disposition: inline
In-Reply-To: <20090802022209.GC8680@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 01, 2009 at 10:22:09PM -0400, Theodore Tso wrote:
> In case people are wondering why it's taking so long to merge the
> 64-bit patch series, let me show one patch as exhibit 'A' about how
> not to submit patches to me (or Linus, or any other upstream
> maintainer):

I apologize for the misunderstanding!  These patches have (clearly)
never been reviewed and were not intended for merging into mainline
without a thorough reorganization.  It's simply unfortunate that we
are all busy and no one has had time to review them in the last
several months.  I am very grateful you have time to review them now!

The main difficulty with the 64-bit patch set is choosing patch
boundaries and granularity.  I'll try to summarize the issues I ran
into as briefly as possible.

The straightforward approach goes like so:

1. Add 64-bit version function foo2() (foo() is the 32-bit)
  (make check should pass here)
2. Convert all instances of foo() to foo2()
  (make check should pass here)
3. Repeat for bar(), baz(), etc.

In the ideal world, every patch would represent a single semantic
change, and every patch would result in a correct, compilable,
testable code change.

Two major problems with this scheme arise in the e2fsprogs code base:

1. The foo2() and bar() interfaces are incompatible, requiring a
non-trivial amount of glue code to convert between the output of
foo2() and the input of bar() and vice versa.  By "non-trivial" I
mean that the number of lines of glue code may exceed the number of
lines of code of the foo() -> foo2() transition itself.

2. While the code passes "make check" on 32-bit test cases at each
patch boundary, we can't check correctness of the 64-bit case until
the transition is complete for each testable binary unit.  Thus, we
currently have to rely on code inspection alone to track down bugs
that only affect the 64-bit case.  For example, Jose's first 64-bit
patch was posted around March 2008; it was not (and could not be)
tested above 32 bits until I ran the first 64-bit mke2fs sometime in
the fall of 2008.

The result is that the straightforward approach requires a great deal
more effort than usual to convert a semantic patch boundary to a "make
check" boundary.  Someone who knows the e2fsprogs code base very well
(such as yourself) might be able to write the necessary glue code
fairly swiftly and with few bugs.  However, every other developer in
the world (including myself) might spend as much time writing and
debugging glue code as the original patches themselves - only to find
that they chose the wrong patch boundary and must throw away that
code.

Hence, my decision to wait for your review and comments before even
the most trivial reorganization of the patch set.  I apologize if I
chose wrongly!

Some notes on improving 64-bit debugging at patch boundaries:

Currently, the "make check" test suite doesn't include any
infrastructure for 64-bit test devices.  This is particularly painful
to implement because many file systems (including ext4) don't support
files with > 2^32 blocks.  During development, I hacked together a
test system using loop devices backed by sparse files on an XFS file
system - clearly not a long-term solution.  Eric has suggested using
md to build 64-bit devices out of multiple 32-bit files backing loop
devices.  Some 64-bit tests require 64-bit userland and take many
gigabytes of memory (I had to get another 4GB to bring my test machine
up to 8GB before I could test > 2^32 block file systems).  Compressed
bitmap support would certainly help.  Overall, creating a 64-bit test
infrastructure is a significant project and should definitely get your
input before going forward.

Thanks for your time,

-VAL
