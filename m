From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH] jbd: Remove j_barrier mutex
Date: Tue, 27 Dec 2011 10:51:00 -0800
Message-ID: <20111227185100.GA30094@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1324562865-4720-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akmp@suse.cz, rjw@sisk.pl,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1L0SvL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Dec 2011 13:51:11 -0500
Content-Disposition: inline
In-Reply-To: <1324562865-4720-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 22, 2011 at 03:07:45PM +0100, Jan Kara wrote:
> j_barrier mutex is used for serializing different journal lock operations.  The
> problem with it is that e.g. FIFREEZE ioctl results in process leaving kernel
> with j_barrier mutex held which makes lockdep freak out. Also hibernation code
> wants to freeze filesystem but it cannot do so because it then cannot hibernate
> the system because of mutex being locked.
> 
> So we remove j_barrier mutex and use direct wait on j_barrier_count instead.
> Since locking journal is a rare operation we don't have to care about fairness
> or such things.
> 
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

Strikes me as pretty reasonable.

>  void journal_lock_updates(journal_t *journal)
>  {
>  	DEFINE_WAIT(wait);
>  
> +wait:
> +	/* Wait for previous locked operation to finish */
> +	wait_event(journal->j_wait_transaction_locked,
> +		   journal->j_barrier_count == 0);
> +
>  	spin_lock(&journal->j_state_lock);
> +	/*
> +	 * Check reliably under the lock whether we are the ones winning the race
> +	 * and locking the journal
> +	 */
> +	if (journal->j_barrier_count > 0) {
> +		spin_unlock(&journal->j_state_lock);
> +		goto wait;
> +	}

I suppose I'd prefer:

	do {
		wait_event(journal->j_wait_transaction_locked,
			   journal->j_barrier_count == 0);

		spin_lock(&journal->j_state_lock);
		if (journal->j_barrier_count == 0)
			break;
		spin_unlock(&journal->j_state_lock);
	} while (1);
  	++journal->j_barrier_count;

because I hate using goto for trivial loops, but that's a nitpick.

ACK.

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

			http://www.jlbec.org/
			jlbec@evilplan.org
