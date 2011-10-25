From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in
 balance_dirty_pages
Date: Tue, 25 Oct 2011 15:40:45 +0200
Message-ID: <20111025134045.GB8072@quack.suse.cz>
References: <4EA6A5E5.2050604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466Ab1JYNku (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 09:40:50 -0400
Content-Disposition: inline
In-Reply-To: <4EA6A5E5.2050604@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 25-10-11 21:04:53, Kazuya Mio wrote:
> Write systemcall calls balance_dirty_pages() for direct reclaim.
> However, if ext4 is aborted because of the journal abort, ext4_da_writepages()
> cannot reduce the number of dirty pages because EXT4_MF_FS_ABORTED is set to
> s_mount_flag. banalce_dirty_pages() has a busy loop, and we can pass this loop
> only if the number of dirty pages is less than the threshold. So this function
> loops infinity.
> 
> When write systemcall and kjournald ran at the same time and the disk
> corruption happened, the problem occurred. The kernel version was 3.1-rc9.
> I corrupted the disk on purpose by using dmsetup command.
> 
> 
> process1 (write)                  process2 (kjournald)
> 
> generic_perform_write
>   ext4_da_write_begin
>   ext4_da_write_end
> 
> -------------- detect disk corruption --------------
> 
>                                   jbd2_journal_commit_transaction
>                                      journal_submit_data_buffers
>                                      jbd2_journal_abort
> 
>   balance_dirty_pages
>     writeback_inodes_wb
>       ...
>         ext4_da_writepages           <- do nothing if EXT4_MF_FS_ABORTED is set
>           ext4_journal_start
>             ext4_journal_start_sb    <- detect journal abort
>               ext4_abort             <- set EXT4_MF_FS_ABORTED
  Thanks for report!

> One possible idea to fix this problem is that ext4_da_writepages()
> invalidates the dirty pages if the filesystem has been aborted.
  Please no. Generally this boils down to what do we do with dirty data
when there's error in writing them out. Currently we just throw them away
(e.g. in media error case) but I don't think that's a generally good thing
because e.g. admin may want to copy the data to other working storage or
so. So I think we should rather keep the data and provide a mechanism for
userspace to ask kernel to get rid of the data (so that we don't eventually
run OOM).

> Do you have any ideas?
  So the question is what would you like to achieve. If you just want to
unblock a thread then a solution would be to make a thread at
balance_dirty_pages() killable. If generally you want to get rid of dirty
memory, then I don't have a really good answer but throwing dirty data away
seems like a bad answer to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
