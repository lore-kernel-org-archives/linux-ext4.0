From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/18] e2fsck: verify checksums after checking everything
 else
Date: Mon, 28 Jul 2014 01:27:43 -0700
Message-ID: <20140728082743.GN8628@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003422.28334.29365.stgit@birch.djwong.org>
 <20140726205316.GO6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30145 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaG1I1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 04:27:47 -0400
Content-Disposition: inline
In-Reply-To: <20140726205316.GO6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 04:53:16PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:34:22PM -0700, Darrick J. Wong wrote:
> > There's a particular problem with e2fsck's user interface where
> > checksum errors are concerned:  Fixing the first complaint about
> > a checksum problem results in the inode being cleared even if e2fsck
> > could otherwise have recovered it.  While this mode is useful for
> > cleaning the remaining broken crud off the filesystem, we could at
> > least default to checking everything /else/ and only complaining about
> > the incorrect checksum if fsck finds nothing else wrong.
> > 
> > So, plumb in a config option.  We default to "verify and checksum"
> > unless the user tell us otherwise.
> 
> I'm not convinced this is the right way to go.  Telling the user that
> they need to muck with the config file depending on what sort of file
> system corruption they have seems rather unsatisfying.
> 
> This is what I'd much rather do.  Add a "sanity checking" mode to the
> inode scanning functions which gets enabled when EXT2_SF_SANITY_CHECK
> is set via ext2fs_inode_scan_flags().  What the sanity check mode does
> is every time the inode scan functions read in a new inode table
> block, it performs a "sanity check" on the inode table block.  
> 
> The sanity check is carried out as follows.  If a majority of the
> inodes in the inode table block are "insane" then set the
> EXT2_SF_INSANE_ITABLE_BLOCK flag in scan flags, if not, clear this
> flag.  If checksum is incorrect, the inode is considered insane.  If
> the extent flag is set, and the extent header looks insane, then the
> inode is considered insane.  For indirect blocks, if more than 50% of
> the blocks in i_blocks[] are invalid, then inode is considered insane.
> 
> This is basically a simiplified version of an algorithm which Andreas
> has been carrying in Lustre's e2fsprogs for a while, which tries to
> apply a hueristic check over multiple inodes to decide whether if we
> would be better off just zapping all of the inodes in an inode table
> block.  The reason why I never integrated that change into mainline is
> that in order to make it work, it violated a large number of
> abstractions, and so I considered too ugly to live.
> 
> The advantage of doing this all inside lib/ext2fs/inode.c's inode
> scanning function is that it's much cleaner.  We can't do as many
> checks as Andreas did, but for the rough hueristic of deciding whether
> we have a minor problem in a single inode, or a massive problem caused
> by garbage written into the inode table or another inode table block
> getting written into the wrong place on disk (which we can only do if
> metadata checksums are enabled, but that's OK), we can get away with
> doing only the obvious "local" checks.
> 
> After all, in practice, it's usually either problems in a single inode
> (usually caused by a kernel bug or a memory bit flip), or complete
> garbage written into the inode table block, or an inode table block
> written to wrong place on disk, on top of another inode table block.
> So we just need a rough hueristic to distinguish between these cases.
> 
> Once we've decided whether the entire inode table block is insane or
> not, then what we do is if an inode has any problems at all during the
> pass1 scan, we check to see if the inode table block is marked insane.
> If it is considered insane, then we just clear the i_links_count and
> set dtime, effectively zapping the inode, no questions asked.
> Otherwise, we proceed doing the individual fix ups of each inode field.
> 
> Does that make sense?

Yes, that makes sense for dealing with the inodes.  What about the other FS
object blocks, such as directories, EAs, and extents?

Perhaps I'll try to define some insane heuristics:

For EA and extent blocks we could declare the block insane if the checksum
fails and the magic number is missing.  Seems pretty straightforward.

For classic directory blocks, we could declare the block insane if the checksum
fails and the end of the block is not {00 00 00 00 0C 00 00 DE XX XX XX XX}.

For htree directory blocks, we could similarly declare insanity if the checksum
fails and the beginning of the block are not the required fake dir entries.

...and if it's insane, zap it immediately; otherwise, run the usual checks and
fix the checksum if the other checks pass.

Hmm, that doesn't seem so bad.  What do people think?

--D
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
