Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39400C282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B83020881
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfA1P0R (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:26:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:34930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfA1P0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 10:26:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95A03AE04;
        Mon, 28 Jan 2019 15:26:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6EF9B1E3FEF; Mon, 28 Jan 2019 16:26:16 +0100 (CET)
Date:   Mon, 28 Jan 2019 16:26:16 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v3 2/4] jbd2: discard dirty data when forgetting an
 un-journalled buffer
Message-ID: <20190128152616.GF5858@quack2.suse.cz>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
 <1548419456-4331-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548419456-4331-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 20:30:54, zhangyi (F) wrote:
> We do not unmap and clear dirty flag when forgetting a buffer without
> journal or does not belongs to any transaction, so the invalid dirty
> data may still be written to the disk later. It's fine if the
> corresponding block is never used before the next mount, and it's also
> fine that we invoke clean_bdev_aliases() related functions to unmap
> the block device mapping when re-allocating such freed block as data
> block. But this logic is somewhat fragile and risky that may lead to
> data corruption if we forget to clean bdev aliases. So, It's better to
> discard dirty data during forget time.
> 
> We have been already handled all the cases of forgetting journalled
> buffer, this patch deal with the remaining two cases.
> 
> - buffer is not journalled yet,
> - buffer is journalled but doesn't belongs to any transaction.
> 
> We invoke __bforget() instead of __brelese() when forgetting an
> un-journalled buffer in jbd2_journal_forget(). After this patch we can
> remove all clean_bdev_aliases() related calls in ext4.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks for the patch! Just one small comment below:

> +		/*
> +		 * The buffer is still not written to disk, we should
> +		 * attach this buffer to current transaction to prevent
> +		 * missing writing back when doing checkpoint before
> +		 * the current transaction complete submittion.
> +		 */
> +		__jbd2_journal_temp_unlink_buffer(jh);

Calling __jbd2_journal_temp_unlink_buffer() is not needed when you know the
buffer does not belong to any transaction. Otherwise the patch looks good
to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

after fixing this.

								Honza

> +		clear_buffer_dirty(bh);
> +		__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
> +		spin_unlock(&journal->j_list_lock);
>  	}
>  
> -not_jbd:
>  	jbd_unlock_bh_state(bh);
>  	__brelse(bh);
>  drop:
> @@ -1643,6 +1673,11 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>  		handle->h_buffer_credits++;
>  	}
>  	return err;
> +
> +not_jbd:
> +	jbd_unlock_bh_state(bh);
> +	__bforget(bh);
> +	goto drop;
>  }
>  
>  /**
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
