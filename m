Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D1DC282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 21:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1FF2146E
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 21:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfBAVVV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 16:21:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:54288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbfBAVVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Feb 2019 16:21:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 438DBAF69;
        Fri,  1 Feb 2019 21:21:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 06FBB1E1574; Fri,  1 Feb 2019 22:21:20 +0100 (CET)
Date:   Fri, 1 Feb 2019 22:21:20 +0100
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: Re: [PATCH] Revert "ext4: use ext4_write_inode() when fsyncing w/o a
 journal"
Message-ID: <20190201212119.GB11643@quack2.suse.cz>
References: <20190201044219.12802-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201044219.12802-1-tytso@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 31-01-19 23:42:19, Theodore Ts'o wrote:
> This reverts commit ad211f3e94b314a910d4af03178a0b52a7d1ee0a.
> 
> As Jan Kara pointed out, this change was unsafe since it means we lose
> the call to sync_mapping_buffers() in the nojournal case.  The
> original point of the commit was avoid taking the inode mutex (since
> it causes a lockdep warning in generic/113); but we need the mutex in
> order to call sync_mapping_buffers().

Actually, I don't think sync_mapping_buffers() needs inode mutex (i_rwsem
these days). It uses blkdev_mapping->private_lock for synchronization of
operations on the list of buffers and fsync_buffers_list() seems to be
pretty careful about races with mark_buffer_dirty_inode(). So why do you
think we need i_rwsem?

> The real fix to this problem was discussed here:
> 
> https://lore.kernel.org/lkml/20181025150540.259281-4-bvanassche@acm.org
> 
> The proposed patch was to fix a syzbot complaint, but the problem can
> also demonstrated via "kvm-xfstests -c nojournal generic/113".
> Multiple solutions were discused in the e-mail thread, but none have
> landed in the kernel as of this writing.  Anyway, commit
> ad211f3e94b314 is absolutely the wrong way to suppress the lockdep, so
> revert it.
> 
> Fixes: ad211f3e94b314a910d4af03178a0b52a7d1ee0a ("ext4: use ext4_write_inode() when fsyncing w/o a journal")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported: Jan Kara <jack@suse.cz>

So if you decide to go via a safe way of reverting the change, I'm fine
with that so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fsync.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 712f00995390..5508baa11bb6 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -116,16 +116,8 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		goto out;
>  	}
>  
> -	ret = file_write_and_wait_range(file, start, end);
> -	if (ret)
> -		return ret;
> -
>  	if (!journal) {
> -		struct writeback_control wbc = {
> -			.sync_mode = WB_SYNC_ALL
> -		};
> -
> -		ret = ext4_write_inode(inode, &wbc);
> +		ret = __generic_file_fsync(file, start, end, datasync);
>  		if (!ret)
>  			ret = ext4_sync_parent(inode);
>  		if (test_opt(inode->i_sb, BARRIER))
> @@ -133,6 +125,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		goto out;
>  	}
>  
> +	ret = file_write_and_wait_range(file, start, end);
> +	if (ret)
> +		return ret;
>  	/*
>  	 * data=writeback,ordered:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
