From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix waiting and sending of a barrier in
 ext4_sync_file()
Date: Mon, 23 May 2011 22:25:19 +0200
Message-ID: <20110523202519.GI4716@quack.suse.cz>
References: <20110522211239.GB10009@thunk.org>
 <1306098825-469-2-git-send-email-tytso@mit.edu>
 <20110523171747.GG4716@quack.suse.cz>
 <20110523192834.GK10009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44582 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1EWUZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 16:25:22 -0400
Content-Disposition: inline
In-Reply-To: <20110523192834.GK10009@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-05-11 15:28:34, Ted Tso wrote:
> On Mon, May 23, 2011 at 07:17:47PM +0200, Jan Kara wrote:
> > b) Whether we do or don't send the flush in
> > jbd2_journal_commit_transaction() depends on whether t_flushed_data_blocks
> > is set.  We can't know in advance whether it gets set or not because it
> > depends on whether some inode is in transaction's t_inode_list and inodes
> > can get removed from there when flusher thread has written all the pages
> > and inode has been reclaimed. OTOH this looks like a bug in the commit code
> > anyway - I guess t_flushed_data_blocks (or better named equivalent) should
> > be set in jbd2_journal_file_inode(). Then such variable will also become
> > a reliable indicator whether the data flush is going to be sent or not.
> 
> Um, I guess I don't see where an inode gets removed from t_inode_list
> after the writeback daemon is done with an inode?
  ext4_evict_inode()->ext4_clear_inode()->jbd2_journal_release_jbd_inode()
removes the inode from transaction's list. Note that nothing prevents inode
which is still part of the running transaction to be cleaned by a flusher
thread and thus inode shrinker can reap it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
