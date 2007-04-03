From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Tue, 3 Apr 2007 15:58:41 -0400
Message-ID: <20070403195841.GE31973@thunk.org>
References: <1172049359.4727.15.camel@garfield> <20070331004417.GJ3198@thunk.org> <20070331081624.GF5967@schatzie.adilger.int> <20070331123509.GA25539@thunk.org> <20070331143926.GG25539@thunk.org> <20070403173716.GW5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48537 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXDCT6u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Apr 2007 15:58:50 -0400
Content-Disposition: inline
In-Reply-To: <20070403173716.GW5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 03, 2007 at 11:37:16AM -0600, Andreas Dilger wrote:
> On Mar 31, 2007  10:39 -0400, Theodore Tso wrote:
> > I'm going to let this one soak for a bit to make sure we don't pick up
> > any fase positives or negatives in the hueristics.
> > 
> > @@ -133,11 +133,10 @@ int e2fsck_pass1_check_device_inode(ext2
> > +	 * If the index flag is set, then this is a bogus
> > +	 * device/fifo/socket
> >  	 */
> > -	if ((ext2fs_inode_data_blocks(fs, inode) != 0) ||
> > -	    (inode->i_flags & EXT2_INDEX_FL))
> > +	if (inode->i_flags & EXT2_INDEX_FL)
> >  		return 0;
> 
> There were ancient versions of the kernel that left EXT2_INDEX_FL set
> on all files, instead of just directories...  I'm not sure if those
> were in actual released kernels, or just in patches.

Well, we've been running with this in e2fsprogs for quite some time
(August 2002, e2fsprogs 1.28), and no one has complained, so I think
we're safe...


> > +static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
> > +				char *buf)
> > +{
> > +	if (ext2fs_read_dir_block(ctx->fs, inode->i_block[0], buf))
> > +		return;
> 
> Do we call check_blocks() on this inode shortly thereafter?  If we do then
> the overhead of reading the first block is offset by not reading it again
> later.  Otherwise, this could slow things down.

This is why we only do this on special devices; check_is_really_dir()
doesn't do anything on directory or regular files.

> The one worry I have here (though I don't think it is necessarily IN
> the code you propose) is that someone could create a regular file which
> looks like a directory and somehow get it linked into the filesystem
> tree, giving them escalated access (e.g. device files owned by them,
> suid executables, links to otherwise unreadable files, etc).

I thought of that, but I didn't worry about it because I'm not doing
this check on regular files.  Come to think of it I should add a check
so we don't do this for long symlinks, for similar reasons.  It would
only matter if the user can force filesystem check, which makes it a
long shot, but we should avoid that issue as well.

> I take it that this code fixes the test image I previously posted?

Yup.  Take a look at what I checked in into Mercurial.  I added two
separate test cases.  One of them directly tests the filetype issue,
and the other tests a mutated directory into a char device case.

						 - Ted
