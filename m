From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Avoid false EIO errors (version 4)
Date: Wed, 1 Apr 2009 11:49:36 +0200
Message-ID: <20090401094936.GB4569@duck.suse.cz>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker> <20090330103248.GB18833@duck.suse.cz> <20090330105821.GE4796@skywalker> <20090330160517.GB30897@duck.suse.cz> <20090331044544.GB5979@skywalker> <20090331094618.GE11808@duck.suse.cz> <20090331170621.d2ae5693.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mfasheh@suse.de, aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZDAJtn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 05:49:43 -0400
Content-Disposition: inline
In-Reply-To: <20090331170621.d2ae5693.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 31-03-09 17:06:21, Andrew Morton wrote:
> On Tue, 31 Mar 2009 11:46:18 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> >   Hello,
> > 
> >   as Aneesh pointed to me, I forgot to add truncation to the data=journaled
> > mode. This patch fixes it. Hopefully final version of the fix ;).
> > 
> 
> I _think_ I got the right version here.
  Yes. I'm sorry I haven't started adding "version" suffix to the patches
at the second submission... That would make is easier for you I guess.

> > >From ec5c2977f87328fb93fee1aa35043bafeb53cea1 Mon Sep 17 00:00:00 2001
> > From: Jan Kara <jack@suse.cz>
> > Date: Wed, 25 Mar 2009 18:51:52 +0100
> > Subject: [PATCH] ext3: Avoid false EIO errors (version 4)
> > 
> > Sometimes block_write_begin() can map buffers in a page but later we fail to
> > copy data into those buffers (because the source page has been paged out in the
> > mean time).
> 
> Really?  We should just page it back in again.  Do you mean "it was an
> invalid address and we got -EFAULT"?  Or "a parallel thread unmapped
> it" or...?
  I meant parallel thread freeing pages unmapped it.

> > We then end up with !uptodate mapped buffers.
> 
> OK, I suppose that has to be a legal buffer state.
  Yes, it is a state which makes sence. ext3 code just was not expecting
it.

> > To add a bit more to
> > the confusion, block_write_end() does not commit any data (and thus does not
> > any mark buffers as uptodate) if we didn't succeed with copying all the data.
> > 
> > Commit f4fc66a894546bdc88a775d0e83ad20a65210bcb (ext3: convert to new aops)
> > missed these cases and thus we were inserting non-uptodate buffers to
> > transaction's list which confuses JBD code and it reports IO errors, aborts
> > a transaction and generally makes users afraid about their data ;-P.
> 
> hm.  Did any other filesystems break for these reasons?
  Well, I've checked and ext4/ocfs2 are fine because they add inode, not
individual buffers, to the transaction and writepage() then handles those
buffers fine (they are not marked dirty so we just skip them). ext4
definitely has a problem with blocks instantiated outside of i_size, Aneesh
already sent a fix for that. ocfs2 might have this problem as well but I'm
not sure - it may be a legal state for it, although I doubt it (adding Mark
to CC).
  Simple filesystems not doing journaling and using generic_write_end()
don't care (ext2, udf, fat and most of the others). So I *hope* noone else
has this problem (at least grepping for generic_write_end and
block_write_end does not seem to reveal any other callers which would have
problems with copied < len or block_write_end() setting copied to 0).

> > This patch fixes the problem by reorganizing ext3_..._write_end() code to
> > first call block_write_end() to mark buffers with valid data uptodate and
> > after that we file only uptodate buffers to transaction's lists.
> > 
> > We also fix a problem where we could leave blocks allocated beyond i_size
> > (i_disksize in fact) because of failed write. We now add inode to orphan
> > list when write fails (to be safe in case we crash) and then truncate blocks
> > beyond i_size in a separate transaction.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
