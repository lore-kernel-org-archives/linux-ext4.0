From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 1/3] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Mon, 9 Aug 2010 15:05:13 -0400
Message-ID: <20100809190513.GF3635@thunk.org>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
 <1280939957-3277-2-git-send-email-tytso@mit.edu>
 <20100809170216.GB31969@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43837 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab0HITFZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Aug 2010 15:05:25 -0400
Content-Disposition: inline
In-Reply-To: <20100809170216.GB31969@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 07:02:16PM +0200, Jan Kara wrote:
>         spin_lock(&journal->j_state_lock);
>         spin_lock(&transaction->t_handle_lock);
> -       transaction->t_outstanding_credits -= handle->h_buffer_credits;
> -       transaction->t_updates--;
> -
> -       if (!transaction->t_updates)
> +       atomic_sub(handle->h_buffer_credits,
> +                  &transaction->t_outstanding_credits);
> +       if (atomic_dec_and_test(&transaction->t_updates))
>
> After this a transaction can disappear so subsequent
> __jbd2_log_start_commit shouldn't dereference transaction->t_tid,
> right?

I think it should be ok because we're holding j_state_lock(), so the
transaction can't disappear until we release the j_state_lock.

	    	  	    	     	     	 - Ted
