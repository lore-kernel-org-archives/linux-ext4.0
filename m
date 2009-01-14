From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 10:18:34 -0800
Message-ID: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
References: <1231945948-23676-1-git-send-email-jack@suse.cz>
	<1231945948-23676-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZANSSl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 13:18:41 -0500
In-Reply-To: <1231945948-23676-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 14 Jan 2009 16:12:28 +0100 Jan Kara <jack@suse.cz> wrote:

> To be really safe that the data hit the platter, we should also flush drive's
> writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> 

It's not good to randomly sprinkle blkdev_issue_flush() calls all over
the filesystem like this.  How do we know that you didn't miss a site? 
How do we ensure that people who modify the fs in the future don't
forget to add the blkdev_issue_flush() call, if needed?

IOW, it is fragile.  Is there anything we can do to make this more
robust?  Do the flush calls from some higher-level callsite?  Perhaps
even the VFS?

> @@ -97,8 +98,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
>  
>  	if (IS_DIRSYNC(dir)) {
>  		err = write_one_page(page, 1);
> -		if (!err)
> +		if (!err) {
>  			err = ext2_sync_inode(dir);
> +			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);

The patch itself would have been a bit neater if it had added

int ext3_blkdev_issue_flush(struct inode *inode)

and called that, IMO.


Also, the changelog needs some work, methinks.

/**
 * blkdev_issue_flush - queue a flush
 * @bdev:	blockdev to issue flush for
 * @error_sector:	error sector
 *
 * Description:
 *    Issue a flush for the block device in question. Caller can supply
 *    room for storing the error offset in case of a flush error, if they
 *    wish to.  Caller must run wait_for_completion() on its own.
 */

So afaict the change you've made is incomplete.  We'll queue a
writeback command to the disk but we won't wait for it to be sent down
the wire.  Nor do we wait for the command to complete at the device
end.  So it can still be a looong time (seconds!) before the data which
the user thinks is on disk really is safe.

Yes?

If so, this design decision should be described in the changelog, and
justified.  Actually, doing this in the comment over
ext3_blkdev_issue_flush() would be good.


