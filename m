From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix lockdep splat with generic/270 test
Date: Sat, 29 Apr 2017 20:28:17 -0400
Message-ID: <20170430002817.ye73lwkvndn2jm42@thunk.org>
References: <20170411134644.9354-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33324 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033549AbdD3A2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 20:28:20 -0400
Content-Disposition: inline
In-Reply-To: <20170411134644.9354-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 11, 2017 at 03:46:44PM +0200, Jan Kara wrote:
> I've hit a lockdep splat with generic/270 test complaining that:
> 
> 3216.fsstress.b/3533 is trying to acquire lock:
>  (jbd2_handle){++++..}, at: [<ffffffff813152e0>] jbd2_log_wait_commit+0x0/0x150
> 
> but task is already holding lock:
>  (jbd2_handle){++++..}, at: [<ffffffff8130bd3b>] start_this_handle+0x35b/0x850
> 
> The underlying problem is that jbd2_journal_force_commit_nested()
> (called from ext4_should_retry_alloc()) may get called while a
> transaction handle is started. In such case it takes care to not wait
> for commit of the running transaction (which would deadlock) but only
> for a commit of a transaction that is already committing (which is safe
> as that doesn't wait for any filesystem locks).
> 
> In fact there are also other callers of jbd2_log_wait_commit() that take
> care to pass tid of a transaction that is already committing and for
> those cases, the lockdep instrumentation is too restrictive and leading
> to false positive reports. Fix the problem by calling
> jbd2_might_wait_for_commit() from jbd2_log_wait_commit() only if the
> transaction isn't already committing.
> 
> Fixes: 1eaa566d368b214d99cbb973647c1b0b8102a9ae
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
