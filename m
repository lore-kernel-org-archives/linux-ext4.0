Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F6BC10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 10:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0032173C
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 10:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfC1J77 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 05:59:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:59892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbfC1J76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 05:59:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 034CFAD63;
        Thu, 28 Mar 2019 09:59:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id F2A161E424A; Thu, 28 Mar 2019 10:59:54 +0100 (CET)
Date:   Thu, 28 Mar 2019 10:59:54 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        renzhen@linux.alibaba.com
Subject: Re: [PATCH] jbd2: check superblock mapped prior to committing
Message-ID: <20190328095954.GE22915@quack2.suse.cz>
References: <20190328091814.46168-1-jiufei.xue@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328091814.46168-1-jiufei.xue@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 28-03-19 17:18:14, Jiufei Xue wrote:
> We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
> before unmounting ext4 filesystem.
> 
> The typical chain of events leading to the BUG:
> jbd2_write_superblock
>   submit_bh
>     submit_bh_wbc
>       BUG_ON(!buffer_mapped(bh));
> 
> The block device is removed and all the pages are invalidated. JBD2
> was trying to write journal superblock to the block device which is
> no longer present.
> 
> Fix this by checking the journal superblock's buffer head prior to
> submitting.
> 
> Cc: stable@kernel.org
> Reported-by: Eric Ren <renzhen@linux.alibaba.com>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  fs/jbd2/journal.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 382c030cc78b..90fd3ed0a232 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1350,6 +1350,9 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
>  	journal_superblock_t *sb = journal->j_superblock;
>  	int ret;
>  
Can you add a comment here like:

	/* Buffer got discarded which means block device got invalidated */

to explain what's going on? Thanks! Otherwise the patch looks good to me so
you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> +	if (!buffer_mapped(bh))
> +		return -EIO;
> +


>  	trace_jbd2_write_superblock(journal, write_flags);
>  	if (!(journal->j_flags & JBD2_BARRIER))
>  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
> -- 
> 2.19.1.856.g8858448bb
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
