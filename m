Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0A6C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 12:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B68621479
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 12:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbfDRMfX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:35:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:57054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbfDRMfX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 08:35:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F18F7AFBF;
        Thu, 18 Apr 2019 12:35:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 115C81E15AE; Thu, 18 Apr 2019 14:35:19 +0200 (CEST)
Date:   Thu, 18 Apr 2019 14:35:19 +0200
From:   Jan Kara <jack@suse.cz>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ext4: avoid drop reference to iloc.bh twice
Message-ID: <20190418123519.GJ28541@quack2.suse.cz>
References: <1555576278-3917-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555576278-3917-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 18-04-19 16:31:18, Pan Bian wrote:
> The reference to iloc.bh has been dropped in ext4_mark_iloc_dirty.
> However, the reference is dropped again if error occurs during
> ext4_handle_dirty_metadata, which may result in use-after-free bugs.
> 
> Fixes: fb265c9cb49e("ext4: add ext4_sb_bread() to disambiguate ENOMEM
> cases")
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Thanks for the patch! Good spotting. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

I'm just wondering: Ted, shouldn't we make ext4_mark_iloc_dirty() clear the
iloc.bh pointer on it's own? I believe this is not the first time we had a
bug like this and it would also catch possible use-after-free issues in
case someone tried to use iloc.bh after the reference has been dropped.

Generally the scheme around ext4_get_inode_loc() and
ext4_mark_iloc_dirty() seems to be somewhat error prone. E.g. a quick audit
shows that there's bh leak in ext4_orphan_del() in one of the error paths.
I'll send patches.

								Honza

> ---
>  fs/ext4/resize.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index e7ae26e..4d5c0fc 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -874,6 +874,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
>  	if (unlikely(err)) {
>  		ext4_std_error(sb, err);
> +		iloc.bh = NULL;
>  		goto errout;
>  	}
>  	brelse(dind);
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
