Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34266 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbeJFF57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 Oct 2018 01:57:59 -0400
Date: Fri, 5 Oct 2018 18:57:05 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Message-ID: <20181005225705.GA2548@thunk.org>
References: <20181004104640.28326-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004104640.28326-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2018 at 12:46:40PM +0200, Jan Kara wrote:
> The code cleaning transaction's lists of checkpoint buffers has a bug
> where it increases bh refcount only after releasing
> journal->j_list_lock. Thus the following race is possible:
> 
> CPU0					CPU1
> jbd2_log_do_checkpoint()
> 					jbd2_journal_try_to_free_buffers()
> 					  __journal_try_to_free_buffer(bh)
>   ...
>   while (transaction->t_checkpoint_io_list)
>   ...
>     if (buffer_locked(bh)) {
> 
> <-- IO completes now, buffer gets unlocked -->
> 
>       spin_unlock(&journal->j_list_lock);
> 					    spin_lock(&journal->j_list_lock);
> 					    __jbd2_journal_remove_checkpoint(jh);
> 					    spin_unlock(&journal->j_list_lock);
> 					  try_to_free_buffers(page);
>       get_bh(bh) <-- accesses freed bh
> 
> Fix the problem by grabbing bh reference before unlocking
> journal->j_list_lock.
> 
> Fixes: dc6e8d669cf5cb3ff84707c372c0a2a8a5e80845
> Fixes: be1158cc615fd723552f0d9912087423c7cadda5
> Reported-by: syzbot+7f4a27091759e2fe7453@syzkaller.appspotmail.com
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks (with the Fixes field adjusted).

					- Ted
