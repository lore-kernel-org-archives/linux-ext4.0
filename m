From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext2: clear uptodate flag on super block I/O error (v2)
Date: Thu, 19 Nov 2009 16:19:53 +0100
Message-ID: <20091119151953.GA2943@atrey.karlin.mff.cuni.cz>
References: <20091117174617.285298261@vyatta.com> <20091117174647.315080808@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43425 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbZKSPTr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 10:19:47 -0500
Content-Disposition: inline
In-Reply-To: <20091117174647.315080808@vyatta.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This fixes a WARN backtrace in mark_buffer_dirty() that occurs during
> unmount when a USB or floppy device is removed. 
> The super block update from a previous operation has marked the buffer
> as in error, and the flag has to be cleared before doing the update.
> (Similar code already exists in ext4).
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
  Although I agree with Nick that ultimate solution would be to stop
clearing the uptodate flag, I think the change is fine in principle
as a workaround for warning that only scares people.

> --- a/fs/ext2/super.c	2009-11-17 09:13:21.346375999 -0800
> +++ b/fs/ext2/super.c	2009-11-17 09:14:12.177002522 -0800
> @@ -1099,11 +1099,24 @@ static void ext2_commit_super (struct su
>  
>  static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
>  {
> +	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
> +
> +	if (buffer_write_io_error(sbh)) {
> +		/*
> +		 * This happens if USB or floppy device is yanked out.
> +		 * Maybe user put device back in so warn and update again.
> +		 */
> +		printk(KERN_ERR
> +		       "EXT2-fs: previous I/O error to superblock detected\n");
> +		clear_buffer_write_io_error(sbh);
> +		set_buffer_uptodate(sbh);
  It's not much about puting the device back. It's really just about
avoiding the warning in mark_buffer_dirty(). So I'd just silently
set_buffer_uptodate and be done with it. For superblock we are darn sure
that in memory copy is the one that has the latest data :)

> +	}
> +
>  	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
>  	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
>  	es->s_wtime = cpu_to_le32(get_seconds());
> -	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
> -	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
> +	mark_buffer_dirty(sbh);
> +	sync_dirty_buffer(sbh);
>  	sb->s_dirt = 0;
>  }

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
