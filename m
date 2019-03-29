Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBBBC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 21:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39FD62184C
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 21:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfC2VZ0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 17:25:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729652AbfC2VZ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 17:25:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17228AD6D;
        Fri, 29 Mar 2019 21:25:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EB0331E4273; Fri, 29 Mar 2019 22:25:23 +0100 (CET)
Date:   Fri, 29 Mar 2019 22:25:23 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Song <fishland@aliyun.com>
Cc:     tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.song11@zte.com.cn
Subject: Re: [PATCH] jbd2: do not start commit when t_updates does not back
 to zero
Message-ID: <20190329212523.GC8757@quack2.suse.cz>
References: <20190324033835.55858-1-fishland@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324033835.55858-1-fishland@aliyun.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun 24-03-19 11:38:35, Liu Song wrote:
> When t_updates back to zero, it guaranteed wake up process which
> waiting on j_wait_updates. If we triggered a commit start without
> considered t_updates, the commit thread wakes up and find t_updates
> is not zero, it have to wait on it once again. So, add checking code
> to avoid this happen.
> 
> Signed-off-by: Liu Song <liu.song11@zte.com.cn>

Do I understand correctly that this is a performance improvement? If yes,
did you measure any benefit of the patch? Because I have some doubts that
t_updates == 0 case is very common.

								Honza

> ---
>  fs/jbd2/transaction.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 79a028a7a579..e0499fd73b1e 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -144,12 +144,13 @@ static void wait_transaction_locked(journal_t *journal)
>  	__releases(journal->j_state_lock)
>  {
>  	DEFINE_WAIT(wait);
> -	int need_to_start;
> +	int need_to_start = 0;
>  	tid_t tid = journal->j_running_transaction->t_tid;
>  
>  	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
>  			TASK_UNINTERRUPTIBLE);
> -	need_to_start = !tid_geq(journal->j_commit_request, tid);
> +	if (!atomic_read(&journal->j_running_transaction->t_updates))
> +		need_to_start = !tid_geq(journal->j_commit_request, tid);
>  	read_unlock(&journal->j_state_lock);
>  	if (need_to_start)
>  		jbd2_log_start_commit(journal, tid);
> -- 
> 2.19.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
