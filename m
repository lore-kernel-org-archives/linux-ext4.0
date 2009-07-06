From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Sun, 5 Jul 2009 22:53:19 -0400
Message-ID: <20090706025319.GG6706@mit.edu>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44429 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZGFCxR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 22:53:17 -0400
Content-Disposition: inline
In-Reply-To: <1245859360-5261-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 24, 2009 at 06:02:40PM +0200, Jan Kara wrote:
> The following race can happen:
> 
>   CPU1                          CPU2
>                                 checkpointing code checks the buffer, adds
>                                   it to an array for writeback
> do_get_write_access()
>   ...
>   lock_buffer()
>   unlock_buffer()
>                                   flush_batch() submits the buffer for IO
>   __jbd2_journal_file_buffer()
> 
>   So a buffer under writeout is returned from do_get_write_access(). Since
> the filesystem code relies on the fact that journaled buffers cannot be
> written out, it does not take the buffer lock and so it can modify buffer
> while it is under writeout. That can lead to a filesystem corruption
> if we crash at the right moment.
>   We fix the problem by clearing the buffer dirty bit under buffer_lock
> even if the buffer is on BJ_None list. Actually, we clear the dirty bit
> regardless the list the buffer is in and warn about the fact if
> the buffer is already journalled.
> 
> Thanks for spotting the problem goes to dingdinghua <dingdinghua85@gmail.com>.
> 
> Reported-by: dingdinghua <dingdinghua85@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied to the ext4 patch queue.

						- Ted
