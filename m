From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] jbd2: only print the debugging information for tid wraparound once
Date: Mon, 9 May 2011 16:52:57 -0600
Message-ID: <A44F9507-B35B-4E9A-BB76-CA6CFA95BE2C@dilger.ca>
References: <1304897915-8538-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:64964 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab1EIWw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 18:52:58 -0400
In-Reply-To: <1304897915-8538-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 8, 2011, at 17:38, Theodore Ts'o wrote:
> If we somehow wrap, we don't want to keep printing the warning message
> over and over again.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/jbd2/journal.c |    9 +++++----
> 1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8c10004..cd2d341 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -500,10 +500,11 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
> 		/* This should never happen, but if it does, preserve
> 		   the evidence before kjournald goes into a loop and
> 		   increments j_commit_sequence beyond all recognition. */
> -		WARN(1, "jbd: bad log_start_commit: %u %u %u %u\n",
> -		     journal->j_commit_request, journal->j_commit_sequence,
> -		     target, journal->j_running_transaction ? 
> -		     journal->j_running_transaction->t_tid : 0);
> +		WARN_ONCE(1, "jbd: bad log_start_commit: %u %u %u %u\n",
> +			  journal->j_commit_request,
> +			  journal->j_commit_sequence,
> +			  target, journal->j_running_transaction ? 
> +			  journal->j_running_transaction->t_tid : 0);
> 	return 0;
> }
> 
> -- 
> 1.7.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





