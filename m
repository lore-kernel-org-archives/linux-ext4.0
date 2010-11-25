From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of
 filesystems?
Date: Thu, 25 Nov 2010 07:01:33 -0500
Message-ID: <20101125120133.GA22222@infradead.org>
References: <20101125074909.GA4160@amd>
 <20101125115457.GB3643@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Boaz Harrosh <bharrosh@panasas.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0KYMBl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 07:01:41 -0500
Content-Disposition: inline
In-Reply-To: <20101125115457.GB3643@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 25, 2010 at 10:54:57PM +1100, Nick Piggin wrote:
> On Thu, Nov 25, 2010 at 06:49:09PM +1100, Nick Piggin wrote:
> > Second is confusing sync and async inode metadata writeout
> > Core code clears I_DIRTY_SYNC and I_DIRTY_DATASYNC before calling
> > ->write_inode *regardless* of whether it is a for-integrity call or
> > not. This means background writeback can clear it, and subsequent
> > sync_inode_metadata or sync(2) call will skip the next ->write_inode
> > completely.
> 
> Hmm, this also means that write_inode_now(sync=1) is buggy. It
> needs to in fact call ->fsync -- which is a file operation
> unfortunately, Christoph didn't you have some patches to move it
> into an inode operation?

No, it doesn't really make much sense either.  But what I've slowly
started doing is to phase out write_inode_now.  For the cases where
we really only want to write the inode we should use
sync_inode_metadata.  That only leaves two others callsers:

 - iput_final for a filesystem during unmount.  This should be caught
   by the need to call ->sync_fs rule you mentioned above, but needs
   a closer audit.
 - nfsd.  Any filesystem that cares should just use the commit_metadata
   export operations, which is a subsystem of ->fsync as it only need
   to guarantee that metadata is on disk, but not actually any file
   data - so no cache flush mess as in a real fsync implementation.

