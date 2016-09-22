From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix lockdep annotation in add_transaction_credits()
Date: Thu, 22 Sep 2016 11:47:18 -0400
Message-ID: <20160922154718.v4drz3ar64saaxnd@thunk.org>
References: <1474288243-584-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50772 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753108AbcIVPst (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Sep 2016 11:48:49 -0400
Content-Disposition: inline
In-Reply-To: <1474288243-584-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 19, 2016 at 02:30:43PM +0200, Jan Kara wrote:
> Thomas has reported a lockdep splat hitting in
> add_transaction_credits(). The problem is that that function calls
> jbd2_might_wait_for_commit() while holding j_state_lock which is wrong
> (we do not really wait for transaction commit while holding that lock).
> 
> Fix the problem by moving jbd2_might_wait_for_commit() into places where
> we are ready to wait for transaction commit and thus j_state_lock is
> unlocked.
> 
> Fixes: 1eaa566d368b214d99cbb973647c1b0b8102a9ae
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
