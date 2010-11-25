From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of filesystems?
Date: Thu, 25 Nov 2010 11:28:14 +0200
Message-ID: <4CEE2C2E.4010003@panasas.com>
References: <20101125074909.GA4160@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:17342 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KYJ2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 04:28:20 -0500
In-Reply-To: <20101125074909.GA4160@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/25/2010 09:49 AM, Nick Piggin wrote:
> This is a call for review and comments from all filesystem developers.
> Not just those cced, but everyone who maintains a filesystem[*], because
> I wasn't able to put in a lot of time to understand the more complex
> filesystems.
> 
> [*] You all read linux-fsdevel anyway, right? If not, please do, it's
> pretty low volume and high s/n.
> 
> So there seem to be several problems with inode data and metadata
> synchronization. Some of it is bugs in core code, but also a couple
> of oft repeated bugs in filesystems.
> 
> http://marc.info/?l=linux-fsdevel&m=129052164315259&w=2
> 
> Basically 2 patterns of problem.
> 
> First is checking inode dirty bits
> (I_DIRTY/I_DIRTY_SYNC/I_DIRTY_DATASYNC) without locking. What happens is
> that other paths (async writeout or even a concurrent sync or fsync) can
> clear these bits with the data not being on platter.
> 
> * solution: must wait on I_SYNC before testing these things. See my
>   patch in above linked series. I think I covered everyone here, but
>   please double check.
> 
> * There is opportunity in some filesystems for clearing inode dirty bits
>   in fsync, and for checking and avoiding fsync work if dirty bits are
>   not sure.
> 
> Second is confusing sync and async inode metadata writeout
> Core code clears I_DIRTY_SYNC and I_DIRTY_DATASYNC before calling
> ->write_inode *regardless* of whether it is a for-integrity call or
> not. This means background writeback can clear it, and subsequent
> sync_inode_metadata or sync(2) call will skip the next ->write_inode
> completely.
> 
> * solution: for fsync, you must ensure that everything that a
>   synchronous ->write_inode call does is also done by an
>   asynchronous ->write_inode call *plus* a subsequent fsync.
> 
>   So if a synchronous ->write_inode syncs a bh, but an async one
>   just marks it dirty, your .fsync would have to sync the bh.
> 
> * solution: for sync(2), you must ensure that everything that a
>   synchronous ->write_inode call does is also done by an
>   asynchronous ->write_inode call plus a subsequent ->sync_fs
>   call, plus __sync_blockdev call on the buffer mapping.
> 
>   Many simple filesystems just go via buffer mapping, and
>   ->write_inode simply dirties the inode's bh. These guys are
>   fine here (although most are broken wrt fsync).
> 
> If you need any more state bits in your inode to work out what is going
> on, Christoph's recent hfsplus fsync optimisation patches has a good
> example of how it can be done.
> 
> The ext2 fix below is an example of how we can do this nicely, the
> rest of the filesystems I note when it looks like they went wrong, and
> band aid fixed it.
> 
> Index: linux-2.6/fs/exofs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/inode.c	2010-11-25 17:25:54.000000000 +1100
> +++ linux-2.6/fs/exofs/inode.c	2010-11-25 17:36:32.000000000 +1100
> @@ -1273,7 +1273,7 @@ static int exofs_update_inode(struct ino
>  
>  int exofs_write_inode(struct inode *inode, struct writeback_control *wbc)
>  {
> -	return exofs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
> +	return exofs_update_inode(inode, 1 /* XXX: fix fsync and use wbc->sync_mode == WB_SYNC_ALL */ );
>  }
>  
>  /*

Hi Nick.
Thanks for digging into this issue, I bet it's causing pain. Which
I totally missed in my tests. I wish I had a better xsync+reboot
tests for all this.

So in that previous patch you had:
> Index: linux-2.6/fs/exofs/file.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/file.c	2010-11-19 16:50:00.000000000 +1100
> +++ linux-2.6/fs/exofs/file.c	2010-11-19 16:50:07.000000000 +1100
> @@ -48,11 +48,6 @@ static int exofs_file_fsync(struct file
>  	struct inode *inode = filp->f_mapping->host;
>  	struct super_block *sb;
>  
> -	if (!(inode->i_state & I_DIRTY))
> -		return 0;
> -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> -		return 0;
> -
>  	ret = sync_inode_metadata(inode, 1);
>  
>  	/* This is a good place to write the sb */
> 

Is that a good enough fix for the issue in your opinion?
Or is there more involved?

In exofs there is nothing special to do other than VFS
managment and the final call, by vfs, to .write_inode.

I wish we had a simple_file_fsync() from VFS that does
what the VFS expects us to do. So when code evolves it
does not need to change all FSs. This is the third time
I'm fixing this code trying to second guess the VFS.

Actually the only other thing I need to do in file_fsync
today is sb_sync. But this is a stupidity (and a bug) that
I'm fixing soon. So that theoretical simple_file_fsync()
would be all I need.

Please advise?
BTW: Do you want that I take the changes through my tree?

Thanks for taking care of this
Boaz
