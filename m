Return-Path: <SRS0=4ybF=RB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6946EC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 12:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451582173C
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 12:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfBZMrM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:47:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:41978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726746AbfBZMrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Feb 2019 07:47:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E476B62B;
        Tue, 26 Feb 2019 12:47:11 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E99BB1E1562; Tue, 26 Feb 2019 13:47:10 +0100 (CET)
Date:   Tue, 26 Feb 2019 13:47:10 +0100
From:   Jan Kara <jack@suse.cz>
To:     luojiajun <luojiajun3@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.com,
        yi.zhang@huawei.com, miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: fix invalid descriptor block checksum
Message-ID: <20190226124710.GB15629@quack2.suse.cz>
References: <1551144685-145239-1-git-send-email-luojiajun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551144685-145239-1-git-send-email-luojiajun3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 26-02-19 09:31:25, luojiajun wrote:
> In jbd2_journal_commit_transaction(), if we are in abort mode,
> we may flush the buffer without setting descriptor block checksum
> by goto start_journal_io. Then fs is mounted,
> jbd2_descriptor_block_csum_verify() failed.
> 
> [  271.379811] EXT4-fs (vdd): shut down requested (2)
> [  271.381827] Aborting journal on device vdd-8.
> [  271.597136] JBD2: Invalid checksum recovering block 22199 in log
> [  271.598023] JBD2: recovery failed
> [  271.598484] EXT4-fs (vdd): error loading journal
> 
> Fix this problem by keep setting descriptor block checksum if the
> descriptor buffer is not NULL.
> 
> This checksum problem can be reproduced by xfstests generic/388.
> 
> Signed-off-by: luojiajun <luojiajun3@huawei.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 150cc03..bb47692 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -691,9 +691,11 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>                             the last tag we set up. */
>  
>  			tag->t_flags |= cpu_to_be16(JBD2_FLAG_LAST_TAG);
> +start_journal_io:
> +			if (descriptor)
> +				jbd2_descriptor_block_csum_set(journal,
> +							descriptor);
>  
> -			jbd2_descriptor_block_csum_set(journal, descriptor);
> -start_journal_io:
>  			for (i = 0; i < bufs; i++) {
>  				struct buffer_head *bh = wbuf[i];
>  				/*
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
