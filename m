From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/6] ext4: fix data integrity for ext4_sync_fs
Date: Tue, 28 May 2013 23:51:12 +0200
Message-ID: <20130528215112.GF16408@quack.suse.cz>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
 <1369732741-26070-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab3E1VvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 17:51:13 -0400
Content-Disposition: inline
In-Reply-To: <1369732741-26070-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 28-05-13 13:18:57, Dmitry Monakhov wrote:
> Inode's data or non journaled quota may be written w/o jounral so we _must_
> send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
> commit will do it for us.
> 
> Also fix data integrity for nojournal mode.
> changes from v1:
>  skip barrier for async mode
  One comment below:

> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index c9e1ab6..ed974fd 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1319,6 +1319,21 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
>  	return *(u32 *)desc.ctx;
>  }
>  
> +/* Return most recent uncommitted transaction */
> +static inline tid_t  jbd2_get_latest_transaction(journal_t *journal)
> +{
> +	tid_t tid;
> +
> +	read_lock(&journal->j_state_lock);
> +	tid = journal->j_commit_request;
> +	if (journal->j_running_transaction) {
> +		tid = journal->j_running_transaction->t_tid;
> +	} else if (!journal->j_commit_sequence)
  I would expect here journal->j_committing_transaction and then
journal->j_commit_request below. And you can use j_commit_sequence as an
initial 'tid' value...

> +		tid = journal->j_commit_sequence;
> +	read_unlock(&journal->j_state_lock);
> +	return tid;
> +}
> +

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
