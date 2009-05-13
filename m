From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Wed, 13 May 2009 12:07:24 -0400
Message-ID: <20090513160724.GC6579@mit.edu>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59464 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbZEMQHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2009 12:07:31 -0400
Content-Disposition: inline
In-Reply-To: <20090513134802.GA7212@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
>   OK, the deadlock has been introduced by ext3 variant of
> 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC).

What do you mean by this?

I'm puzzled why we haven't hit this before.  This looks like
long-standing issue; what unmasked it now?

> The deadlock
> is really tough to avoid - we have to first allocate inode on disk so
> that we know the inode number.

Well, the simple thing to do is to have a way of quickly determining
that a particular inode number is in the I_FREEING state, and simply
try to avoid using that inode number.  If there are no inodes
available, it can simply close the handle (since nothing else has
changed at that point), wait for the current transaction to close, and
then try again.  That should fix the problem, I think.

     	 	      	     	     	      - Ted
