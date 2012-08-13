From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't load the block bitmap for block groups which
 have no space
Date: Mon, 13 Aug 2012 14:49:16 -0400
Message-ID: <20120813184916.GF32484@thunk.org>
References: <20120809181059.A5BAA11FC69@bugzilla.kernel.org>
 <1344622885-14982-1-git-send-email-tytso@mit.edu>
 <50292500.1070807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44473 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2HMStU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 14:49:20 -0400
Content-Disposition: inline
In-Reply-To: <50292500.1070807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 13, 2012 at 11:02:08AM -0500, Eric Sandeen wrote:
> 
> Looks ok to me; I think this just further optimizes what was done
> in
> 
> 8a57d9d61a6e361c7bb159dda797672c1df1a691
> ext4: check for a good block group before loading buddy pages
> 
> correct?

Yes, that's right; it's a further optimization.

I can think of an additional optimization where if we are reading the
block bitmap for block group N, and the block bitmap for block group
N+1 hasn't been read before (so we don't have buddy bitmap stats), and
the block bitmap for bg N+1 is adjacent for bg N, we should read both
at the same time.  (And this could be generalized for N+2, N+3, etc.)

I'm not entirely sure whether it's worth the effort, but I suspect for
very full file systems, it might be very well be.  This is a more
general case of the problem where most people only benchmark mostly
empty file systems, and my experience has been that above 70-80%
utilization, our performance starts to fall off.  And while disk space
is cheap, it's not _that_ cheap, and there are always customers who
insist on using file systems up to a utilization of 99%, and expect
the same performance as when the file system was freshly formated.  :-(

	    	 	     	     	 - Ted
