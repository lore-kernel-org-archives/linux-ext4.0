From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Thu, 26 May 2011 16:49:56 +0200
Message-ID: <20110526144956.GB5123@quack.suse.cz>
References: <4DDCAF18.8030809@gmail.com>
 <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com>
 <20110525081333.GB4427@quack.suse.cz>
 <20110526022251.GG9520@thunk.org>
 <E4B2E5DC-AC13-4AB9-870E-6F3584991396@dilger.ca>
 <20110526140558.GJ9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1EZOt7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 10:49:59 -0400
Content-Disposition: inline
In-Reply-To: <20110526140558.GJ9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-05-11 10:05:58, Ted Tso wrote:
> On Wed, May 25, 2011 at 10:07:20PM -0600, Andreas Dilger wrote:
> > > What JBD2_TOPLEVEL means is that caller is from a top-level file
> > > system function, such as ext4_symlink() or ext4_chmod(), such that
> > > start_this_handle() can use GFP_KERNEL instead of GFP_NOFS.  GFP_NOFS
> > > is needed for any function that might get called by the direct reclaim
> > > path (i.e., the writepage() function).  But for the top-level
> > > symlink() or chmod() function, it's actually OK to allocate memory
> > > using GFP_KERNEL, since there's no potential recursion problem.
> > 
> > At this point, why not just pass GFP_KERNEL or GFP_NOFS directly,
> > optionally with __GFP_NOFAIL?
> 
> Well, __GFP_NOFAIL is going away.  (At least there are a number of mm
> hackers, including akpm, who really want it to go away).
> 
> We could key off of GFP_NOFS, but GFP_NOFS doesn't mean loop and make
> sure that we don't fail.  The two concepts are in fact orthogonal;
> it's just at the moment that there are most places which are called in
> the fs writeback path which also can't fail.  
  Exactly.

> But just to give one example, ext4_bio_write_page() is an example of a
> function that allocates memory GFP_NOFS, but can fail with ENOMEM,
> because its caller, mpage_da_submit_io() in fs/ext4/inode.c is
> designed to cope with failure in a way that doesn't cause data loss.
> (We leave the page dirty, unlock it and back out of the writeback
> code, and later the bdi flusher threads will retry the writepages
> request.)
> 
>     	      	      	       	    	    	  - Ted
> 
> P.S.  That means that there are calls to ext4_journal_start() in the
> ext4_da_writepages() code path that probably could be converted to
> ext4_journal_start_failok() --- or to ext4_journal_start(inode,
> nblocks, JBD2_FAIL_OK) per my suggestion --- once we have fully
> audited the error return paths.
> 
> P.P.S.  Something that might be worth doing is having a sysfs tunable
> that causes ext4_journal_start() to return an ENOMEM failure on a per
> file system basis with a probability specified by the sysfs tunable.
> This would allow us to actually _test_ the error handling to make sure
> sane things happen....  
  No need to do this. If you make JBD2 use a separate slab for transaction
structures (trivial and makes some sense anyway), you can use
fault-injection framework to do exactly what you describe above (see
Documentation/fault-injection/fault-injection.txt and look for failslab).

> What I'd probably do is define a new flag, JBD2_WRITEBACK_TEST, and
> use it to make the ext4_journal_start() functions that are allowed to
> probabilistically fail (since the retry should be happening at a
> higher level), and then run a stress test with the syfs tunable
> enabled.  Since the flag would only cause ext4_journal_start()
> functions that should have automatic fallbacks, the stress test would
> be able to run to completion even though 10% of the
> ext4_journal_start(... JBD2_WRITEBACK_TEST) calls were failing.
> That's another example of why using a flag bitfield instead of a bool
> is much more powerful.
  But if we just fail all transaction allocations with say 10% probability,
it should work as well, shouldn't it? We'd just retry those allocations
whose failure we cannot handle and eventually succeed. Or do I miss
something?
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
