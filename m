Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5D9C4338F
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Aug 2021 15:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE2260F38
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Aug 2021 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhHDPpr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 4 Aug 2021 11:45:47 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44446 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbhHDPpr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Aug 2021 11:45:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6778422225;
        Wed,  4 Aug 2021 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628091933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTHKDhy7QKob/eaRcBJjwJXlWU+Io0cHwVpOGaPMVAE=;
        b=BLM9Ki0iW/lyKNlI//dF7LJpvNsYWNaE1UC6O14ECEQd7hn3Y8CWxKb7m56jDkECrafNvI
        oxsMD+ZdCl1xaKsydE9buHZ/rj91rXmBlOsajYA2qIIERRyq37daGWc96Hc8aLvKBKylMt
        oSzVFv4sX1CPNkWDqMZIOJ8wITn8BNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628091933;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTHKDhy7QKob/eaRcBJjwJXlWU+Io0cHwVpOGaPMVAE=;
        b=Gah5GKirZCHXMkuoEdbh9za5yIowYUpZ7AqVSUcapFGz5k63dnttc2np+KSr4cez4Ij5Lk
        GFyeAd9GxzwJsUDA==
Received: from quack2.suse.cz (jack.udp.ovpn2.nue.suse.de [10.163.43.118])
        by relay2.suse.de (Postfix) with ESMTP id 53C37A3B84;
        Wed,  4 Aug 2021 15:45:33 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 944F11F2B83; Wed,  4 Aug 2021 17:45:30 +0200 (CEST)
Date:   Wed, 4 Aug 2021 17:45:30 +0200
From:   Jan Kara <jack@suse.cz>
To:     Wang Jianchao <jianchao.wan9@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca
Subject: Re: [PATCH V3 4/5] ext4: get discard out of jbd2 commit kthread
 contex
Message-ID: <20210804154530.GL4578@quack2.suse.cz>
References: <20210724074124.25731-1-jianchao.wan9@gmail.com>
 <20210724074124.25731-5-jianchao.wan9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210724074124.25731-5-jianchao.wan9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat 24-07-21 15:41:23, Wang Jianchao wrote:
> From: Wang Jianchao <wangjianchao@kuaishou.com>
> 
> Right now, discard is issued and waited to be completed in jbd2
> commit kthread context after the logs are committed. When large
> amount of files are deleted and discard is flooding, jbd2 commit
> kthread can be blocked for long time. Then all of the metadata
> operations can be blocked to wait the log space.
> 
> One case is the page fault path with read mm->mmap_sem held, which
> wants to update the file time but has to wait for the log space.
> When other threads in the task wants to do mmap, then write mmap_sem
> is blocked. Finally all of the following read mmap_sem requirements
> are blocked, even the ps command which need to read the /proc/pid/
> -cmdline. Our monitor service which needs to read /proc/pid/cmdline
> used to be blocked for 5 mins.
> 
> This patch frees the blocks back to buddy after commit and then do
> discard in a async kworker context in fstrim fashion, namely,
>  - mark blocks to be discarded as used if they have not been allocated
>  - do discard
>  - mark them free
> After this, jbd2 commit kthread won't be blocked any more by discard
> and we won't get NOSPC even if the discard is slow or throttled.
> 
> Link: https://marc.info/?l=linux-kernel&m=162143690731901&w=2
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Wang Jianchao <wangjianchao@kuaishou.com>

Looks good to me. Just one small comment below. With that addressed feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>


> @@ -3474,6 +3530,14 @@ int ext4_mb_release(struct super_block *sb)
>  	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
>  	int count;
>  
> +	if (test_opt(sb, DISCARD)) {
> +		/*
> +		 * wait the discard work to drain all of ext4_free_data
> +		 */
> +		queue_work(ext4_discard_wq, &sbi->s_discard_work);

Do we really need to queue the work here? The filesystem should be
quiescent by now, we take care to queue the work whenever we add item to
empty list. So it should be enough to have flush_work() here and then
possibly

	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list))

Or am I missing something?

								Honza

> +		flush_work(&sbi->s_discard_work);
> +	}
> +
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
