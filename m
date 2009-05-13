From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Wed, 13 May 2009 17:52:54 +0100
Message-ID: <20090513165254.GR8633@ZenIV.linux.org.uk>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZEMQwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 12:52:55 -0400
Content-Disposition: inline
In-Reply-To: <20090513134802.GA7212@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
> >   Here, we have started a transaction in ext3_create() and then wait in
> > find_inode_fast() for I_FREEING to be cleared (obviously we have
> > reallocated the inode and squeezed the allocation before journal_stop()
> > from the delete was called).
> >   Nasty deadlock and I don't see how to fix it now - have to go home for
> > today... Tomorrow I'll have a look what we can do about it.
>   OK, the deadlock has been introduced by ext3 variant of
> 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC). The deadlock
> is really tough to avoid - we have to first allocate inode on disk so
> that we know the inode number. For this we need transaction open but we
> cannot afford waiting for old inode with same INO to be freed when we have
> transaction open because of the above deadlock. So we'd have to wait for
> inode release only after everything is done and we closed the transaction. But
> that would mean reordering a lot of code in ext3/namei.c so that all the
> dcache handling is done after all the IO is done.
>   Hmm, maybe we could change the delete side of the deadlock but that's
> going to be tricky as well :(.
>   Al, any idea if we could somehow get away without waiting on
> I_FREEING?

At which point do we actually run into deadlock on delete side?  We could,
in principle, skip everything like that in insert_inode_locked(), but
I would rather avoid the "two inodes in icache at the same time, with the
same inumber" situations completely.  We might get away with that, since
everything else *will* wait, so we can afford a bunch of inodes past the
point in foo_delete_inode() that has cleared it in bitmap + new locked
one, but if it's at all possible to avoid, I'd rather avoid it.
