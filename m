From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Date: Sun, 19 Oct 2008 21:13:28 -0400
Message-ID: <20081020011327.GA8162@mit.edu>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu> <20081017060424.GA26192@skywalker> <20081017100214.GB11557@mit.edu> <20081017122552.GC21503@mit.edu> <20081019224904.GF3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38073 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751172AbYJTBNc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Oct 2008 21:13:32 -0400
Content-Disposition: inline
In-Reply-To: <20081019224904.GF3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 19, 2008 at 04:49:28PM -0600, Andreas Dilger wrote:
> 
> The problem with the mechanism you've implemented is that it isn't
> possible to add any other kind of callback to the journal.  There
> is only a single callback function, and the entries in the "t_private_list"
> are all assumed to be "ext4_free_data" structures so even if other
> users wanted to add callbacks they would only be handled by the
> release_blocks_on_commit() function.
> 
> Is there any reason not to make this more generic and have the callback
> function pointer embedded in the "ext4_free_data" struct in some way
> that other callbacks could be registered?  This would still avoid the
> need to allocate for each of these operations, but would make the
> callback mechanism more generic and useful.

Another possibility would be to simply re-point
sbi->s_journal->j_commit_callback() to a function like this:

static void new_commit_callback_func(journal_t *journal, transaction_t *txn)
{
	do_new_callback_stuff(journal, txn)
	release_blocks_on_commit(journal, txn)
}

Or Luster could initialize ext4, and then intercept the callback,
stash it away in a pointer, and then do this:

static void new_commit_callback_func(journal_t *journal, transaction_t *txn)
{
	do_new_callback_stuff(journal, txn)
	(*orig_value_of_j_commit_callback)(journal, txn)
}


If you want to be even *more* general, we could hang a struct
list_head off of struct ext4_sb_info which contains the linked list of
functions to be called, one of which would be release_blocks_on_commit(), 
and then change sbi->s_journal->j_commit_callback to point to a function
which iterates over the functions in the list_head
sbi->s_commit_callback_funcs.

Do you have specific use in mind for Lustre?  Could one of the above
schemes work for you?

							- Ted
