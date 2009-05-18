From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Mon, 18 May 2009 09:15:48 -0400
Message-ID: <20090518131548.GI32019@mit.edu>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz> <20090513165254.GR8633@ZenIV.linux.org.uk> <20090513181340.GA8128@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, bugzilla-daemon@bugzilla.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59790 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZERNQK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 09:16:10 -0400
Content-Disposition: inline
In-Reply-To: <20090513181340.GA8128@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 07:13:40PM +0100, Al Viro wrote:
> 
> OK, that's probably the easiest way to do that, as much as I don't like it...
> Since iget() et.al. will not accept I_FREEING (will wait to go away
> and restart), and since we'd better have serialization between new/free
> on fs data structures anyway, we can afford simply skipping I_FREEING
> et.al. in insert_inode_locked().
> 
> We do that from new_inode, so it won't race with free_inode in any interesting
> ways and it won't race with iget (of any origin; nfsd or in case of fs
> corruption a lookup) since both still will wait for I_LOCK.
> 
> Tentative patch follow; folks, I would very much like review on that one,
> since I'm far too low on caffeine and the area is nasty.

Sorry for not having time to review this until now.  This looks good
to me.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

So Bug #13232 is currently marked as a 2.6.28 regression; do we feel
confident enough to push this to Linus for 2.6.30?

	  	    	      	 - Ted
