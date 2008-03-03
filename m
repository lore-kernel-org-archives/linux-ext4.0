From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] fix the way jbd/jbd2 clears the b_modified flag
Date: Mon, 3 Mar 2008 12:23:47 +0100
Message-ID: <20080303112347.GA13725@duck.suse.cz>
References: <200802271346.10298.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49106 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756073AbYCCLXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 06:23:49 -0500
Content-Disposition: inline
In-Reply-To: <200802271346.10298.jbacik@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-02-08 13:46:09, Josef Bacik wrote:
> Hello,
> 
> Currently at the start of a journal commit we loop through all of the buffers on 
> the committing transaction and clear the b_modified flag (the flag that is set 
> when a transaction modifies the buffer) under the j_list_lock.  The problem is 
> that everywhere else this flag is modified only under the jbd lock buffer flag, 
> so it will race with a running transaction who could potentially set it, and 
> have it unset by the committing transaction.  This is also a big waste, you can 
> have several thousands of buffers that you are clearing the modified flag on 
> when you may not need to.  This patch removes this code and instead clears the 
> b_modified flag upon entering do_get_write_access/journal_get_create_access, so 
> if that transaction does indeed use the buffer then it will be accounted for 
> properly, and if it does not then we know we didn't use it.  That will be 
> important for the next patch in this series.  Tested thoroughly by myself using 
> postmark/iozone/bonnie++.  Thank you,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
  Nice work. Andrew has already added the patch to his tree but anyway I've
reviewed the patch and you can add

Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
> Index: linux-2.6/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd/commit.c
> +++ linux-2.6/fs/jbd/commit.c
> @@ -407,22 +407,6 @@ void journal_commit_transaction(journal_
>  	jbd_debug (3, "JBD: commit phase 2\n");
>  
>  	/*
> -	 * First, drop modified flag: all accesses to the buffers
> -	 * will be tracked for a new trasaction only -bzzz
> -	 */
> -	spin_lock(&journal->j_list_lock);
> -	if (commit_transaction->t_buffers) {
> -		new_jh = jh = commit_transaction->t_buffers->b_tnext;
> -		do {
> -			J_ASSERT_JH(new_jh, new_jh->b_modified == 1 ||
> -					new_jh->b_modified == 0);
> -			new_jh->b_modified = 0;
> -			new_jh = new_jh->b_tnext;
> -		} while (new_jh != jh);
> -	}
> -	spin_unlock(&journal->j_list_lock);
> -
> -	/*
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> Index: linux-2.6/fs/jbd/transaction.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd/transaction.c
> +++ linux-2.6/fs/jbd/transaction.c
> @@ -609,6 +609,12 @@ repeat:
>  		goto done;
>  
>  	/*
> +	 * this is the first time this transaction is touching this buffer,
> +	 * reset the modified flag
> +	 */
> +	jh->b_modified = 0;
> +
> +	/*
>  	 * If there is already a copy-out version of this buffer, then we don't
>  	 * need to make another one
>  	 */
> @@ -820,9 +826,16 @@ int journal_get_create_access(handle_t *
>  
>  	if (jh->b_transaction == NULL) {
>  		jh->b_transaction = transaction;
> +
> +		/* first access by this transaction */
> +		jh->b_modified = 0;
> +
>  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
>  		__journal_file_buffer(jh, transaction, BJ_Reserved);
>  	} else if (jh->b_transaction == journal->j_committing_transaction) {
> +		/* first access by this transaction */
> +		jh->b_modified = 0;
> +
>  		JBUFFER_TRACE(jh, "set next transaction");
>  		jh->b_next_transaction = transaction;
>  	}
> Index: linux-2.6/fs/jbd2/commit.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd2/commit.c
> +++ linux-2.6/fs/jbd2/commit.c
> @@ -520,22 +520,6 @@ void jbd2_journal_commit_transaction(jou
>  	jbd_debug (3, "JBD: commit phase 2\n");
>  
>  	/*
> -	 * First, drop modified flag: all accesses to the buffers
> -	 * will be tracked for a new trasaction only -bzzz
> -	 */
> -	spin_lock(&journal->j_list_lock);
> -	if (commit_transaction->t_buffers) {
> -		new_jh = jh = commit_transaction->t_buffers->b_tnext;
> -		do {
> -			J_ASSERT_JH(new_jh, new_jh->b_modified == 1 ||
> -					new_jh->b_modified == 0);
> -			new_jh->b_modified = 0;
> -			new_jh = new_jh->b_tnext;
> -		} while (new_jh != jh);
> -	}
> -	spin_unlock(&journal->j_list_lock);
> -
> -	/*
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> Index: linux-2.6/fs/jbd2/transaction.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd2/transaction.c
> +++ linux-2.6/fs/jbd2/transaction.c
> @@ -618,6 +618,12 @@ repeat:
>  		goto done;
>  
>  	/*
> +	 * this is the first time this transaction is touching this buffer,
> +	 * reset the modified flag
> +	 */
> +       jh->b_modified = 0;
> +
> +	/*
>  	 * If there is already a copy-out version of this buffer, then we don't
>  	 * need to make another one
>  	 */
> @@ -829,9 +835,16 @@ int jbd2_journal_get_create_access(handl
>  
>  	if (jh->b_transaction == NULL) {
>  		jh->b_transaction = transaction;
> +
> +		/* first access by this transaction */
> +		jh->b_modified = 0;
> +
>  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
>  		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
>  	} else if (jh->b_transaction == journal->j_committing_transaction) {
> +		/* first access by this transaction */
> +		jh->b_modified = 0;
> +
>  		JBUFFER_TRACE(jh, "set next transaction");
>  		jh->b_next_transaction = transaction;
>  	}
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
