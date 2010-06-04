From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Fri, 4 Jun 2010 16:45:28 +0200
Message-ID: <20100604144528.GB3414@quack.suse.cz>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <20100603125312.GH24062@thunk.org>
 <20100603141948.GB3814@quack.suse.cz>
 <20100603171058.GC13179@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab0FDOpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jun 2010 10:45:46 -0400
Content-Disposition: inline
In-Reply-To: <20100603171058.GC13179@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-06-10 13:10:58, tytso@mit.edu wrote:
> On Thu, Jun 03, 2010 at 04:19:48PM +0200, Jan Kara wrote:
> > > All of these problems go away if the quota file isn't visible from
> > > userspace, and it becomes a special file.  In the short term I think
> > > we could make this change, but I think we would also have to (1) treat
> > > the quota file as immutable while quotas are enabled (so it cannot be
> > > opened for writing), (2) force an fsync of the quota file and a
> > > journal commit before enabling quotas, and (3) force a journal commit
> > > after disabling quotas.
> >   Ted, that's what generic quota code actually does for you (unless
> > DQUOT_QUOTA_SYS_FILE flag is specified but that's not the case of ext?)
> > - see vfs_load_quota_inode. We do:
> > sync_filesystem(sb);
> > invalidate_bdev(sb->s_bdev);
> > ..
> > inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
> > ..
> >   So unless someone tries to screw us really hard, we should be fine.
> 
> That's good to hear.  I think though we also need to call
> sync_filesystem(sb) in dquot_disable().  Currently it calls
> sb->s_op->sync_fs(), which forces out the superblock, and
> sync_blockdev() which forces out any dirty buffer heads, but it
> doesn't actually force a journal commit so that any pending journaled
> writes to the quota file are forced out.
  sb->s_op->sync_fs() is ext4_sync_fs() which does:

        flush_workqueue(sbi->dio_unwritten_wq);
        if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
                if (wait)
                        jbd2_log_wait_commit(sbi->s_journal, target);
        }

  So it does force out a journal commit and thus quota data. Or am I
missing something?

>  We need to either explicitly
> sync the quota files, or use sync_filesystem(sb) and sync everything.
> The former might be more polite; in fact it might be sufficient in
> vfs_load_quota_inode() as well?  Or am I missing something?
  Syncing quota files in vfs_load_quota_inode() is not enough because
for filesystems with blocksize < pagesize we could still have dirty
buffers in the same blockdev page as used by a quota file. Thus subsequent
invalidate_bdev() does not remove the blockdev's page and kernel will still
see old data (i.e., not new data written by e.g. setquota via page cache).
This cache aliasing with quotas is nasty...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
