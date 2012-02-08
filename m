From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
Date: Wed, 08 Feb 2012 10:11:47 -0500
Message-ID: <x491uq51hsc.fsf@segfault.boston.devel.redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-3-git-send-email-jmoyer@redhat.com>
	<20120202173120.GA6640@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab2BHPMN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 10:12:13 -0500
In-Reply-To: <20120202173120.GA6640@quack.suse.cz> (Jan Kara's message of
	"Thu, 2 Feb 2012 18:31:20 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Look at what ext4_sync_file() does. It's more efficient than this.
> You need something like:
> 	commit_tid = file->f_flags & __O_SYNC ? EXT4_I(inode)->i_sync_tid :
> 						EXT4_I(inode)->i_datasync_tid;
> 	if (journal->j_flags & JBD2_BARRIER &&
> 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
> 		needs_barrier = true;
> 	jbd2_log_start_commit(journal, commit_tid);
> 	jbd2_log_wait_commit(journal, commit_tid);
> 	if (needs_barrier)
> 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);

If the transaction won't send a data barrier, wouldn't you want to issue
the flush on the data device prior to commiting the transaction, not
after it?

-Jeff
