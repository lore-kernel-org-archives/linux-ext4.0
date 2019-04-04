Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57457C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 10:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F12A20882
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 10:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfDDKS3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:18:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:60948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbfDDKS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Apr 2019 06:18:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B74CDAF1F;
        Thu,  4 Apr 2019 10:18:27 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ED42C1E11C8; Thu,  4 Apr 2019 12:18:23 +0200 (CEST)
Date:   Thu, 4 Apr 2019 12:18:23 +0200
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH] ext4: add inode to ordered data list when extending file
 without block allocation
Message-ID: <20190404101823.GA22313@quack2.suse.cz>
References: <1554370192-113254-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554370192-113254-1-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 04-04-19 17:29:52, zhangyi (F) wrote:
> Currently we capture a NULL data exposure problem after a crash or
> poweroff when append writing a file in the data=ordered mode. The
> problem is that we were not add inode to the transaction's order data
> list when updating i_disksize without new block allocation no matter
> the delay allocated block feature is enabled or not.
> 
> write                           jbd2                    writeback
> append write in allocated block
> mark buffer dirty
> update i_disksize
> mark inode dirty
>                           commit transaction
>                           write inode
>                           (data exposure after a crash)
>                                                     write dirty buffer
> 
> It's fine in the case of new block allocation because we do this job in
> ext4_map_blocks(). To fix this problem, this patch add inode to current
> transaction's order data list after new data is copied and needing
> update i_disksize in the case of no block allocation.
> 
> Fixes: 06bd3c36a733ac ("ext4: fix data exposure after a crash")
> Fixes: f3b59291a69d0b ("ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks for the patch. The current behavior is a deliberate decision.
data=ordered mode does guarantee there is no stale data visible in case of
crash. However it does not guarantee you cannot see zeros where data was
written. 

								Honza
> ---
>  fs/ext4/inode.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b32a57b..5cfa066 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1419,6 +1419,16 @@ static int ext4_write_end(struct file *file,
>  	if (i_size_changed || inline_data)
>  		ext4_mark_inode_dirty(handle, inode);
>  
> +	/*
> +	 * Updating i_disksize when extending file without block
> +	 * allocation, the newly written data where should be visible
> +	 * after transaction commit must be on transaction's ordered
> +	 * data list.
> +	 */
> +	if (copied && (i_size_changed & 0x2) &&
> +	    ext4_should_order_data(inode))
> +		ext4_jbd2_inode_add_write(handle, inode);
> +
>  	if (pos + len > inode->i_size && ext4_can_truncate(inode))
>  		/* if we have allocated more blocks and copied
>  		 * less. We will have blocks allocated outside
> @@ -3185,6 +3195,15 @@ static int ext4_da_write_end(struct file *file,
>  			 * bu greater than i_disksize.(hint delalloc)
>  			 */
>  			ext4_mark_inode_dirty(handle, inode);
> +
> +			/*
> +			 * Updating i_disksize when extending file without
> +			 * block allocation, the newly written data where
> +			 * should be visible after transaction commit must
> +			 * be on transaction's ordered data list.
> +			 */
> +			if (ext4_should_order_data(inode))
> +				ext4_jbd2_inode_add_write(handle, inode);
>  		}
>  	}
>  
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
