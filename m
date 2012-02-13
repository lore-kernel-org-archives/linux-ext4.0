From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous
 direct I/O requests
Date: Mon, 13 Feb 2012 19:27:54 +0100
Message-ID: <20120213182754.GA17591@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
 <1327698949-12616-3-git-send-email-jmoyer@redhat.com>
 <20120202173120.GA6640@quack.suse.cz>
 <x491uq51hsc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab2BMS15 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 13:27:57 -0500
Content-Disposition: inline
In-Reply-To: <x491uq51hsc.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-02-12 10:11:47, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Look at what ext4_sync_file() does. It's more efficient than this.
> > You need something like:
> > 	commit_tid = file->f_flags & __O_SYNC ? EXT4_I(inode)->i_sync_tid :
> > 						EXT4_I(inode)->i_datasync_tid;
> > 	if (journal->j_flags & JBD2_BARRIER &&
> > 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
> > 		needs_barrier = true;
> > 	jbd2_log_start_commit(journal, commit_tid);
> > 	jbd2_log_wait_commit(journal, commit_tid);
> > 	if (needs_barrier)
> > 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
> 
> If the transaction won't send a data barrier, wouldn't you want to issue
> the flush on the data device prior to commiting the transaction, not
> after it?
  Sorry for late reply. I was thinking about this because the answer isn't
simple... One certain fact is that once ext4_convert_unwritten_extents()
finishes (calls ext4_journal_stop()), the transaction with metadata updates
can commit so whether we place flush before or after jbd2_log_start_commit()
makes no difference. For filesystems where journal is on the filesystem
device, the code should work correctly as is - journalling code will issue
the barrier before transaction commit is done and if there is no
transaction to commit, the place where we issue cache flush does not matter.
But for filesystems where journal is on separate device we indeed need to
issue the flush before the transaction commit is finished so that we
don't expose uninitialized data after crash.

Anyway that's a separate (although related) issue to the one which you fix
in this patch so you can leave the patch as is and I'll fixup the above
problem in a separate patch. Thanks for noticing this!

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
