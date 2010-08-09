From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2 1/3] jbd2: Use atomic variables to avoid taking
	t_handle_lock in jbd2_journal_stop
Date: Mon, 9 Aug 2010 19:02:16 +0200
Message-ID: <20100809170216.GB31969@atrey.karlin.mff.cuni.cz>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu> <1280939957-3277-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53667 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754597Ab0HIRCR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Aug 2010 13:02:17 -0400
Content-Disposition: inline
In-Reply-To: <1280939957-3277-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> By using an atomic_t for t_updates and t_outstanding credits, this
> should allow us to not need to take transaction t_handle_lock in
> jbd2_journal_stop().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  The patch looks OK to me besides:
@@ -426,15 +429,14 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
         * First unlink the handle from its current transaction, and start the
         * commit on that.
         */
-       J_ASSERT(transaction->t_updates > 0);
+       J_ASSERT(atomic_read(&transaction->t_updates) > 0);
        J_ASSERT(journal_current_handle() == handle);

        spin_lock(&journal->j_state_lock);
        spin_lock(&transaction->t_handle_lock);
-       transaction->t_outstanding_credits -= handle->h_buffer_credits;
-       transaction->t_updates--;
