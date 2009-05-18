From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Mon, 18 May 2009 14:53:57 +0200
Message-ID: <20090518125357.GD25232@duck.suse.cz>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz> <20090513165254.GR8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZERMx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 08:53:57 -0400
Content-Disposition: inline
In-Reply-To: <20090513165254.GR8633@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-05-09 17:52:54, Al Viro wrote:
> On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
> > >   Here, we have started a transaction in ext3_create() and then wait in
> > > find_inode_fast() for I_FREEING to be cleared (obviously we have
> > > reallocated the inode and squeezed the allocation before journal_stop()
> > > from the delete was called).
> > >   Nasty deadlock and I don't see how to fix it now - have to go home for
> > > today... Tomorrow I'll have a look what we can do about it.
> >   OK, the deadlock has been introduced by ext3 variant of
> > 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC). The deadlock
> > is really tough to avoid - we have to first allocate inode on disk so
> > that we know the inode number. For this we need transaction open but we
> > cannot afford waiting for old inode with same INO to be freed when we have
> > transaction open because of the above deadlock. So we'd have to wait for
> > inode release only after everything is done and we closed the transaction. But
> > that would mean reordering a lot of code in ext3/namei.c so that all the
> > dcache handling is done after all the IO is done.
> >   Hmm, maybe we could change the delete side of the deadlock but that's
> > going to be tricky as well :(.
> >   Al, any idea if we could somehow get away without waiting on
> > I_FREEING?
> 
> At which point do we actually run into deadlock on delete side?  We could,
> in principle, skip everything like that in insert_inode_locked(), but
> I would rather avoid the "two inodes in icache at the same time, with the
> same inumber" situations completely.  We might get away with that, since
> everything else *will* wait, so we can afford a bunch of inodes past the
> point in foo_delete_inode() that has cleared it in bitmap + new locked
> one, but if it's at all possible to avoid, I'd rather avoid it.
  The ordering we see on delete when the filesystem is mounted with 'sync'
option is:
  DELETE					CREATE
generic_delete_inode()
  set I_FREEING
  ext3_delete_inode
    get transaction handle
    do work
						get transaction handle
						ext3_new_inode()
						  reallocate inode
						  insert_inode_locked()
    stop transaction, wait for it to commit
    (waiting for CREATE process to drop its
    transaction reference)

  Now similar race can happen even without 'sync' mount option but it's
much harder to hit:
  DELETE					CREATE
generic_delete_inode()
  set I_FREEING
  ext3_delete_inode
						get transaction handle
						ext3_new_inode()
						  reallocate inode
						  insert_inode_locked()
    try to get transaction handle -
      - transaction is too big so we send
      current transaction to commit which
      again waits for CREATE to drop its
      reference.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
