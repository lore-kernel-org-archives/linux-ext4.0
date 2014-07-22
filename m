From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/24] e2fsck: clear i_block if there are too many bad
 block mappings
Date: Tue, 22 Jul 2014 15:14:26 -0700
Message-ID: <20140722221426.GF8628@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225321.31374.48416.stgit@birch.djwong.org>
 <20140722185933.GM25291@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, f@birch.djwong.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32608 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbaGVWOh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 18:14:37 -0400
Content-Disposition: inline
In-Reply-To: <20140722185933.GM25291@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2014 at 02:59:33PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 18, 2014 at 03:53:21PM -0700, Darrick J. Wong wrote:
> > If there are too many bad block mappings in a file and the user says
> > to zap it, erase i_block before clearing the inode.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Why is this necessary?  E2fsck will clear i_links_count and set dtime,
> so the contents of i_block shouldn't matter, yes?

Hmm... oh, I think I remember where this patch came from.  When I wrote the
patch "e2fsck: fix inode coherency issue when iterating an inode's blocks", I
looked down a few lines to see what pb.clear == 1 did.  I figured that if the
block mappings were really bad (i.e. there are more than 12 bad mappings), why
not just wipe i_block entirely?

I didn't have a specific failure case in mind when I wrote this patch.

--D
> 
> 						- Ted
> 
> > 
> > diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> > index b696d02..18980f1 100644
> > --- a/e2fsck/pass1.c
> > +++ b/e2fsck/pass1.c
> > @@ -2329,6 +2329,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
> >  	}
> >  
> >  	if (pb.clear) {
> > +		memset(inode->i_block, 0, sizeof(inode->i_block));
> >  		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
> >  				   "check_blocks");
> >  		return;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
