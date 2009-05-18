From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Mon, 18 May 2009 14:45:20 +0200
Message-ID: <20090518124520.GC25232@duck.suse.cz>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz> <20090513160724.GC6579@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZERMpU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 08:45:20 -0400
Content-Disposition: inline
In-Reply-To: <20090513160724.GC6579@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-05-09 12:07:24, Theodore Tso wrote:
> On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
> >   OK, the deadlock has been introduced by ext3 variant of
> > 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC).
> 
> What do you mean by this?
> 
> I'm puzzled why we haven't hit this before.  This looks like
> long-standing issue; what unmasked it now?
  Unless you mount the fs with 'sync' option, hitting this is much harder
(the window is quite small in nosync case). I think that is the main reason
why we didn't see this earlier.

> > The deadlock
> > is really tough to avoid - we have to first allocate inode on disk so
> > that we know the inode number.
> 
> Well, the simple thing to do is to have a way of quickly determining
> that a particular inode number is in the I_FREEING state, and simply
> try to avoid using that inode number.  If there are no inodes
> available, it can simply close the handle (since nothing else has
> changed at that point), wait for the current transaction to close, and
> then try again.  That should fix the problem, I think.
  Yes, we could work-around it like that but other filesystems might need
similar things and generally it would be nicer if we could avoid using this
vfs-internal information in the filesystems. Al seems to have found some
other solution without changing filesystems so that would be easier for us...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
