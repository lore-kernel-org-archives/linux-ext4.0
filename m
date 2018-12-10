Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbeLJNtx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 08:49:53 -0500
Date: Mon, 10 Dec 2018 14:49:49 +0100
From: Jan Kara <jack@suse.cz>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com, axboe@kernel.dk,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com
Subject: Re: [PATCH 1/2] fs: introduce APIs to enable sending write-hint with
 buffer-head
Message-ID: <20181210134949.GL29289@quack2.suse.cz>
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
 <CGME20181210125251epcas1p3023db72cc08d6b2f899141d551d53f61@epcas1p3.samsung.com>
 <1544446204-5291-2-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544446204-5291-2-git-send-email-joshi.k@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-12-18 18:20:03, Kanchan Joshi wrote:
> submit_bh and write_dirty_buffer do not take write-hint as
> parameter. This patch introduces variants which do.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

...

> @@ -3162,6 +3169,20 @@ void write_dirty_buffer(struct buffer_head *bh, int op_flags)
>  }
>  EXPORT_SYMBOL(write_dirty_buffer);
>  
> +void write_dirty_buffer_write_hint(struct buffer_head *bh, int op_flags,
> +				   enum rw_hint hint)
> +{
> +	lock_buffer(bh);
> +	if (!test_clear_buffer_dirty(bh)) {
> +		unlock_buffer(bh);
> +		return;
> +	}
> +	bh->b_end_io = end_buffer_write_sync;
> +	get_bh(bh);
> +	submit_bh_wbc(REQ_OP_WRITE, op_flags, bh, hint, NULL);
> +}
> +EXPORT_SYMBOL(write_dirty_buffer_write_hint);
> +

Please implement write_dirty_buffer() as a call to
write_dirty_buffer_write_hint() so that we don't unnecessarily duplicate
the code. Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
