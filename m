Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2D6C432BE
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Jul 2021 12:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADCE60E77
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Jul 2021 12:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhGWLav (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Jul 2021 07:30:51 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:32925 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234385AbhGWLas (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2021 07:30:48 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16NCB6pe031295
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 08:11:07 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A071515C37C0; Fri, 23 Jul 2021 08:11:06 -0400 (EDT)
Date:   Fri, 23 Jul 2021 08:11:06 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
Cc:     jack@suse.cz, linux-ext4@vger.kernel.org, yukuai3@huawei.com
Subject: Re: [PATCH] ext4: flush s_error_work before journal destroy in
 ext4_fill_super
Message-ID: <YPqx2hPUuTkJo/sj@mit.edu>
References: <20210720062409.960734-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720062409.960734-1-yangerkun@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jul 20, 2021 at 02:24:09PM +0800, yangerkun wrote:
> 'commit c92dc856848f ("ext4: defer saving error info from atomic
> context")' and '2d01ddc86606 ("ext4: save error info to sb through journal
> if available")' add s_error_work to fix checksum error problem. But the
> error path in ext4_fill_super can lead the follow BUG_ON.

Can you share with me your test case?  Your patch will result in the
shrinker potentially not getting released in some error paths (which
will cause other kernel panics), and in any case, once the journal is
destroyed here:

> @@ -5173,15 +5173,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
>  	sbi->s_ea_block_cache = NULL;
> +failed_mount3a:
> +	ext4_es_unregister_shrinker(sbi);
> +failed_mount3:
> +	flush_work(&sbi->s_error_work);
>  
>  	if (sbi->s_journal) {
>  		jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
>  	}
> -failed_mount3a:
> -	ext4_es_unregister_shrinker(sbi);
> -failed_mount3:
> -	flush_work(&sbi->s_error_work);

sbi->s_journal is set to NULL, which means that in
flush_stashed_error_work(), journal will be NULL, which means we won't
call start_this_handle and so this change will not make a difference
given the kernel stack trace in the commit description.

Thanks,

						- Ted
