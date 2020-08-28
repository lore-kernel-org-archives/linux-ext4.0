Return-Path: <SRS0=4TV9=CG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E41C433E6
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Aug 2020 09:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ECF7208CA
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Aug 2020 09:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgH1JVX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 28 Aug 2020 05:21:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgH1JVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 28 Aug 2020 05:21:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EA441B742;
        Fri, 28 Aug 2020 09:21:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 704C11E12C0; Fri, 28 Aug 2020 11:21:19 +0200 (CEST)
Date:   Fri, 28 Aug 2020 11:21:19 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix memleak in add_new_gdb
Message-ID: <20200828092119.GE7072@quack2.suse.cz>
References: <20200827062843.10188-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827062843.10188-1-dinghao.liu@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 27-08-20 14:28:43, Dinghao Liu wrote:
> When ext4_journal_get_write_access() fails, we should release
> n_group_desc, iloc.bh, dind and gdb_bh to prevent memleak.
> It's the same when ext4_handle_dirty_super() fails, but we
> don't need to release dind here because it has been released
> before.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Thanks for the patch! Some comments below:

> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index a50b51270ea9..efc0a022ca8e 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -843,8 +843,10 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  
>  	BUFFER_TRACE(dind, "get_write_access");
>  	err = ext4_journal_get_write_access(handle, dind);
> -	if (unlikely(err))
> +	if (unlikely(err)) {
>  		ext4_std_error(sb, err);
> +		goto errout;
> +	}

This hunk looks good.

> @@ -899,13 +901,17 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  
>  	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
>  	err = ext4_handle_dirty_super(handle, sb);
> -	if (err)
> +	if (err) {
>  		ext4_std_error(sb, err);
> +		goto errsuper;
> +	}
> +
>  	return err;
>  errout:
> +	brelse(dind);
> +errsuper:

But this is definitely wrong. Look, n_group_desc and gdb_bh are already
referenced from the superblock so you cannot free them, iloc.bh has been
released in ext4_mark_iloc_dirty().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
