Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95582C6FD1D
	for <linux-ext4@archiver.kernel.org>; Fri, 17 Mar 2023 13:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCQNBh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 17 Mar 2023 09:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCQNBf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Mar 2023 09:01:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BDEB3E37
        for <linux-ext4@vger.kernel.org>; Fri, 17 Mar 2023 06:01:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4EDE521A6D;
        Fri, 17 Mar 2023 13:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679058092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vbbeiHVcLJZjsBTuzDslYr85ahpqKRSM12wkly6J6EY=;
        b=O+mqQFMJwEz5dbd1Jv3sUjAjFZhC0+rUxRXRDXs+9xL42VsWINx3bskUtBl2+OI97ZlZud
        UFd8tz9kSGVpSNvfvTOvTNogq03SrFBG+J7gBfShfVbY9PBG8hf9nNV3fKPcgcSY+qfGPl
        8adRxaWVvulu0gXbXsxcQggGOzqQq7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679058092;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vbbeiHVcLJZjsBTuzDslYr85ahpqKRSM12wkly6J6EY=;
        b=h30kRFKe0v60hYiO/ZbiJNaWURNvZJar/ik1WZPIBD7zuLkvVquXe5OVMgN/3a53bwvOZ4
        hvEgTlfPNWjQ51Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 342E413428;
        Fri, 17 Mar 2023 13:01:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xdmlDKxkFGRTSQAAMHmgww
        (envelope-from <jack@suse.cz>); Fri, 17 Mar 2023 13:01:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B9BBFA06FD; Fri, 17 Mar 2023 14:01:31 +0100 (CET)
Date:   Fri, 17 Mar 2023 14:01:31 +0100
From:   Jan Kara <jack@suse.cz>
To:     Zhang Yi <yi.zhang@huaweicloud.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
        yukuai3@huawei.com
Subject: Re: [PATCH v4 2/2] ext4: add journal cycled recording support
Message-ID: <20230317130131.k2oabqxikk6p36en@quack3>
References: <20230317090926.4149399-1-yi.zhang@huaweicloud.com>
 <20230317090926.4149399-3-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317090926.4149399-3-yi.zhang@huaweicloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 17-03-23 17:09:26, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Always enable 'JBD2_CYCLE_RECORD' journal option on ext4, letting the
> jbd2 continue to record new journal transactions from the recovered
> journal head or the checkpointed transactions in the previous mount.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 88f7b8a88c76..9b46adae241b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5691,6 +5691,11 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
>  		journal->j_flags |= JBD2_ABORT_ON_SYNCDATA_ERR;
>  	else
>  		journal->j_flags &= ~JBD2_ABORT_ON_SYNCDATA_ERR;
> +	/*
> +	 * Always enable journal cycle record option, letting the journal
> +	 * records log transactions continuously between each mount.
> +	 */
> +	journal->j_flags |= JBD2_CYCLE_RECORD;
>  	write_unlock(&journal->j_state_lock);
>  }
>  
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
