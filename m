Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419E3C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133402183E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388895AbfDRL7o (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:59:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:48104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388344AbfDRL7o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 07:59:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DB88AECB;
        Thu, 18 Apr 2019 11:59:43 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EC51F1E15AE; Thu, 18 Apr 2019 13:59:40 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:59:40 +0200
From:   Jan Kara <jack@suse.cz>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH RFC] ext4: Actually request zeroing of inode table after
 grow
Message-ID: <20190418115940.GG28541@quack2.suse.cz>
References: <155542964388.661.13244611252760297285.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155542964388.661.13244611252760297285.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 16-04-19 18:53:12, Kirill Tkhai wrote:
> [Hi!
>  I occasionally found this place, and not familiar with ext4.
>  But this place looks like doing the wrong thing.
>  s_groups_count may only work, and there must be another sign.
>  Please, take a look.
> ]
> 
> It is never possible, that number of block groups decreases,
> since only online grow is supported.
> 
> But after a growing occured, we have to zero inode tables
> for just created new block groups.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> ---
>  fs/ext4/ioctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for the patch. Looks like a good catch. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index bab3da4f1e0d..20faa6a69238 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -978,7 +978,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		if (err == 0)
>  			err = err2;
>  		mnt_drop_write_file(filp);
> -		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
> +		if (!err && (o_group < EXT4_SB(sb)->s_groups_count) &&
>  		    ext4_has_group_desc_csum(sb) &&
>  		    test_opt(sb, INIT_INODE_TABLE))
>  			err = ext4_register_li_request(sb, o_group);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
