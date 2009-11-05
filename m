From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/27] BKL: Remove BKL from ext2 filesystem
Date: Thu, 5 Nov 2009 14:56:52 +0100
Message-ID: <20091105135651.GE12770@duck.suse.cz>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-6-git-send-email-jblunck@suse.de> <20091105124111.GC12770@duck.suse.cz> <20091105130635.GE21750@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbZKEN4r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2009 08:56:47 -0500
Content-Disposition: inline
In-Reply-To: <20091105130635.GE21750@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-11-09 14:06:35, Jan Blunck wrote:
> On Thu, Nov 05, Jan Kara wrote:
> 
> > On Mon 02-11-09 11:04:45, Jan Blunck wrote:
> > > The BKL is still used in ext2_put_super(), ext2_fill_super(), ext2_sync_fs()
> > > ext2_remount() and ext2_write_inode(). From these calls ext2_put_super(),
> > > ext2_fill_super() and ext2_remount() are protected against each other by
> > > the struct super_block s_umount rw semaphore. The call in ext2_write_inode()
> > > could only protect the modification of the ext2_sb_info through
> > > ext2_update_dynamic_rev() against concurrent ext2_sync_fs() or ext2_remount().
> > > ext2_fill_super() and ext2_put_super() can be left out because you need a
> > > valid filesystem reference in all three cases, which you do not have when
> > > you are one of these functions.
> >   This is not quite true. Actually, ext2_sync_fs() is called also with
> > s_umount held (for reading) so it cannot race with any of the mounting /
> > umounting functions. But it should probably be guarded against running two
> > instances of ext2_sync_fs() in parallel.
> >   Looking into the code, we probably have a race in ext2_write_inode that
> > two threads can write one inode in parallel. But that's a separe issue from
> > BKL removal.
> 
> Have you actually seen that the previous patch introduces s_mutex? Meanwhile
> that mutex has been replaced by a spinlock due to Andy's feedback.
  Ops, I wanted to comment on that patch as well but then decided it might
be better to write my version and didn't get to it yet... Thinking more
about it, probably go ahead with these two patches (modulo some changes
I've now suggested in a reply to your second ext2 patch) and I can cleanup
ext2 code after that.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
