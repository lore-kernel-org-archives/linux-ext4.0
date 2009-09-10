From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 12:16:05 +0530
Message-ID: <20090910064605.GA8690@skywalker.linux.vnet.ibm.com>
References: <20090908132601.GA17778@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:57882 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZIJGqF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 02:46:05 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp07.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8A6k6Oj025924
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:16:06 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A6k6Zi1511570
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:16:06 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8A6k6iD011397
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 16:46:06 +1000
Content-Disposition: inline
In-Reply-To: <20090908132601.GA17778@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 03:26:01PM +0200, Jan Kara wrote:
>   Hi,
> 
>   When looking at how ext3/4 handles fsync, I've realized I don't
> understand how writing out inode on fsync can work. The problem is that
> ext3/4 mostly calls ext?_mark_inode_dirty() which actually does *not* dirty
> the inode. It just copies the in-memory inode content to disk buffer.
> So in particular the inode looks clean to VFS and our check in
> ext?_sync_file() shouldn't trigger.
>   The only obvious case when we call mark_inode_dirty() is from write_end
> functions when we update i_size but that's clearly not enough. Now I did
> some research why things seem to be actually working. The trick is that
> when allocating block, we call vfs_dq_alloc_block() which calls
> mark_inode_dirty(). But that's all what's keeping our fsync / writeout
> logic from breaking!

ext4_handle_dirty_metadata should do mark_inode_dirty right ?
__ext4_handle_dirty_metadata -> mark_buffer_dirty ->__set_page_dirty
-> __mark_inode_dirty ->  list_move(&inode->i_list, &sb->s_dirty);



>   There are even some cases when the logic actually is broken (I've tested
> it and it really does not work) - for example when you create an empty
> file, the inode won't get written when you fsync it.
>   So what we should IMHO do is to convert all ext?_mark_inode_dirty()
> calls to simple mark_inode_dirty() (or even maybe introduce and use
> mark_inode_dirty_datasync() where appropriate). It will cost us some more
> CPU and stack space but if we optimize ext3_dirty_inode() for the case
> where handle is already started, it shouldn't be too bad.


-aneesh
