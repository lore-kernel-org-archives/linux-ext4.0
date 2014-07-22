From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/24] e2fsck: clear i_block if there are too many bad
 block mappings
Date: Tue, 22 Jul 2014 18:48:27 -0400
Message-ID: <20140722224827.GT25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225321.31374.48416.stgit@birch.djwong.org>
 <20140722185933.GM25291@thunk.org>
 <20140722221426.GF8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: f@birch.djwong.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51082 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbaGVWui (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 18:50:38 -0400
Content-Disposition: inline
In-Reply-To: <20140722221426.GF8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2014 at 03:14:26PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 22, 2014 at 02:59:33PM -0400, Theodore Ts'o wrote:
> > On Fri, Jul 18, 2014 at 03:53:21PM -0700, Darrick J. Wong wrote:
> > > If there are too many bad block mappings in a file and the user says
> > > to zap it, erase i_block before clearing the inode.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Why is this necessary?  E2fsck will clear i_links_count and set dtime,
> > so the contents of i_block shouldn't matter, yes?
> 
> Hmm... oh, I think I remember where this patch came from.  When I wrote the
> patch "e2fsck: fix inode coherency issue when iterating an inode's blocks", I
> looked down a few lines to see what pb.clear == 1 did.  I figured that if the
> block mappings were really bad (i.e. there are more than 12 bad mappings), why
> not just wipe i_block entirely?
> 
> I didn't have a specific failure case in mind when I wrote this patch.

Ok, then I'll drop this.  In general I try to avoid unnecessary
zero'ing when possible.  It might be useful in doing a post morten
after the user runs e2fsck -y, and so long as inode is skipped, I'd
rather not zap more of the inode structure than is strictly necessary.

Cheers,

						- Ted
