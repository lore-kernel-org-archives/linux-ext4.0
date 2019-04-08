Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F314CC10F13
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C05E520863
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfDHLLL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:11:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:54040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfDHLLL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 8 Apr 2019 07:11:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7778AE80;
        Mon,  8 Apr 2019 11:11:09 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 117871E424A; Mon,  8 Apr 2019 13:11:08 +0200 (CEST)
Date:   Mon, 8 Apr 2019 13:11:08 +0200
From:   Jan Kara <jack@suse.cz>
To:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Cc:     viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] fs/buffer.c: Fix data corruption when buffer write with
 IO error
Message-ID: <20190408111108.GB18662@quack2.suse.cz>
References: <1554534793-31444-1-git-send-email-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554534793-31444-1-git-send-email-zhangxiaoxu5@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat 06-04-19 15:13:13, ZhangXiaoxu wrote:
> When the buffer write failed, 'end_buffer_write_sync' and
> 'end_buffer_async_write' will clear the uptodate flag. But the
> data in the buffer maybe newer than disk. In some case, this
> will lead data corruption.
> 
> For example: ext4 flush metadata to disk failed, it will clear
> the uptodate flag. when a new coming call want the buffer, it will
> read it from the disk(because the buffer no uptodate flag). But
> the journal not checkpoint now, it will read old data from disk.
> If read successfully, ext4 will write the old data to the new
> journal, the data will corruption.
> 
> So, don't clear the uptodate flag when write the buffer failed.
> 
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

Thanks for the patch. But what are the chances that after the write has
failed the read will succeed? Also there were places that were using
buffer_uptodate() to detect IO errors. Did you check all those got
converted to using buffer_write_io_error() instead?

								Honza

> ---
>  fs/buffer.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ce35760..9fe1827 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -172,7 +172,6 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
>  	} else {
>  		buffer_io_error(bh, ", lost sync page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  	unlock_buffer(bh);
>  	put_bh(bh);
> @@ -325,7 +324,6 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
>  	} else {
>  		buffer_io_error(bh, ", lost async page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  		SetPageError(page);
>  	}
>  
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
