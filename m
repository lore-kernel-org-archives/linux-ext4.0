From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5 resend] VFS: Fix s_umount thaw/write deadlock
Date: Thu, 8 Dec 2011 00:16:58 +0100
Message-ID: <20111207231658.GQ4622@quack.suse.cz>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
 <1323118489-16326-4-git-send-email-kamal@canonical.com>
 <20111206113544.GA21589@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1LGXRA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Dec 2011 18:17:00 -0500
Content-Disposition: inline
In-Reply-To: <20111206113544.GA21589@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-12-11 06:35:44, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 12:54:47PM -0800, Kamal Mostafa wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 73c3992..dbeaede 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -554,6 +554,14 @@ static long writeback_sb_inodes(struct super_block *sb,
> >  	while (!list_empty(&wb->b_io)) {
> >  		struct inode *inode = wb_inode(wb->b_io.prev);
> >  
> > +		if (inode->i_sb == sb && vfs_is_frozen(sb)) {
> > +			/*
> > +			 * Inode is on a frozen superblock; skip it for now.
> > +			 */
> > +			redirty_tail(inode, wb);
> > +			continue;
> > +		}
> > +
> 
> We make sure to not dirty any new inodes after the first phase of the
> freeze, so this should be a BUG_ON/WARN_ON.
  This is not really true in presence of mmaped writes. To block mmaped
writes on a frozen filesystem, we need some synchronization between
page_mkwrite() and freezing code. Currently, to avoid any additional
locking overhead, we set page dirty and *then* check for filesystem being
frozen. Only this order can make sure either the page is written (and
write-protected) or the frozen check triggers and we wait... (see the
comment in block_page_mkwrite()). The nasty sideeffect of this is that
there can be dirty pages & inodes on a frozen filesystem. We are blocked in
the page fault of these pages so user cannot write any data to these pages
but still they are marked dirty.

Alternatively we could have a different mechanism (rw semaphore?) to
synchronize page faults and freezing but I'd hate the overhead for the case
almost noone cares about...

> While we're at it:  can anyway suggest a less cumbersome name than
> writeback_inodes_sb_if_idle?  I'd go for
> try_to_writeback_inodes_sb(_nr).
  Sounds good.

> > index 35f4b0e..47983d9 100644
> > --- a/fs/quota/quota.c
> > +++ b/fs/quota/quota.c
> > @@ -47,7 +47,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
> >  
> >  static void quota_sync_one(struct super_block *sb, void *arg)
> >  {
> > -	if (sb->s_qcop && sb->s_qcop->quota_sync)
> > +	if (sb->s_qcop && sb->s_qcop->quota_sync && !vfs_is_frozen(sb))
> >  		sb->s_qcop->quota_sync(sb, *(int *)arg, 1);
> >  }
> 
> Again, this should be a BUG_ON/WARN_ON.  We shouldn't redirty quotas
> after the freeze.
  You cannot really turn the check into WARN_ON because we iterate over all
superblocks and only in ->quota_sync() check whether something is dirty.
But the check seems to be unnecessary, that is correct.

> > @@ -368,8 +368,18 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
> >  		goto out;
> >  	}
> >  
> > +	/*
> > +	 * It's not clear which quota functions may write to the file
> > +	 * system (all?).  Check for a frozen fs and bail out now.
> > +	 */
> > +	if (vfs_is_frozen(sb)) {
> > +		ret = -EBUSY;
> > +		goto out_drop_super;
> > +	}
> 
> How about spending the three minutes to figure it out?
> Q_GETFMT/Q_GETINFO/Q_XGETQSTAT and Q_GETQUOTA are the obvious read-only
> candidates.
  Q_GETQUOTA can actually cause filesystem modification (reservation of
space in quota file) but the others are read-only. Also after some thought
I'd prefer that quotactl(8) just blocks to be consistent with how other
syscalls behave...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
