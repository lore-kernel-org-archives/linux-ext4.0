From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: remove excess descriptions for handle_s
Date: Mon, 21 Mar 2016 09:41:30 +0100
Message-ID: <20160321084130.GA30819@quack.suse.cz>
References: <1458407163-10849-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, jack@suse.com,
	linux-ext4@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbcCUIlD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2016 04:41:03 -0400
Content-Disposition: inline
In-Reply-To: <1458407163-10849-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 19-03-16 17:06:03, Luis de Bethencourt wrote:
> Commit bf6993276f74 ("jbd2: Use tracepoints for history file")
> removed the members j_history, j_history_max and j_history_cur from struct
> handle_s but the descriptions stayed lingering. Removing them.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Hi,
> 
> Noticed this issue when running make htmldocs.
> 
> It gives the following warnings:
> .//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history' description in 'journal_s'
> .//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_max' description in 'journal_s'
> .//include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_cur' description in 'journal_s'
> 
> Thanks,
> Luis
> 
>  include/linux/jbd2.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index fd1083c..401792d 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -781,9 +781,6 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>   * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
>   *	number that will fit in j_blocksize
>   * @j_last_sync_writer: most recent pid which did a synchronous write
> - * @j_history: Buffer storing the transactions statistics history
> - * @j_history_max: Maximum number of transactions in the statistics history
> - * @j_history_cur: Current number of transactions in the statistics history
>   * @j_history_lock: Protect the transactions statistics history
>   * @j_proc_entry: procfs entry for the jbd statistics directory
>   * @j_stats: Overall statistics
> -- 
> 2.5.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
