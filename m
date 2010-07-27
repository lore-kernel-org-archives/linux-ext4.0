From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: disallow FS recursion from sb_issue_discard allocation
Date: Tue, 27 Jul 2010 11:33:52 -0400
Message-ID: <20100727153352.GA5574@redhat.com>
References: <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com>
 <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com>
 <20100706161155.GA24461@redhat.com>
 <20100727134414.GC18966@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab0G0PeN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 11:34:13 -0400
Content-Disposition: inline
In-Reply-To: <20100727134414.GC18966@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 27 2010 at  9:44am -0400,
Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Jul 06, 2010 at 12:11:56PM -0400, Mike Snitzer wrote:
> > Filesystems can call sb_issue_discard on a memory reclaim path
> > (e.g. ext4 calls sb_issue_discard during journal commit).
> > 
> > Use GFP_NOFS in sb_issue_discard to avoid recursing back into the FS.
> > 
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Hi Jens,
> 
> I never saw an ack from you on this patch.  Are you ok with it, and
> have you grabbed it for your tree?  Do you want me to include this in
> the ext4 tree, even though it's a patch to include/linux/blkdev.h?

Hi Ted,

Thanks for following up on this.  In my experience, Jens is more apt to
pick up a patch if it gets explicitly 'Acked-by' other stake-holders
(especially when a patch is motivated by another subsystem, in this case
the proposed block change addresses a problem unique to fs/ext4).

Mike
