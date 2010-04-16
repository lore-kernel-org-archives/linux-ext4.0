From: tytso@mit.edu
Subject: Re: ext34_free_inode's mess
Date: Fri, 16 Apr 2010 09:33:43 -0400
Message-ID: <20100416133343.GA32634@thunk.org>
References: <87pr2246y4.fsf@openvz.org>
 <20100414133440.GD3616@quack.suse.cz>
 <87d3y23xz9.fsf@openvz.org>
 <20100415213904.GA13293@quack.suse.cz>
 <87sk6w2x4w.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56286 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab0DPQrX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 12:47:23 -0400
Content-Disposition: inline
In-Reply-To: <87sk6w2x4w.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 16, 2010 at 02:01:35AM +0400, Dmitry Monakhov wrote:
> Ok, if we know that any error result in EIO or panic when let's just
> call it style cleanup(simplification), imho new code is more readable.

Agreed.  The reason you're seeing me respin this patch a few times is
because we recently added some additional qualification testing for
ext4 in $DAYJOB, and we've found that running dbench followed by fsck
-fy also seems to be a good way of tickling this bug --- and applying
the patch which you wrote does seem to make it go away.  

Like you, I can't reproduce the problem once the patch has been
applied; and like you and Jan, I can't see how this patch would
actually fix a race or some other bug.  But given that (a) it
definitely is a code cleanup, and (b) it empircally seems to make the
bug go away, and (c) we've seen this problem in our production
servers, I'm inclined to take it.

I hope to spend a bit more time in the next few days trying to figure
out what the actual root cause is, so we can figure out whether this
is really fixing a problem, or just making it harder to hit.

Dmitry, I need to thank you for all of the ext4 testing and bug fixing
you've been doing.  I really appreciate it!!!  I'm pretty sure BTW
that BZ #15792 is also one that we've seen on our production servers,
and so you're finding issues that aren't just showing up in
regression/stress test suites, but can and actually do happen in
real-world settings.

   	  	   	       	    	      	     - Ted
