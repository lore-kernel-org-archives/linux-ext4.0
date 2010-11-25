From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of
 filesystems?
Date: Thu, 25 Nov 2010 21:06:03 +1100
Message-ID: <20101125100603.GA3164@amd>
References: <20101125074909.GA4160@amd>
 <4CEE2C2E.4010003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37406 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab0KYKGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Nov 2010 05:06:11 -0500
Content-Disposition: inline
In-Reply-To: <4CEE2C2E.4010003@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 25, 2010 at 11:28:14AM +0200, Boaz Harrosh wrote:
> Hi Nick.
> Thanks for digging into this issue, I bet it's causing pain. Which
> I totally missed in my tests. I wish I had a better xsync+reboot
> tests for all this.

That's no problem, thanks for looking.


> So in that previous patch you had:
> > Index: linux-2.6/fs/exofs/file.c
> > ===================================================================
> > --- linux-2.6.orig/fs/exofs/file.c	2010-11-19 16:50:00.000000000 +1100
> > +++ linux-2.6/fs/exofs/file.c	2010-11-19 16:50:07.000000000 +1100
> > @@ -48,11 +48,6 @@ static int exofs_file_fsync(struct file
> >  	struct inode *inode = filp->f_mapping->host;
> >  	struct super_block *sb;
> >  
> > -	if (!(inode->i_state & I_DIRTY))
> > -		return 0;
> > -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > -		return 0;
> > -
> >  	ret = sync_inode_metadata(inode, 1);
> >  
> >  	/* This is a good place to write the sb */
> > 
> 
> Is that a good enough fix for the issue in your opinion?
> Or is there more involved?

For the inode dirty bit race problem, yes it should fix it.
sync_inode_metadata basically makes the same checks without
races (in a subsequent patch I re-introduced the datasync
optimisation).

 
> In exofs there is nothing special to do other than VFS
> managment and the final call, by vfs, to .write_inode.
> 
> I wish we had a simple_file_fsync() from VFS that does
> what the VFS expects us to do. So when code evolves it
> does not need to change all FSs. This is the third time
> I'm fixing this code trying to second guess the VFS.

Well in your fsync, you need to wait for inode writeback
that might have been started by an asynchronous write_inode.

Also, with your sync_inode_metadata call, you shouldn't need the
sync_inode call by the looks.
 
> Actually the only other thing I need to do in file_fsync
> today is sb_sync. But this is a stupidity (and a bug) that
> I'm fixing soon. So that theoretical simple_file_fsync()
> would be all I need.
> 
> Please advise?
> BTW: Do you want that I take the changes through my tree?

At this point I'd just like some review and feedback, we
might get some other opinions on how to fix it, so don't
take the changes quite yet.

I'll cc you again with a broken out patch.

Thanks,
Nick

