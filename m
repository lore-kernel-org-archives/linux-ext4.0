From: Jan Kara <jack@suse.cz>
Subject: Re: bdi has dirty inode after umount of ext4 fs in 3.4.83
Date: Wed, 26 Mar 2014 06:32:46 +0100
Message-ID: <20140326053246.GA1292@quack.suse.cz>
References: <20140321152541.GA23173@kvack.org>
 <20140323131416.GD2813@quack.suse.cz>
 <20140325220938.GX4173@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaCZFcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2014 01:32:52 -0400
Content-Disposition: inline
In-Reply-To: <20140325220938.GX4173@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 25-03-14 18:09:38, Benjamin LaHaise wrote:
> On Sun, Mar 23, 2014 at 02:14:16PM +0100, Jan Kara wrote:
> >   So the dirty inode is almost certainly a block device inode. Another clue
> > is that fsync(2) actually doesn't clean inode dirty state (especially not
> > for block device inodes since that inode is a special one and fs usually
> > doesn't get to inspecting it). sync(2) does in general clear inode dirty
> > state because that's handled by flusher thread. However if ->sync_fs()
> > dirties the block device inode, subsequent sync_blockdev() call only writes
> > the data but doesn't clean the inode state. So even with sync(2) it can
> > happen the block device inode remains dirty.
> 
> > In general inode dirty state isn't reliable. I_DIRTY_DATA can be set when
> > inode is in fact clean. You have to use mapping_tagged(inode->i_mapping,
> > PAGECACHE_TAG_DIRTY) to determine whether the inode has actually any dirty
> > data.
> 
> That is indeed the case.  I checked the contents of the inode, and none of 
> the buffers attached to that inode were dirty.
> 
> Is there any desire to fix this?  Seeing an inode on the b_dirty list that 
> isn't really an inode that contains any data doesn't make a whole lot of 
> sense.
  It doesn't make a lot of sense but this kind of lazy b_dirty management
allows us to avoid synchronization issues with flusher working in the inode
at the same time. So I'm not convinced we want to fix that...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
