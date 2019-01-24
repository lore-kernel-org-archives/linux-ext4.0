Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9D3C282C6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD43321872
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfAXIui (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:50:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:35524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbfAXIuh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 03:50:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80F9AAED1;
        Thu, 24 Jan 2019 08:50:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B3F5D1E3FF5; Thu, 24 Jan 2019 09:50:35 +0100 (CET)
Date:   Thu, 24 Jan 2019 09:50:35 +0100
From:   Jan Kara <jack@suse.cz>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        jack@suse.com, david@fromorbit.com, tytso@mit.edu,
        prakash.v@samsung.com
Subject: Re: [PATCH 4/4] fs/ext4,jbd2: add support for passing write-hint
 with journal.
Message-ID: <20190124085035.GC12184@quack2.suse.cz>
References: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <CGME20190109153342epcas2p3208f62a4dd876f8e1765b48f8aec2432@epcas2p3.samsung.com>
 <1547047861-7271-5-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547047861-7271-5-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 09-01-19 21:01:01, Kanchan Joshi wrote:
> For NAND based SSDs, mixing of data with different life-time reduces
> efficiency of internal garbage-collection. During FS operations, series
> of journal updates will follow/precede series of data/meta updates, causing
> intermixing inside SSD. By passing a write-hint with journal, its write
> can be isolated from other data/meta writes, leading to endurance/performance
> benefit on SSD.
> 
> This patch introduces "j_writehint" member in JBD2 journal, using which
> Ext4 specifies write-hint (as SHORT) for journal.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

Thanks for the patch. It looks mostly good, just one nit below.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d6c142d..3af4049 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4289,6 +4289,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
>  
> +	sbi->s_journal->j_writehint = KERN_WRITE_LIFE_SHORT;
> +
>  	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;

So I'd rather have defines like:

#define EXT4_WRITE_HINT_JOURNAL KERN_WRITE_HINT_MIN

like I suggested in another email and then later we could add stuff like

#define EXT4_WRITE_HINT_BITMAP	(KERN_WRITE_HINT_MIN + 1)

etc.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
