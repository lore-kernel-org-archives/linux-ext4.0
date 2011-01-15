From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Sat, 15 Jan 2011 14:33:44 +0100
Message-ID: <20110115133344.GB27123@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
 <20110113104240.GA30719@htj.dyndns.org>
 <20110113185946.GD27381@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54617 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1AONdu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Jan 2011 08:33:50 -0500
Content-Disposition: inline
In-Reply-To: <20110113185946.GD27381@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Thu, Jan 13, 2011 at 10:59:46AM -0800, Darrick J. Wong wrote:
> > But wouldn't it be better to implement this directly in the flush
> > machinary instead of as blkdev_issue_flush() wrapper?  We have all the
> > information at the request queue level so we can easily detect whether
> > flushes can be merged or not and whether something is issued by
> > blkdev_issue_flush() or by directly submitting bio wouldn't matter at
> > all.  Am I missing something?
> 
> Could you clarify where exactly you meant by "in the flush
> machinery"?  I think what you're suggesting is that
> blk_flush_complete_seq could scan the pending flush list to find a
> run of consecutive pure flush requests, submit the last one, and set
> things up so that during the completion of the flush, all the
> requests in that run are returned with the real flush's return code.

Yeah, something along that line.

> If that's what you meant, then yes, it could be done that way.
> However, I have a few reasons for choosing the blkdev_issue_flush
> approach.  First, as far as I could tell in the kernel, all the code
> paths that involve upper layers issuing pure flushes go through
> blkdev_issue_flush, so it seems like a convenient place to capture
> all the incoming pure flushes.

That means it _can_ be done there but doesn't mean it's the best spot.

> Other parts of the kernel issue writes with the flush flag set, but
> we want those to go through the regular queuing mechanisms anyway.
> Second, with the proposed patch, any upper-layer code that has a
> requirement for a pure flush to be issued without coordination can
> do so by submitting the bio directly (or blkdev_issue_flush_now can
> be exported).

I don't think anyone would need such capability but even if someone
does that should be implemented as a separate explicit
DONT_MERGE_THIS_FLUSH flag, not by exploting subtle inconsistencies on
the wrapper interface.

> Third, baking the coordination into the flush machinery makes that
> machinery more complicated to understand and maintain.

And the third point is completely nuts.  That's like saying putting
things related together makes the concentrated code more complex, so
let's scatter things all over the place.  No, it's not making the code
more complex.  It's putting the complexity where it belongs.  It
decreases maintenance overhead by increasing consistency.  Not only
that it even results in visibly more consistent and sane _behavior_
and the said complex machinary is less than 300 lines long.

> So in short, I went with the blkdev_issue_flush approach because the
> code is easier to understand, and it's not losing any pure flushes
> despite casting a narrower net.

No, not at all.  You're adding an unobvious logic into a wrapper
interface creating incosistent behavior and creating artificial
distinctions between pure and non-pure flushes and flushes issued by
bio and the wrapper interface.  Come on.  Think about it again.  You
can't be seriously standing by the above rationales.

Thanks.

-- 
tejun
