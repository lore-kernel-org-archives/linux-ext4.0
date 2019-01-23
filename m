Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FD5C282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 11:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E0420861
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 11:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfAWLe5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:34:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:59482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfAWLe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 06:34:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ADD40AEC8;
        Wed, 23 Jan 2019 11:34:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 553C11E3FF5; Wed, 23 Jan 2019 12:34:55 +0100 (CET)
Date:   Wed, 23 Jan 2019 12:34:55 +0100
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH 2/3] ext4: use ext4_write_inode() when fsyncing w/o a
 journal
Message-ID: <20190123113455.GA20927@quack2.suse.cz>
References: <20181231194836.3761-1-tytso@mit.edu>
 <20181231194836.3761-2-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181231194836.3761-2-tytso@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 31-12-18 14:48:35, Theodore Ts'o wrote:
> In no-journal mode, we previously used __generic_file_fsync() in
> no-journal mode.  This triggers a lockdep warning, and in addition,
> it's not safe to depend on the inode writeback mechanism in the case
> ext4.  We can solve both problems by calling ext4_write_inode()
> directly.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
>  fs/ext4/fsync.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 26a7fe5c4fd3..87a7ff00ef62 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -116,8 +116,16 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		goto out;
>  	}
>  
> +	ret = file_write_and_wait_range(file, start, end);
> +	if (ret)
> +		return ret;
> +
>  	if (!journal) {
> -		ret = __generic_file_fsync(file, start, end, datasync);
> +		struct writeback_control wbc = {
> +			.sync_mode = WB_SYNC_ALL
> +		};
> +
> +		ret = ext4_write_inode(inode, &wbc);

Going through some older email... How come this is safe Ted?
ext4_write_inode() will not write out metadata buffers associated with the
inode (unlike __generic_file_fsync() which calls sync_mapping_buffers()).
So you probably need to call sync_mapping_buffers() before calling
ext4_write_inode() here?

								Honza

> @@ -125,9 +133,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		goto out;
>  	}
>  
> -	ret = file_write_and_wait_range(file, start, end);
> -	if (ret)
> -		return ret;
>  	/*
>  	 * data=writeback,ordered:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
