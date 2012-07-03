From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 3/4] ext4: remove unnecessary superblock dirtying
Date: Tue, 3 Jul 2012 14:48:04 +0200
Message-ID: <20120703124804.GC27388@quack.suse.cz>
References: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
 <1341316810-22598-4-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab2GCMsH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2012 08:48:07 -0400
Content-Disposition: inline
In-Reply-To: <1341316810-22598-4-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Artem,

  thanks for your persistence with this. I wanted to give you my
Reviewed-by on this patch but I've noticed two (mostly minor) things
(see below).

On Tue 03-07-12 15:00:09, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> This patch changes the '__ext4_handle_dirty_super()' function which is used
> by ext4 to update the super-block via the journal in the following cases:
> 
> 1. When creating the first large file on a file
>    system without EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
> 2. When re-sizing the file-system
> 3. When creating an xattr on a file-system without the
>    EXT4_FEATURE_COMPAT_EXT_ATTR feature.
  Since this was written, we seem to have grown a use of
ext4_handle_dirty_super() in fs/ext4/namei.c when adding inode to orphan
list.

> This function, however, falls back to just marking the superblock as dirty
> if the file-system has no journal. But it is user really rarely and it does not
> give any benefit to use the delayed superblock write (via the VFS's
> 'sync_supers()' kernel thread) in these cases. We can just write out the
> superblock asynchronously instead.
> 
> This patch also removes 's_dirt' condition on the unmount path because we never
> set it anymore, so we should not test it.
> 
> Tested using xfstests for both journalled and non-journalled ext4.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/ext4/ext4.h      |    1 +
>  fs/ext4/ext4_jbd2.c |    2 +-
>  fs/ext4/super.c     |    5 ++---
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
...
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 90f7c2e..27354df 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -156,6 +156,6 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
>  				(struct ext4_super_block *)bh->b_data);
>  		mark_buffer_dirty(bh);
>  	} else
> -		sb->s_dirt = 1;
> +		err = ext4_commit_super(sb, 0);
  When you look at the whole __ext4_handle_dirty_super() function now, it
doesn't make much sense like this. When now == 1, we mark superblock buffer
as dirty, when now == 0, we set wtime, kbytes_written, free blocks and
inodes in the superblock buffer and then mark it dirty. Looking into all
the places calling this, I'd just drop the 'now' argument and make
everything behave as in now == 1 case.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
