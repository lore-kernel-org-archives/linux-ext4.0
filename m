From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] jbd: fix assertion failure in journal_next_log_block
Date: Thu, 31 Jan 2008 12:35:43 -0700
Message-ID: <20080131193543.GS23836@webber.adilger.int>
References: <20080131161417.GA29679@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45432 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYAaTfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2008 14:35:48 -0500
In-reply-to: <20080131161417.GA29679@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 31, 2008  11:14 -0500, Josef Bacik wrote:
[snip excellent analysis]
> So you get into this situation where
> t_nr_buffers (the actual number of buffers that are on the transaction) is
> greater than the number of buffers accounted for via t_outstanding_credits.
> This presents a problem since as we loop through writting buffers to the
> journal, we decrement t_outstanding_credits, and if t_nr_buffers is more than
> t_outstanding_credits then we end up with a negative number for
> t_outstanding_credits
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>

Do you know what kernel this problem was introduced in, or is this a
long standing problem?  Presumably the same is needed for jbd2?

Once we have some decent amount of testing going on with ext4, I think
it makes sense to merge the jbd2 changes back into jbd and return to
a single code base, since there is nothing in the jbd2 code that ext3
can't also work with (i.e. all of the changes are properly isolated
with compatibility flags and such).

> @@ -1056,7 +1056,7 @@ static inline int jbd_space_needed(journal_t *journal)
>  	int nblocks = journal->j_max_transaction_buffers;
>  	if (journal->j_committing_transaction)
>  		nblocks += journal->j_committing_transaction->
> -					t_outstanding_credits;
> +					t_nr_buffers;

(trivial) this can be moved back onto the previous line.

> @@ -1168,7 +1168,7 @@ static inline int jbd_space_needed(journal_t *journal)
>  	int nblocks = journal->j_max_transaction_buffers;
>  	if (journal->j_committing_transaction)
>  		nblocks += journal->j_committing_transaction->
> -					t_outstanding_credits;
> +					t_nr_buffers;

Same...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
