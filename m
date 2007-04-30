From: Jan Kara <jack@suse.cz>
Subject: Re: Ext2/3 block remapping tool
Date: Mon, 30 Apr 2007 14:29:21 +0200
Message-ID: <20070430122921.GI28367@duck.suse.cz>
References: <20070426192953.GC2841@duck.suse.cz> <20070427180942.GB5967@schatzie.adilger.int> <20070430120930.GA10604@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45729 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423187AbXD3MT4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 08:19:56 -0400
Content-Disposition: inline
In-Reply-To: <20070430120930.GA10604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 30-04-07 08:09:30, Theodore Tso wrote:
> On Fri, Apr 27, 2007 at 12:09:42PM -0600, Andreas Dilger wrote:
> > I'd prefer that such functionality be integrated with Takashi's online
> > defrag tool, since it needs virtually the same functionality.  For that
> > matter, this is also very similar to the block-mapped -> extents tool
> > from Aneesh.  It doesn't make sense to have so many separate tools for
> > users, especially if they start interfering with each other (i.e. defrag
> > undoes the remapping done by your tool).
> 
> Yep, in fact, I'm really glad that Jan is working on the remapping
> tool because if the on-line defrag kernel interfaces don't have the
> right support for it, then that means we need to fix the on-line
> defrag patches.  :-)
  ;-) Exactly that was the reason why I wrote the userspace program - so
that I have something in hands when we start discussing how the kernel
interface will look like.

> While we're at it, someone want to start thinking about on-line
> shrinking of ext4 filesystems?  Again, the same block remapping
> interfaces for defrag and file access optimizations should also be
> useful for shrinking filesystems (even if some of the files that need
> to be relocated are being actively used).  If not, that probably means
> we got the interface wrong.
  Yes, that's a good idea. Currently it seems to me that block+inode
relocation (we also need for defrag) would be enough to support filesystem
shrinking. Actually, in some ancient times (like 6-7 years ago) I had
written ext2 online filesystem shrinking. Currently, the patch is probably
unusably obsolete but I can still dig it out and look what functions did I
need at that time.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
