From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH][take 5] JBD2: Fix race between free buffer and commit
	trasanction
Date: Fri, 30 May 2008 11:54:20 +0530
Message-ID: <20080530062420.GA7450@skywalker>
References: <20080519132553.de9b78b0.akpm@linux-foundation.org> <1211234829.3663.39.camel@localhost.localdomain> <1211306575.3664.19.camel@localhost.localdomain> <20080520235303.GB23521@atrey.karlin.mff.cuni.cz> <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com> <20080524224447.GE20563@atrey.karlin.mff.cuni.cz> <1211998739.3791.20.camel@localhost.localdomain> <20080528185554.GA16018@duck.suse.cz> <1212020216.3791.54.camel@localhost.localdomain> <1212020299.3791.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:34072 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYE3GYq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 02:24:46 -0400
Content-Disposition: inline
In-Reply-To: <1212020299.3791.57.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 28, 2008 at 05:18:19PM -0700, Mingming Cao wrote:
> Index: linux-2.6.26-rc3/fs/jbd2/transaction.c
> ===================================================================
> --- linux-2.6.26-rc3.orig/fs/jbd2/transaction.c	2008-05-28 16:10:41.000000000 -0700
> +++ linux-2.6.26-rc3/fs/jbd2/transaction.c	2008-05-28 16:13:16.000000000 -0700
> @@ -1656,12 +1656,42 @@ out:
>  	return;
>  }
> 
> +/*
> + * jbd2_journal_try_to_free_buffers() could race with jbd2_journal_commit_transaction()
> + * The later might still hold the reference count to the buffers when inspecting
> + * them on t_syncdata_list or t_locked_list.
> + *
> + * jbd2_journal_try_to_free_buffers() will call this function to
> + * wait for the current transaction to finish syncing data buffers, before
> + * try to free that buffer.
> + *
> + * Called with journal->j_state_lock hold.
> + */

We are taking the spin_lock again in the function ??



> +static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
> +{
> +	transaction_t *transaction = NULL;
> +	tid_t tid;
> +
> +	spin_lock(&journal->j_state_lock);
> +	transaction = journal->j_committing_transaction;
> +
> +	if (!transaction) {
> +		spin_unlock(&journal->j_state_lock);
> +		return;
> +	}
> +
> +	tid = transaction->t_tid;
> +	spin_unlock(&journal->j_state_lock);
> +	jbd2_log_wait_commit(journal, tid);
> +}


[.... snip.... ]


> +	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> +        	spin_lock(&journal->j_state_lock);
> +		jbd2_journal_wait_for_transaction_sync_data(journal);
> +		ret = try_to_free_buffers(page);
> +		spin_unlock(&journal->j_state_lock);
> +	}
> +
>  busy:
>  	return ret;
>  }
> 
> 

-aneesh
