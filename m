From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Tue, 13 Jun 2017 15:14:23 +0200
Message-ID: <20170613131423.GB20258@quack2.suse.cz>
References: <CGME20170613011515epcas1p102b88e7316f3bb79449f21b32dba6b8b@epcas1p1.samsung.com>
 <1497316515-4196-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, hch@infradead.org,
        linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60613 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752785AbdFMNO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Jun 2017 09:14:26 -0400
Content-Disposition: inline
In-Reply-To: <1497316515-4196-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 13-06-17 10:15:15, Daeho Jeong wrote:
> Now, when we mount ext4 filesystem with '-o discard' option, we have to
> issue all the discard commands for the blocks to be deallocated and
> wait for the completion of the commands on the commit complete phase.
> Because this procedure might involve a lot of sequential combinations of
> issuing discard commands and waiting for that, the delay of this
> procedure might be too much long, even to 17.0s in our test,
> and it results in long commit delay and fsync() performance degradation.
> 
> When we converted this sequential discard handling on commit complete
> phase into a parallel manner like XFS filesystem, we could enhance the
> discard command handling performance. The result was such that 17.0s
> delay of a single commit in the worst case has been enhanced to 4.8s.

The patch looks good. Just two small comments and after addressing them
feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

The first comment is that your changelog should also describe in high level
how your implementation works. So you should explain that instead of adding
callback for each extent we instead add a separate list of extents to free
to the superblock and then process this list after transaction commits. The
second comment is below.

> @@ -2791,18 +2791,18 @@ static inline int ext4_issue_discard(struct super_block *sb,
>  	count = EXT4_C2B(EXT4_SB(sb), count);
>  	trace_ext4_discard_blocks(sb,
>  			(unsigned long long) discard_block, count);
> -	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
> +	if (biop) {
> +		return __blkdev_issue_discard(sb->s_bdev,
> +				discard_block << (sb->s_blocksize_bits - 9),
> +				count << (sb->s_blocksize_bits - 9),
> +				GFP_NOFS, 0, biop);

Please type discard_block and count to sector_t before shifting to make it
clear we avoid possible overflows.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
