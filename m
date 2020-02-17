Return-Path: <SRS0=mxlX=4F=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26216C35254
	for <linux-ext4@archiver.kernel.org>; Mon, 17 Feb 2020 12:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 053B4206F4
	for <linux-ext4@archiver.kernel.org>; Mon, 17 Feb 2020 12:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgBQMVd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 17 Feb 2020 07:21:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:54938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbgBQMVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Feb 2020 07:21:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00AD8B080;
        Mon, 17 Feb 2020 12:21:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7D1981E0D47; Mon, 17 Feb 2020 13:21:31 +0100 (CET)
Date:   Mon, 17 Feb 2020 13:21:31 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
Subject: Re: [PATCH] jbd2: improve comments about freeing data buffers whose
 page mapping is NULL
Message-ID: <20200217122131.GG12032@quack2.suse.cz>
References: <20200217112706.20085-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217112706.20085-1-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 17-02-20 19:27:06, zhangyi (F) wrote:
> Improve comments in jbd2_journal_commit_transaction() to describe why
> we don't need to clear the buffer_mapped bit for freeing file mapping
> buffers whose page mapping is NULL.
> 
> Fixes: c96dceeabf76 ("jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Thanks! You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 27373f5792a4..e855d8260433 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -997,9 +997,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  			 * journalled data) we need to unmap buffer and clear
>  			 * more bits. We also need to be careful about the check
>  			 * because the data page mapping can get cleared under
> -			 * out hands, which alse need not to clear more bits
> -			 * because the page and buffers will be freed and can
> -			 * never be reused once we are done with them.
> +			 * our hands. Note that if mapping == NULL, we don't
> +			 * need to make buffer unmapped because the page is
> +			 * already detached from the mapping and buffers cannot
> +			 * get reused.
>  			 */
>  			mapping = READ_ONCE(bh->b_page->mapping);
>  			if (mapping && !sb_is_blkdev_sb(mapping->host->i_sb)) {
> -- 
> 2.17.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
