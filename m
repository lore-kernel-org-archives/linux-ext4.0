From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Ensure writecache to disk in no journal mode
Date: Fri, 26 Mar 2010 19:37:27 +0300
Message-ID: <87pr2rhwe0.fsf@openvz.org>
References: <1269620462-25906-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57505 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0CZQhj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 12:37:39 -0400
Received: by bwz1 with SMTP id 1so1961341bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 09:37:38 -0700 (PDT)
In-Reply-To: <1269620462-25906-1-git-send-email-surbhi.palande@canonical.com>
	(Surbhi Palande's message of "Fri, 26 Mar 2010 18:21:02 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Surbhi Palande <surbhi.palande@canonical.com> writes:

> Ensure that in the no journal mode the write cache is flushed to the disk by
> calling a blkdev_issue_flush() which issues a WRITE_BARRIER if necessary.
As soon as i understand, nojournal mode is assumed to be used for
fail-free block devices(raid + UPS). So we don't have to worry about
blkdev's wcache vs persistent storage correctness.
>
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> ---
>  fs/ext4/fsync.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index d6049e4..1d73a50 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -67,8 +67,12 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (!journal)
> -		return simple_fsync(file, dentry, datasync);
> +	if (!journal) {
> +		ret = simple_fsync(file, dentry, datasync);
> +		if (test_opt(inode->i_sb, BARRIER))
> +			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> +		return ret;
> +	}
>  
>  	/*
>  	 * data=writeback,ordered:
