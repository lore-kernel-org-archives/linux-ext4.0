From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/35] e2undo: ditch tdb file, write everything to a flat
 file
Date: Tue, 5 May 2015 10:24:34 -0400
Message-ID: <20150505142434.GB9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023532.25243.532.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45884 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993170AbbEEOYe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:24:34 -0400
Content-Disposition: inline
In-Reply-To: <20150402023532.25243.532.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:32PM -0700, Darrick J. Wong wrote:
> The existing undo file format (which is based on tdb) has many
> problems.  First, its comparison of superblock fields is ineffective,
> since the last mount time is only written by the kernel, not the tools
> (which means that undo files can be applied out of order, thus
> corrupting the filesystem); block numbers are written in CPU byte
> order, which will cause silent failures if an undo file is moved from
> one type of system to another; using the tdb database costs us an
> enormous amount of CPU overhead to maintain the key data structure,
> and finally, the tdb database is unable to deal with databases larger
> than 2GB.  (Upstream tdb 1.2.12 can handle 4GB, but upgrading a 2TB FS
> to 64bit,metadata_csum easily produces 2.9GB of undo files, so we
> might as well move off of tdb now.)
> 
> The last problem is fatal if you want to use tune2fs to turn on
> metadata checksumming, since that rewrites every block on the
> filesystem, which can easily produce a many-gigabyte undo file, which
> of course is unreadable and therefore the operation cannot be undone.
> 
> Therefore, rip all of that out in favor of writing to a flat file.
> Old blocks are appended to a file and the index is written to the end
> when we're done.  This implementation is much faster than wasting a
> considerable amount of time trying to maintain a hash index, which
> drops the runtime overhead of tune2fs -O metadata_csum from ~45min
> to ~20 seconds on a 2TB filesystem.
> 
> I have a few reasons that factored in my decision not to repurpose the
> jbd2 file format for undo files.  First, undo files are limited to
> 2^32 blocks (16TB) which some day might not serve us well.  Second,
> the journal block size is tied to the file system block size, but
> mke2fs wants to be able to back up big chunks of old device contents.
> This would require large changes to the e2fsck journal replay code,
> which itself is derived from the kernel jbd2 driver, which I'd rather
> not destabilize.  Third, I want to require undo files to store the FS
> superblock at the end of undo file creation so that e2undo can be
> reasonably sure that an undo file is supposed to apply against the
> given block device, and doing so would require changes to the jbd2
> format.  Fourth, it didn't seem like a good idea that external
> journals should resemble undo files so closely.
> 
> v2: Provide a state bit that is only set when the undo channel is
> closed correctly so we can warn the user about potentially incomplete
> undo files.  Straighten out the superblock handling so that undo files
> won't be confused for real ext* FS images.  Record multi-block runs in
> each block key to reduce overhead even further.  Support reopening an
> undo file so that we can combine multiple FS operations into one
> (overall smaller) transaction file, which will be easier to manage.
> Flush the undo index data if the program should terminate
> unexpectedly.  Update the ext4 superblock bits if errors or -f is
> found to encourage fsck to do a full run the next time it's invoked.
> Enable undoing the undo.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
