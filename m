From: tytso@mit.edu
Subject: Re: About reserve of blocks for "overflow extents" in ext4 metadata
Date: Wed, 9 Dec 2009 10:31:40 -0500
Message-ID: <20091209153140.GG27692@thunk.org>
References: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44022 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbZLIPbj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 10:31:39 -0500
Content-Disposition: inline
In-Reply-To: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 08, 2009 at 01:03:28PM +0300, Vyacheslav Dubeyko wrote:
> 1) In the case of ext4 volume's shrinking resize (especially, in the
> case of very fragmented volume) it can be very difficult to estimate
> possibility of successful resize because of existing mechanism of
> extents' tree layout on the volume. It is possible to encounter
> during resize the problem of free blocks' lack for rebuilding of
> extents' tree for replaced files. The reserve of blocks for
> "overflow extents" guarantee against encountering of such problem
> during resizes.

I'm not sure how important it is to make fs shrink work "better",
since most of the time, system administrators are more interested in
growing file systems than shrinking file systems.  That's one of the
reasons why we haven't spent more time trying to make e2resize smarter
about avoiding fragmenting files while shrinking --- or perhaps even
doing some defragmentation as part of the resize.  In some sense
that's something that we should think about doing if people want to be
using resizing as a common operation, as opposed to something rare
that works but isn't very well optimized.  (I've always been a bit
concerned with Fedora using it as a regular way of making ISO disks,
since the a number of file inevitably ended up being fragmented, for
ext3 or ext4 file systems, and seeks on CD's aren't exactly like that
of HDD's or SDD's.)

That being said, if the goal is to allow the shrink to succeed, we
just need a pool of reserve blocks.  We do have something exactly like
that for non-privileged users (the 5% reserve).  What you're talking
about is adding more of a reserve, and perhaps one that gets used for
the privileged users as well.  We could do that, but people are
already annoyed about having 5% reserved.  Reserving more would not be
popular.

> 2) The presence of the reserve of blocks for "overflow extents"
> means that all existing extents' trees of files will locate in one
> place. This fact and placement the reserve just after inode table
> will increase efficiency of operations with extents' trees, in my
> opinion.

We have this already.  Directory and extent tree blocks are currently
preferentially allocated in the first block group of each flex_bg, and
data file blocks are preferentially allocated outside of the first
block group.  If the file system gets full, then extent tree blocks or
data blocks can located anywhere, of course.

Your idea seems to have a contradiction, though.  If you have a
"reserve of blocks" and you aren't necessarily allocating enough space
for the absolute worse case (which means reserving a *very* large
number of blocks), but you are allocating them under normal
circumstances, then there will be times when the reserve will be
exhausted.  At that point, resize shrinking will be once again be
problematic or not possible, and fragmentation loses wil be quite bad.

> 3) The localized layout of extents' trees of files means efficient
> journaling of this metadata, also.

Um, how?  

					- Ted
