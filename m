From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/18] e2fsck: fix rule-violating lblk->pblk mappings on
 bigalloc filesystems
Date: Sat, 26 Jul 2014 16:27:28 -0400
Message-ID: <20140726202728.GM6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003404.28334.18860.stgit@birch.djwong.org>
 <C91A6455-139E-4E6B-935F-F00332F76616@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58705 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaGZU1d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 16:27:33 -0400
Content-Disposition: inline
In-Reply-To: <C91A6455-139E-4E6B-935F-F00332F76616@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 12:02:10AM -0600, Andreas Dilger wrote:
> Wouldn't it be possible to use this information to determine which
> of the inodes sharing a duplicate mapped block is the right one
> and which inode is the bad one?

Yes, although I'm not sure it's worth the effort.  Putting in more
intelligent hueristics for using the metadata checksums will help all
file systems, and not just bigalloc file systems --- and I think it
would be easier.

> On Jul 25, 2014, at 18:34, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> As far as I can tell, logical block mappings on a bigalloc filesystem are
> supposed to follow a few constraints:
> 
> * The logical cluster offset must match the physical cluster offset.
> * A logical cluster may not map to multiple physical clusters.
> 
> Since the multiply-claimed block recovery code can be used to fix these
> problems, teach e2fsck to find these transgressions and fix them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied, but a couple of tips about writing test scripts.

You originally had this:

	../misc/tune2fs -L test_fs $TMPFILE
	../e2fsck/e2fsck -fy $TMPFILE > $OUT
	../e2fsck/e2fsck -fy $TMPFILE >> $OUT
	../e2fsck/e2fsck -fy $TMPFILE >> $OUT

This spits out the version numbers to stderr, which is ugly.  I fixed
up the binary image file to have the test_fs label, and I changed the
lines above to:

	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT

The advantage of doing things this way is that any errors get captured
in the log file.  Also, if the user has requested valgrind be used,
that gets reflected in the value of $FSCK.

Cheers,

					- Ted
