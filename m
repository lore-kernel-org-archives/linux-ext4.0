Return-Path: <SRS0=q/KL=MW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41158 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbeJKBMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Oct 2018 21:12:52 -0400
Date: Wed, 10 Oct 2018 13:49:34 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: jbd2_clear_buffer_revoked_flags() takes a long time
Message-ID: <20181010174934.GA19601@thunk.org>
References: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2018 at 04:43:27PM +0300, Adrian Hunter wrote:
> Hi
> 
> I have a case on a v4.14 kernel where the EXT4 journal commit disables
> preemption for 30ms due to jbd2_clear_buffer_revoked_flags().  That in turn
> disables preemption on other CPUs as they come to spin waiting for the same
> lock.  The side-effect of that is that it periodically blocks high priority
> tasks from running.
> 
> I see jbd2_clear_buffer_revoked_flags() iterating 32768 times calling
> __find_get_block().
> 
> Is there any way to make jbd2_clear_buffer_revoked_flags() take less time,
> or move its work out from under write_lock(&journal->j_state_lock)?

Hmm.... I'd have to look a bit more carefully and then run some tests,
but I *think* we can drop the j_state_lock at the beginning of JBD2
commit phase 1, and then grab it again right before we set
commit_transaction->t_state to T_FLUSH.

That should be safe because while the transaction state is T_LOCKED,
we can't start any new handles, so there can't be any new blocks added
to the revoke table.

Can you give that a try and see whether that solves your priority
inversion problem?

Cheers,

						- Ted
