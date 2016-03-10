From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/3] ext4: fix races between changing inode journal
 mode and ext4_writepages
Date: Thu, 10 Mar 2016 11:04:03 +0100
Message-ID: <20160310100403.GF5026@quack.suse.cz>
References: <1457510987-31726-1-git-send-email-daeho.jeong@samsung.com>
 <1457510987-31726-2-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536AbcCJKDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2016 05:03:43 -0500
Content-Disposition: inline
In-Reply-To: <1457510987-31726-2-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 09-03-16 17:09:46, Daeho Jeong wrote:
> Now, in ext4, there is a race condition between changing inode journal
> mode and ext4_writepages(). While ext4_writepages() is executed on
> a non-journalled mode inode, the inode's journal mode could be enabled
> by ioctl() and then, some pages dirtied after switching the journal
> mode will be still exposed to ext4_writepages() in non-journaled mode.
> To resolve this problem, we use fs-wide per-cpu rw semaphore by
> Jan Kara's suggestion because we don't want to waste ext4_inode_info's
> space for this extra rare case.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

The patch is almost fine except for one small issue:

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9ecfb76..1176142 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2476,6 +2476,7 @@ static int ext4_writepages(struct address_space *mapping,
>  	struct blk_plug plug;
>  	bool give_up_on_write = false;
>  
> +	percpu_down_read(&sbi->s_journal_flag_rwsem);
>  	trace_ext4_writepages(inode, wbc);

You need to change how dax_writeback_mapping_range() is called a few lines
below so that it also exits via out_writepages: and not directly.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
