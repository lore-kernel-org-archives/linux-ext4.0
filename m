From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] JBD2: round commit timer up to avoid uncommitted	transaction
Date: Thu, 30 Jul 2009 19:47:10 +0200
Message-ID: <20090730174710.GB9223@atrey.karlin.mff.cuni.cz>
References: <20090727202209.GU4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZG3RrK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jul 2009 13:47:10 -0400
Content-Disposition: inline
In-Reply-To: <20090727202209.GU4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> jbd and jbd2 fixes: fix jiffie rounding in jbd commit timer setup code.
> Rounding down could cause the timer to be fired before the corresponding
> transaction has expired.  That transaction can stay not committed forever if
> no new transaction is created or expicit sync/umount happens.
> 
> Signed-off-by: Alex Zhuravlev (Tomas) <alex.zhuravlev@sun.com>
> Signed-off-by: Andreas Dilger <adilger@sun.com>
  Looks fine. You can add:
Acked-by: Jan Kara <jack@suse.cz>
  How about a similar JBD fix?

									Honza
> Index: linux-2.6.27.21-0.1/fs/jbd2/transaction.c
> ===================================================================
> --- linux-2.6.27.21-0.1.orig/fs/jbd2/transaction.c	2009-06-10 11:11:41.000000000 -0600
> +++ linux-2.6.27.21-0.1/fs/jbd2/transaction.c	2009-06-10 11:12:32.000000000 -0600
> @@ -54,7 +54,7 @@
>  	INIT_LIST_HEAD(&transaction->t_inode_list);
>  
>  	/* Set up the commit timer for the new transaction. */
> -	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
> +	journal->j_commit_timer.expires = round_jiffies_up(transaction->t_expires);
>  	add_timer(&journal->j_commit_timer);
>  
>  	J_ASSERT(journal->j_running_transaction == NULL);
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
