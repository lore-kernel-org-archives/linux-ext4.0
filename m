Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0A0C433ED
	for <linux-ext4@archiver.kernel.org>; Thu,  8 Apr 2021 13:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42DD8610FA
	for <linux-ext4@archiver.kernel.org>; Thu,  8 Apr 2021 13:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhDHNqE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:46:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:41286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhDHNqE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Apr 2021 09:46:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13704B032;
        Thu,  8 Apr 2021 13:45:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BBECB1F2B77; Thu,  8 Apr 2021 15:45:51 +0200 (CEST)
Date:   Thu, 8 Apr 2021 15:45:51 +0200
From:   Jan Kara <jack@suse.cz>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, yukuai3@huawei.com
Subject: Re: [PATCH 1/3] jbd2: protect buffers release with j_checkpoint_mutex
Message-ID: <20210408134551.GC3271@quack2.suse.cz>
References: <20210408113618.1033785-1-yi.zhang@huawei.com>
 <20210408113618.1033785-2-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408113618.1033785-2-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 08-04-21 19:36:16, Zhang Yi wrote:
> There is a race between jbd2_journal_try_to_free_buffers() and
> jbd2_journal_destroy(), so the jbd2_log_do_checkpoint() may still
> missing to detect the buffer write io error flag and lead to filesystem
> inconsistency.
> 
> jbd2_journal_try_to_free_buffers()     ext4_put_super()
>                                         jbd2_journal_destroy()
>   __jbd2_journal_remove_checkpoint()
>   detect buffer write error              jbd2_log_do_checkpoint()
>                                          jbd2_cleanup_journal_tail()
>                                            <--- lead to inconsistency
>   jbd2_journal_abort()
> 
> Fix this issue by add j_checkpoint_mutex to protect journal buffer
> release on jbd2_journal_try_to_free_buffers().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Thanks for the patch Zhang. I agree with your problem analysis but I don't
think the solution is correct:

>  	J_ASSERT(PageLocked(page));
>  
> +	mutex_lock(&journal->j_checkpoint_mutex);

We cannot grab j_checkpoint_mutex inside jbd2_journal_try_to_free_buffers()
(or even ext4_releasepage()) because that function is called withe a page
lock which ranks below the checkpoint mutex - generally page locks are
acquired within a transaction and thus all locks required to start a
transaction (and j_checkpoint_mutex is one of them) rank above the page
lock.

Also even if the lock ordering was OK, grabbing j_checkpoint_mutex for
every page from memory reclaim just to close this rare race seems like a
performance overkill.

What we seem to need is a quick way of marking the journal as "IO error
occured" in __journal_try_to_free_buffer() before actually removing the
buffer from the checkpoint list. Perhaps this marking could even happen
already in __jbd2_journal_remove_checkpoint() and we can reuse it in
jbd2_log_do_checkpoint() for IO error handling as well... And then once we
are in a safer context, we can do:

	if (!is_journal_aborted(journal) && journal_io_error_happened(journal))
		jbd2_journal_abort(...)

								Honza

>  	head = page_buffers(page);
>  	bh = head;
>  	do {
> @@ -2163,6 +2164,7 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal, struct page *page)
>  	if (has_write_io_error)
>  		jbd2_journal_abort(journal, -EIO);
>  
> +	mutex_unlock(&journal->j_checkpoint_mutex);
>  	return ret;
>  }
>  
> -- 
> 2.25.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
