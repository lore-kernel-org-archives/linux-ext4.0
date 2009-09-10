From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 14:34:49 +0530
Message-ID: <20090910090449.GA11418@skywalker.linux.vnet.ibm.com>
References: <20090908132601.GA17778@duck.suse.cz>
 <20090910064605.GA8690@skywalker.linux.vnet.ibm.com>
 <20090910085056.GA607@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58943 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZIJJFO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 05:05:14 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8A90p4t011294
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 19:00:51 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A95Gal565460
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 19:05:16 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8A95GaN019056
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 19:05:16 +1000
Content-Disposition: inline
In-Reply-To: <20090910085056.GA607@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 10:50:56AM +0200, Jan Kara wrote:
>   Hi,
> 
> On Thu 10-09-09 12:16:05, Aneesh Kumar K.V wrote:
> > On Tue, Sep 08, 2009 at 03:26:01PM +0200, Jan Kara wrote:
> > >   When looking at how ext3/4 handles fsync, I've realized I don't
> > > understand how writing out inode on fsync can work. The problem is that
> > > ext3/4 mostly calls ext?_mark_inode_dirty() which actually does *not* dirty
> > > the inode. It just copies the in-memory inode content to disk buffer.
> > > So in particular the inode looks clean to VFS and our check in
> > > ext?_sync_file() shouldn't trigger.
> > >   The only obvious case when we call mark_inode_dirty() is from write_end
> > > functions when we update i_size but that's clearly not enough. Now I did
> > > some research why things seem to be actually working. The trick is that
> > > when allocating block, we call vfs_dq_alloc_block() which calls
> > > mark_inode_dirty(). But that's all what's keeping our fsync / writeout
> > > logic from breaking!
> > 
> > ext4_handle_dirty_metadata should do mark_inode_dirty right ?
> > __ext4_handle_dirty_metadata -> mark_buffer_dirty ->__set_page_dirty
> > -> __mark_inode_dirty ->  list_move(&inode->i_list, &sb->s_dirty);
>   ext4_handle_dirty_metadata() marks the buffer dirty only when we do not
> have a journal (BTW, the inode that gets dirtied in the nojournal case
> is the block-device one, not the one whose metadata we mark as dirty, so
> it won't work there either - but Google guys are working on this I think).
> With a journal the function just calls jbd2_journal_dirty_metadata which
> does nothing with the inode.

When we don't have a journal handle we do that as a part of journal commit
right ? __jbd2_journal_temp_unlink_buffer -> mark_buffer_dirty  

I guess fsync only requires the meta data update to be in journal ?

-aneesh
