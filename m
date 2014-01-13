From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] Add support for new compat feature "one_backup_sb"
Date: Mon, 13 Jan 2014 17:02:50 -0500
Message-ID: <20140113220250.GA11207@thunk.org>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu>
 <20140113132707.GA22358@orion.maiolino.org>
 <20140113140645.GC18029@thunk.org>
 <20140113161949.GB22541@thunk.org>
 <0EBF5E18-D8DD-4602-BE97-9B7E9092052F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48157 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaAMWj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 17:39:28 -0500
Content-Disposition: inline
In-Reply-To: <0EBF5E18-D8DD-4602-BE97-9B7E9092052F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 01:41:27PM -0700, Andreas Dilger wrote:
> 
> Instead of adding a new location for the backup superblock at the
> "end" of the disk (which is subject to change if the filesystem is
> resized), what about using the last group that would otherwise have
> a backup superblock with the "sparse_super" feature?  That means
> resizing the filesystem by some amount won't change the location of
> the backup, and avoids the need to change all of the documentation
> for how to find superblocks.

That doesn't actually reduce the complexity.  The two headaches with
dealing with the resize is (a) when you grow the file system and add
one or more new block groups, you need to release the blocks
associated with backup superblock and block group descriptors, and
then (b) when you shrink a file system and you remove one or more
block groups, you need to relocate blocks where we need to put backup
superblocks in the "new" last block group.

Neither of these is a show stopper, but it's annoying since we need to
implement (a) and (b) in resize2fs, and then in the kernel twice, once
for the old-style online resize, and then again for the meta_bg style
online resize.

If we put the 2nd backup sueprblock in the last location where there
is a sparse_super feature, we still have deal with both of these
issues, and indeed it's actually a bit more of a headache to calculate
the block group which satisfies this constraint.  In addition, it
decreases slihgtly the range of contiguous data blocks.  (Putting the
backup superblock at the very end of the file system is the best from
this perspective, but it increases the complexity headache even more.)

What I'll probably do for now is to simply not support online resize
for the newly renamed "super sparse" feature, since for my use case,
which is for things like SMR disks, we're not going to be resizing
them anyway.  If we want to use this mode for RAID 5 arrays, then we
will have to get the resizing support working for the new "super
sparse" mode.

						- Ted
