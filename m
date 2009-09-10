From: Jan Kara <jack@suse.cz>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 14:32:39 +0200
Message-ID: <20090910123239.GH607@duck.suse.cz>
References: <20090908132601.GA17778@duck.suse.cz> <20090910064605.GA8690@skywalker.linux.vnet.ibm.com> <20090910085056.GA607@duck.suse.cz> <20090910090449.GA11418@skywalker.linux.vnet.ibm.com> <20090910091551.GB11418@skywalker.linux.vnet.ibm.com> <20090910105216.GG607@duck.suse.cz> <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZIJMci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 08:32:38 -0400
Content-Disposition: inline
In-Reply-To: <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-09-09 16:34:55, Aneesh Kumar K.V wrote:
> On Thu, Sep 10, 2009 at 12:52:16PM +0200, Jan Kara wrote:
> > On Thu 10-09-09 14:45:51, Aneesh Kumar K.V wrote:
> > > On Thu, Sep 10, 2009 at 02:34:49PM +0530, Aneesh Kumar K.V wrote:
> > > > On Thu, Sep 10, 2009 at 10:50:56AM +0200, Jan Kara wrote:
> > > > >   Hi,
> > > > > 
> > > > > On Thu 10-09-09 12:16:05, Aneesh Kumar K.V wrote:
> > > > > > On Tue, Sep 08, 2009 at 03:26:01PM +0200, Jan Kara wrote:
> > > > > > >   When looking at how ext3/4 handles fsync, I've realized I don't
> > > > > > > understand how writing out inode on fsync can work. The problem is that
> > > > > > > ext3/4 mostly calls ext?_mark_inode_dirty() which actually does *not* dirty
> > > > > > > the inode. It just copies the in-memory inode content to disk buffer.
> > > > > > > So in particular the inode looks clean to VFS and our check in
> > > > > > > ext?_sync_file() shouldn't trigger.
> > > > > > >   The only obvious case when we call mark_inode_dirty() is from write_end
> > > > > > > functions when we update i_size but that's clearly not enough. Now I did
> > > > > > > some research why things seem to be actually working. The trick is that
> > > > > > > when allocating block, we call vfs_dq_alloc_block() which calls
> > > > > > > mark_inode_dirty(). But that's all what's keeping our fsync / writeout
> > > > > > > logic from breaking!
> > > > > > 
> > > > > > ext4_handle_dirty_metadata should do mark_inode_dirty right ?
> > > > > > __ext4_handle_dirty_metadata -> mark_buffer_dirty ->__set_page_dirty
> > > > > > -> __mark_inode_dirty ->  list_move(&inode->i_list, &sb->s_dirty);
> > > > >   ext4_handle_dirty_metadata() marks the buffer dirty only when we do not
> > > > > have a journal (BTW, the inode that gets dirtied in the nojournal case
> > > > > is the block-device one, not the one whose metadata we mark as dirty, so
> > > > > it won't work there either - but Google guys are working on this I think).
> > > > > With a journal the function just calls jbd2_journal_dirty_metadata which
> > > > > does nothing with the inode.
> > > > 
> > > > When we don't have a journal handle we do that as a part of journal commit
> > > > right ? __jbd2_journal_temp_unlink_buffer -> mark_buffer_dirty  
> > > > 
> > > > I guess fsync only requires the meta data update to be in journal ?
> > > > 
> > > 
> > > Adding the file inode to the sb->s_dirty is done through block_write_end ?
> > > Why do you mention above that it is not "clearly not enough" ?
> >   Where? I don't see block_write_end() marking the inode dirty anywhere...
> > It calls __block_commit_write() and that dirties only buffers, not the
> > inode.
> mark_buffer_dirty -> __set_page_dirty -> __mark_inode_dirty
  OK, but that sets only I_DIRTY_PAGES not I_DIRTY_DATA or I_DIRTY.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
