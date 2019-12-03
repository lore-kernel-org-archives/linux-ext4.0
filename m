Return-Path: <SRS0=K1lC=ZZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBD5C432C0
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Dec 2019 11:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6DC2068E
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Dec 2019 11:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLCL7C (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 3 Dec 2019 06:59:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:57426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfLCL7C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Dec 2019 06:59:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 616E9AC93;
        Tue,  3 Dec 2019 11:59:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ECCD41E0B7B; Tue,  3 Dec 2019 12:58:59 +0100 (CET)
Date:   Tue, 3 Dec 2019 12:58:59 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, liangyun2@huawei.com,
        luoshijie1@huawei.com
Subject: Re: [PATCH v2 1/4] jbd2: switch to use jbd2_journal_abort() when
 failed to submit the commit record
Message-ID: <20191203115859.GB8206@quack2.suse.cz>
References: <20191203092756.26129-1-yi.zhang@huawei.com>
 <20191203092756.26129-2-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203092756.26129-2-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 03-12-19 17:27:53, zhangyi (F) wrote:
> We invloke jbd2_journal_abort() to abort the journal and record errno
> in the jbd2 superblock when committing journal transaction besides the
> failure on submitting the commit record. But there is no need for the
> case and we can also invloke jbd2_journal_abort() instead of
			^^^ invoke

> __jbd2_journal_abort_hard().
> 
> Fixes: 818d276ceb83a ("ext4: Add the journal checksum feature")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Besides the spelling fix the patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/jbd2/commit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 132fb92098c7..87b88d910306 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -785,7 +785,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		err = journal_submit_commit_record(journal, commit_transaction,
>  						 &cbh, crc32_sum);
>  		if (err)
> -			__jbd2_journal_abort_hard(journal);
> +			jbd2_journal_abort(journal, err);
>  	}
>  
>  	blk_finish_plug(&plug);
> @@ -876,7 +876,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		err = journal_submit_commit_record(journal, commit_transaction,
>  						&cbh, crc32_sum);
>  		if (err)
> -			__jbd2_journal_abort_hard(journal);
> +			jbd2_journal_abort(journal, err);
>  	}
>  	if (cbh)
>  		err = journal_wait_on_commit_record(journal, cbh);
> -- 
> 2.17.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
