Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D36EC282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3729E20881
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfA1PY2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:24:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:34722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfA1PY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 10:24:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8762BAE04;
        Mon, 28 Jan 2019 15:24:27 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E3C861E3FEF; Mon, 28 Jan 2019 16:24:26 +0100 (CET)
Date:   Mon, 28 Jan 2019 16:24:26 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v3 1/4] jbd2: make sure dirty flag is cleared while
 revorking a buffer which belongs to older transaction
Message-ID: <20190128152426.GD5858@quack2.suse.cz>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
 <1548419456-4331-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548419456-4331-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 20:30:53, zhangyi (F) wrote:
> Now, we capture a data corruption problem on ext4 while we're truncating
> an extent index block. Imaging that if we are revoking a buffer which
> has been journaled by the committing transaction, the buffer's jbddirty
> flag will not be cleared in jbd2_journal_forget(), so the commit code
> will set the buffer dirty flag again after refile the buffer.
> 
> fsx                               kjournald2
>                                   jbd2_journal_commit_transaction
> jbd2_journal_revoke                commit phase 1~5...
>  jbd2_journal_forget
>    belongs to older transaction    commit phase 6
>    jbddirty not clear               __jbd2_journal_refile_buffer
>                                      __jbd2_journal_unfile_buffer
>                                       test_clear_buffer_jbddirty
>                                        mark_buffer_dirty
> 
> Finally, if the freed extent index block was allocated again as data
> block by some other files, it may corrupt the file data after writing
> cached pages later, such as during unmount time. (In general,
> clean_bdev_aliases() related helpers should be invoked after
> re-allocation to prevent the above corruption, but unfortunately we
> missed it when zeroout the head of extra extent blocks in
> ext4_ext_handle_unwritten_extents()).
> 
> This patch mark buffer as freed and set j_next_transaction to the new
> transaction when it already belongs to the committing transaction in
> jbd2_journal_forget(), so that commit code knows it should clear dirty
> bits when it is done with the buffer.
> 
> This problem can be reproduced by xfstests generic/455 easily with
> seeds (3246 3247 3248 3249).
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Cc: stable@vger.kernel.org

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one comment below to make the comment more readable:

> @@ -1609,14 +1609,21 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>  		/* However, if the buffer is still owned by a prior
>  		 * (committing) transaction, we can't drop it yet... */
>  		JBUFFER_TRACE(jh, "belongs to older transaction");
> -		/* ... but we CAN drop it from the new transaction if we
> -		 * have also modified it since the original commit. */
> +		/* ... but we CAN drop it from the new transaction through
> +		 * marking the buffer as freed and set j_next_transaction to
> +		 * the new transaction, so that not only the commit code
> +		 * knows it should clear dirty bits when it is done with the
> +		 * buffer, but also we can avoid this buffer be checkpointed
> +		 * without writing out before the new transaction complete. */

.... but also the buffer can be checkpointed only after the new transaction
commits.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
