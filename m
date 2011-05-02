From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Mon, 2 May 2011 14:29:45 -0400
Message-ID: <20110502182945.GG2819@thunk.org>
References: <20110425231454.GB9486@thunk.org>
 <1303777411-1316-2-git-send-email-tytso@mit.edu>
 <20110430171711.GA2819@thunk.org>
 <20110502150758.GH4556@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Martin_Zielinski@McAfee.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38512 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1EBS3v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 14:29:51 -0400
Content-Disposition: inline
In-Reply-To: <20110502150758.GH4556@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 05:07:58PM +0200, Jan Kara wrote:
>   The patch looks OK in any case. I'll take it in my tree.
Great, thanks.

> It would take
> about 24 days of constant 1000 trans/s load to trigger this. That's a quite
> heavy load but not so unrealistic with today's HW.

True; but one of the reason why I'm not sure I believe that is this
bug is showing up on some Android devices, where (a) 1000 trans/second
*is* a not just a huge load, but almost impossible to believe, and (b)
if we really are doing 2**31 commits, we would be wearing out the
flash storage being used on the Android devices!  (And we're seeing a
handful of failures every week from the testers who participate in a
kerneloops-like reporting system.)

So while I would very much like to believe that it's caused by a tid
wrap, I'm worried there is another bug hiding here....

    		      	 	     	    - Ted
