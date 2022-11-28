Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A810C43217
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Nov 2022 10:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiK1KSG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Nov 2022 05:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiK1KSB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2022 05:18:01 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8FF140BF;
        Mon, 28 Nov 2022 02:18:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A0DA51F891;
        Mon, 28 Nov 2022 10:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1669630679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rmHaM96cK2sGOvLj+OhmH+CCEUiMsS+99zbIjKTfy6w=;
        b=BP/Ai4JvNTs291J9oJ5bV6Su9gsRcAoLeic2r1okx0z2+FNQbAZaQzyqz/Hix8dFwL1bBF
        idK4zxBe3Qk//SDhO9l8Z/nt1hZIWbNUUsO3lgIaNMHVu8kf1Hb1nHczfa5r2E3LHyIVVp
        BEKowmv0R+3brqn7SbMm4cO5RpUr47A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1669630679;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rmHaM96cK2sGOvLj+OhmH+CCEUiMsS+99zbIjKTfy6w=;
        b=hQTkKauLyDTqLe9BUlmmU2XKzqRGbrftYOyfY7O171nLiInc4rryDVigkCvBhqQ8EUsKGi
        iGjGD7FQgj5eKpAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 905911326E;
        Mon, 28 Nov 2022 10:17:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NiEzI9eKhGOhGQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 28 Nov 2022 10:17:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 24A05A070F; Mon, 28 Nov 2022 11:17:59 +0100 (CET)
Date:   Mon, 28 Nov 2022 11:17:59 +0100
From:   Jan Kara <jack@suse.cz>
To:     Rong Tao <rtoax@foxmail.com>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong Tao <rongtao@cestc.cn>
Subject: Re: [PATCH] fs/ext2: Fix code indentation
Message-ID: <20221128101759.cqrvwncfeqracaqk@quack3>
References: <tencent_EEC5C049082D4BF0724AC5E9956BD41E5105@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_EEC5C049082D4BF0724AC5E9956BD41E5105@qq.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-11-22 21:38:21, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> ts=4 can cause misunderstanding in code reading. It is better to replace
> 8 spaces with one tab.
> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>

Thanks for the cleanup! When doing whitespace cleanup like this, can you
please also fix another 5 lines in fs/ext2/balloc.c which have this problem
and submit it as a single patch together with this? Thanks!

								Honza

> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 03f2af98b1b4..69c88facfe90 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1648,7 +1648,7 @@ static int __init init_ext2_fs(void)
>  	err = init_inodecache();
>  	if (err)
>  		return err;
> -        err = register_filesystem(&ext2_fs_type);
> +	err = register_filesystem(&ext2_fs_type);
>  	if (err)
>  		goto out;
>  	return 0;
> -- 
> 2.31.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
