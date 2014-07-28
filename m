From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/18] e2fsck: fix rule-violating lblk->pblk mappings on
 bigalloc filesystems
Date: Mon, 28 Jul 2014 10:55:54 -0700
Message-ID: <20140728175554.GQ8628@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003404.28334.18860.stgit@birch.djwong.org>
 <C91A6455-139E-4E6B-935F-F00332F76616@dilger.ca>
 <20140726202728.GM6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47953 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaG1R4A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 13:56:00 -0400
Content-Disposition: inline
In-Reply-To: <20140726202728.GM6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 04:27:28PM -0400, Theodore Ts'o wrote:
> On Sat, Jul 26, 2014 at 12:02:10AM -0600, Andreas Dilger wrote:
> > Wouldn't it be possible to use this information to determine which
> > of the inodes sharing a duplicate mapped block is the right one
> > and which inode is the bad one?
> 
> Yes, although I'm not sure it's worth the effort.  Putting in more
> intelligent hueristics for using the metadata checksums will help all
> file systems, and not just bigalloc file systems --- and I think it
> would be easier.
> 
> > On Jul 25, 2014, at 18:34, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> > 
> > As far as I can tell, logical block mappings on a bigalloc filesystem are
> > supposed to follow a few constraints:
> > 
> > * The logical cluster offset must match the physical cluster offset.
> > * A logical cluster may not map to multiple physical clusters.
> > 
> > Since the multiply-claimed block recovery code can be used to fix these
> > problems, teach e2fsck to find these transgressions and fix them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied, but a couple of tips about writing test scripts.
> 
> You originally had this:
> 
> 	../misc/tune2fs -L test_fs $TMPFILE
> 	../e2fsck/e2fsck -fy $TMPFILE > $OUT
> 	../e2fsck/e2fsck -fy $TMPFILE >> $OUT
> 	../e2fsck/e2fsck -fy $TMPFILE >> $OUT
> 
> This spits out the version numbers to stderr, which is ugly.  I fixed
> up the binary image file to have the test_fs label, and I changed the
> lines above to:
> 
> 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
> 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
> 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
> 
> The advantage of doing things this way is that any errors get captured
> in the log file.  Also, if the user has requested valgrind be used,
> that gets reflected in the value of $FSCK.

Hmm... the f_badcluster test seems to be missing from -maint and -next.
Did it get lost in the merge?

--D
> 
> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
