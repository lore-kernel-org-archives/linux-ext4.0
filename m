From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Tue, 26 Aug 2008 20:25:16 -0400
Message-ID: <20080827002516.GC29936@mit.edu>
References: <20080826104502.GH3392@webber.adilger.int> <20080826170420.GE8720@mit.edu> <20080826212743.GP3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60625 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592AbYH0AZS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 20:25:18 -0400
Content-Disposition: inline
In-Reply-To: <20080826212743.GP3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 03:27:43PM -0600, Andreas Dilger wrote:
> I mean that this is for "e2fsck -fn".  In that case the filesystem isn't
> changed, and is often completely clean except the superblock counters.
> Until we have block-device freeze ioctl widely available (or convince
> users to use LVM), the best we can do is quiesce Lustre IO without
> unmounting the filesystem.

Ah, I see.  So the main thing that you are trying to achieve with the
patch is avoid the non-zero exit from fsck, right?

I guess I'm really not that happy with letting the filesystem getting
marked as "valid" if the user refuses to fix the free blocks/inode
count summary when the -n flag isn't getting set.  And technically, if
the summary statistics are wrong, the filesystem is not actually
valid, which is what an exit code of 4, right?

It seems like the much more "correct" solution, which would actually
be more code, but would also be useful when a user wants to check a
filesystem without actually changing *anything*, including running the
journal, would be to create an I/O manager which reads in the journal
into memory, and creates a "override map" data structure such that
when e2fsck tries to read from a block which is in the journal, that
the (read-only) I/O manager read the block in the journal instead of
from the disk.  (Of course it will need to respect the revoke records,
too!)

Once we have this I/O manager, I think e2fsck should use it by default
with the -n option, so that we can correctly check the filesystem, and
**not** modify the device at all.  This would also give you the exit
status of 0 for quiscent filesystems, as you would wish.  Debugfs
could also have an option to use this I/O manager to read in the
journal.

						- Ted
