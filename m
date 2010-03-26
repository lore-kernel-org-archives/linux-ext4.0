From: Surbhi Palande <Surbhi.Palande@canonical.com>
Subject: Re: [PATCH] ext3: call blkdev_issue_flush on fsync
Date: Fri, 26 Mar 2010 21:55:20 +0200
Message-ID: <1269633320.30275.25.camel@subu>
References: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
Reply-To: Surbhi.Palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:52893 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0CZTzb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 15:55:31 -0400
In-Reply-To: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please ignore this patch! Sorry for this!

Warm Regards,
Surbhi.

On Fri, 2010-03-26 at 18:50 +0200, Surbhi Palande wrote:
> To ensure that bits are truly on-disk after an fsync,
> we should call blkdev_issue_flush if barriers are supported.
> 
> This code is seen in ext4 through commits
> d755fb384250d6bd7fd18a0930e71965acc8e72e and
> 5f3481e9a80c240f169b36ea886e2325b9aeb745.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> ---
>  fs/ext3/fsync.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
> index d336341..2184a40 100644
> --- a/fs/ext3/fsync.c
> +++ b/fs/ext3/fsync.c
> @@ -29,6 +29,7 @@
>  #include <linux/jbd.h>
>  #include <linux/ext3_fs.h>
>  #include <linux/ext3_jbd.h>
> +#include <linux/blkdev.h>
>  
>  /*
>   * akpm: A new design for ext3_sync_file().
> @@ -46,6 +47,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int ret = 0;
> +	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
>  
>  	J_ASSERT(ext3_journal_current_handle() == NULL);
>  
> @@ -87,5 +89,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
>  		ret = sync_inode(inode, &wbc);
>  	}
>  out:
> +	if (journal && (journal->j_flags & JFS_BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  	return ret;
>  }


