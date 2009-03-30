From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Mon, 30 Mar 2009 16:28:21 +0530
Message-ID: <20090330105821.GE4796@skywalker>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker> <20090330103248.GB18833@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:49430 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZC3K6a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 06:58:30 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp09.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2UATcYx016910
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:59:38 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UAsjGE3526766
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 16:24:45 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2UAwN4m025427
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:58:23 +1100
Content-Disposition: inline
In-Reply-To: <20090330103248.GB18833@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 12:32:48PM +0200, Jan Kara wrote:
> > > > > -				struct address_space *mapping,
> > > > > -				loff_t pos, unsigned len, unsigned copied,
> > > > > -				struct page *page, void *fsdata)
> > > > > +static void update_file_sizes(struct inode *inode, loff_t pos, unsigned len,
> > > > > +			      unsigned copied)
> > > > >  {
> > > > > -	struct inode *inode = file->f_mapping->host;
> > > > > -
> > > > > -	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> > > > > +	int mark_dirty = 0;
> > > > > 
> > > > > -	if (pos+copied > inode->i_size) {
> > > > > -		i_size_write(inode, pos+copied);
> > > > > -		mark_inode_dirty(inode);
> > > > > +	if (pos + len > EXT3_I(inode)->i_disksize) {
> > > > > +		mark_dirty = 1;
> > > > > +		EXT3_I(inode)->i_disksize = pos + len;
> > > > >  	}
> > > > 
> > > > Won't this result in file having wrong contents if we failed to copy
> > > > the contents from user space? Now if we successfully allocated
> > > > blocks and we failed to copy the contents from user space, the above
> > > > would result in update of i_disksize and a mark_inode_dirty. Doesn't
> > > > that imply we have wrong contents in those block for which we failed to
> > > > copy the contents from user space ?
> > >   block_write_end() zeros all new buffers. So yes, if we crash after
> > > this transaction commits but before we manage to redo the write, then user
> > > could see zeros at the end of file (previously inode could have blocks
> > > allocated beyond EOF).
> > >   I was also thinking about truncating the newly created buffers but it's a
> > > bit tricky. We need to do it in the same transaction (otherwise the race
> > > would be still there) but standard truncate path would like to add inode
> > > to the orphan list, lock pages etc and we have no credits for that and also
> > > lock ordering might be troublesome. So I've chosen the simple path.
> > > 
> > We do a vmtruncate if we failed to allocate blocks in
> > ext3_write_begin. That is done after the closing the current
> > transaction. If we crash in between (ie, after committing the
> > transaction allocating blocks and before committing the transaction that
> > is doing truncate) we would only have  some data blocks leaking. But
> > that would be better than user seeing zero's in the file ?. Also if we
> > happen to add the inode to the orphan list and crash, the recovery would
> > truncate it properly. So by doing a vmtruncate I guess the window would be
> > small and we are already doing that in ext3_write_begin.
>   Hmm, are you sure some assertion would not fire if we find allocated
> blocks beyond i_size (which could happen with the old code)? Frankly, I
> prefer user seeing zeros at the end of file (so that he can come and yell
> at me ;) rather than silently leaking blocks, getting inode into an
> unexpected state and then debug some mysterious problem. But hopefully this
> problem has a solution which can make both of us happy ;): We can reserve
> enough credits (actually just one block more) and when we see we need to
> do truncate because of failed write, we first add inode to the orphan list
> before stopping the current handle (so that if we crash it gets properly
> truncated) and then truncate the blocks in a separate transaction. Does it
> sound good to you?

Yes. We also should unlock the page before the truncate

-aneesh
