From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] jbd2: Avoid unnecessary locking when buffer is
 already journaled
Date: Thu, 2 Apr 2015 10:23:51 -0400
Message-ID: <20150402142351.GE6873@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47060 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbbDBOXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 10:23:53 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:15PM +0200, Jan Kara wrote:
> 
>   this patch set improves do_get_write_access(), jbd2_journal_get_undo_access(),
> and jbd2_journal_dirty_metadata() to be completely lockless in case buffer
> is already part of an appropriate journalling list. First three patches
> are independent small cleanups so they can go in right away I think.
> 
> The other two patches *should* improve the situation for frequent bitmap
> or inode table block updates. But frankly, I haven't been able to come up
> with a load where I'd see significant contention on update of a single buffer
> (or it's hidden by a larger lock). Similarly we could see improvements when
> do_get_write_access() would be waiting for buffer lock because buffer is
> being written out by checkpointing code. But again I wasn't able to hit this
> reliably.
> 
> Ted, you mentioned at Vault you had a setup where frequent
> do_get_write_access() calls were contending in the revoke code. What was the
> load exactly? These patches should improve that as well...

Use a 32-core Intel processor with 128GB memory; create a 32GB ram
disk, but ext4 on it, and then run your favorite scalability workload
on it.  I used a random 4k write workload, and noted that we were
calling start_handle() all the time.  This was fixed in dioread_nolock
since we check to see if it's an overwrite.

I'll have to look at this again, but I remember thinking that we could
push the overwrite check down a level, and with a few other tweaks,
end up fixing the AIO race condition you were worrying about it, as
well as skipping the start_handle() call in the case where we know
we're doing an overwrite in all cases, not just dioread_nolock.

Cheers,

					- Ted
