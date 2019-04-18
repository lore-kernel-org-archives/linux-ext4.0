Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6366AC10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33DBE214DA
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388842AbfDRL0c (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:26:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:41930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388841AbfDRL0b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 07:26:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C484AAE60;
        Thu, 18 Apr 2019 11:26:30 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 672361E15AE; Thu, 18 Apr 2019 13:26:28 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:26:28 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: protect journal inode's blocks using block_validity
Message-ID: <20190418112628.GD28541@quack2.suse.cz>
References: <20190410033859.5328-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410033859.5328-1-tytso@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 09-04-19 23:38:59, Theodore Ts'o wrote:
> Add the blocks which belong to the journal inode to block_validity's
> system zone so attempts to deallocate or overwrite the journal due a
> corrupted file system where the journal blocks are also claimed by
> another inode.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/block_validity.c | 48 ++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/inode.c          |  4 ++++
>  2 files changed, 52 insertions(+)

The patch looks good to me just two suggestions:

...
> +	while (i < num) {
> +		map.m_lblk = i;
> +		map.m_len = num - i;
> +		n = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (n < 0) {
> +			err = n;
> +			break;
> +		}
> +		if (n == 0) {
> +			i++;

map.m_len actually contains the hole length so you can do
			i += map.m_len;
to skip the whole hole at once.

> @@ -171,6 +213,12 @@ int ext4_setup_system_zone(struct super_block *sb)
>  		if (ret)
>  			return ret;
>  	}
> +	if (ext4_has_feature_journal(sb) && sbi->s_es->s_journal_inum) {
> +		ret = ext4_protect_reserved_inode(sb,
> +				le32_to_cpu(sbi->s_es->s_journal_inum));
> +		if (ret)
> +			return ret;
> +	}
>  

I guess we could protect resize inode the same way?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
