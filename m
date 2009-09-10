From: Jan Kara <jack@suse.cz>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 11:15:32 +0200
Message-ID: <20090910091532.GE607@duck.suse.cz>
References: <20090908132601.GA17778@duck.suse.cz> <20090910064605.GA8690@skywalker.linux.vnet.ibm.com> <20090910085056.GA607@duck.suse.cz> <20090910090449.GA11418@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZIJJPb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 05:15:31 -0400
Content-Disposition: inline
In-Reply-To: <20090910090449.GA11418@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-09-09 14:34:49, Aneesh Kumar K.V wrote:
> On Thu, Sep 10, 2009 at 10:50:56AM +0200, Jan Kara wrote:
> >   Hi,
> > 
> > On Thu 10-09-09 12:16:05, Aneesh Kumar K.V wrote:
> > > On Tue, Sep 08, 2009 at 03:26:01PM +0200, Jan Kara wrote:
> > > >   When looking at how ext3/4 handles fsync, I've realized I don't
> > > > understand how writing out inode on fsync can work. The problem is that
> > > > ext3/4 mostly calls ext?_mark_inode_dirty() which actually does *not* dirty
> > > > the inode. It just copies the in-memory inode content to disk buffer.
> > > > So in particular the inode looks clean to VFS and our check in
> > > > ext?_sync_file() shouldn't trigger.
> > > >   The only obvious case when we call mark_inode_dirty() is from write_end
> > > > functions when we update i_size but that's clearly not enough. Now I did
> > > > some research why things seem to be actually working. The trick is that
> > > > when allocating block, we call vfs_dq_alloc_block() which calls
> > > > mark_inode_dirty(). But that's all what's keeping our fsync / writeout
> > > > logic from breaking!
> > > 
> > > ext4_handle_dirty_metadata should do mark_inode_dirty right ?
> > > __ext4_handle_dirty_metadata -> mark_buffer_dirty ->__set_page_dirty
> > > -> __mark_inode_dirty ->  list_move(&inode->i_list, &sb->s_dirty);
> >   ext4_handle_dirty_metadata() marks the buffer dirty only when we do not
> > have a journal (BTW, the inode that gets dirtied in the nojournal case
> > is the block-device one, not the one whose metadata we mark as dirty, so
> > it won't work there either - but Google guys are working on this I think).
> > With a journal the function just calls jbd2_journal_dirty_metadata which
> > does nothing with the inode.
> 
> When we don't have a journal handle we do that as a part of journal commit
          ^^^^^ you meant probably "do"

> right ? __jbd2_journal_temp_unlink_buffer -> mark_buffer_dirty  
  Yes, that happens. But as I said above:
a) mark_buffer_dirty() dirties blockdevice inode and thus not the one we
   check in ext4_sync_file().
b) this happens only after we commit the transaction and only if the buffer
   is not part of the next transaction.
  Believe me, I've actually checked with blktrace, that the code does not
work in some cases ;).

> I guess fsync only requires the meta data update to be in journal ?
  Yes, to be more precise, it requires transaction with the metadata update
to be committed. And the problem is we force a transaction commit in
ext4_sync_file() only if the inode has a dirty bit set - which is
accidentally set only by quota code.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
