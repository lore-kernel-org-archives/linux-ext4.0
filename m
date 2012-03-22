From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 1/9] ext4: do not mark superblock as dirty
 unnecessarily
Date: Thu, 22 Mar 2012 10:58:19 +0100
Message-ID: <20120322095819.GD14485@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <1332254489-2300-2-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125Ab2CVJ6V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 05:58:21 -0400
Content-Disposition: inline
In-Reply-To: <1332254489-2300-2-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-03-12 16:41:21, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Commit a0375156ca1041574b5d47cc7e32f10b891151b0 cleaned up superblock dirtying
> handling, but missed one place. This patch does what was intended: if we have
> the journal, then we update the superblock through the journal rather than
> doing this directly.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
  Looks OK.
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/inode.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..e040403 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3924,10 +3924,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  			ext4_update_dynamic_rev(sb);
>  			EXT4_SET_RO_COMPAT_FEATURE(sb,
>  					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
> -			sb->s_dirt = 1;
>  			ext4_handle_sync(handle);
> -			err = ext4_handle_dirty_metadata(handle, NULL,
> -					EXT4_SB(sb)->s_sbh);
> +			err = ext4_handle_dirty_super(handle, sb);
>  		}
>  	}
>  	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
