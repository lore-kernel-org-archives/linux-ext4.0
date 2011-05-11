From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4 : Update low level ext4 journal routines to
 specify gfp_mask for transaction allocation.
Date: Wed, 11 May 2011 18:04:47 +0200
Message-ID: <20110511160447.GJ5057@quack.suse.cz>
References: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab1EKQEt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 12:04:49 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 24-04-11 17:13:18, Manish Katiyar wrote:
> Update low level ext4 journal routines to pass an extra parameter
> to journal allocation routines to specify whether transaction allocation
> can fail or not. With this patch ext4_journal_start() can fail due to
> ENOMEM. Added a new interface ext4_journal_start_tryhard() which isn't
> supposed to fail and keep retrying till the allocation succeeds.
  As I wrote in a comment in the comment to the first patch, first just
make ext4_journal_start_sb() and similar functions pass false as a part of
the first patch.

Then it would be better to create a new function that passes true - the
name does not really matter since it will be removed later in the series
but it will help the review process. You can call it
ext4_journal_start_sb_enomem() or whatever. This way we keep backward
compatibility because currently all call sites really expect the retry
behavior. Then in the patch you can switch safe call sites to use _enomem
variant and at the end of the series as a separate patch you just do
renaming - ext4_journal_start_sb() becomes ext4_journal_start_sb_tryhard()
and ext4_journal_start_sb_enomem() becomes ext4_journal_start_sb().

								Honza

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.h |    8 +++++++-
>  fs/ext4/super.c     |   15 +++++++++++++--
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d0f5353..ee6385c 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -162,6 +162,7 @@ int __ext4_handle_dirty_super(const char *where,
> unsigned int line,
>  	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
> 
>  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
> +handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks);
>  int __ext4_journal_stop(const char *where, unsigned int line,
> handle_t *handle);
> 
>  #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
> @@ -207,6 +208,11 @@ static inline handle_t *ext4_journal_start(struct
> inode *inode, int nblocks)
>  	return ext4_journal_start_sb(inode->i_sb, nblocks);
>  }
> 
> +static inline handle_t *ext4_journal_start_tryhard(struct inode
> *inode, int nblocks)
> +{
> +	return ext4_journal_start_sb_tryhard(inode->i_sb, nblocks);
> +}
> +
>  #define ext4_journal_stop(handle) \
>  	__ext4_journal_stop(__func__, __LINE__, (handle))
> 
> @@ -225,7 +231,7 @@ static inline int ext4_journal_extend(handle_t
> *handle, int nblocks)
>  static inline int ext4_journal_restart(handle_t *handle, int nblocks)
>  {
>  	if (ext4_handle_valid(handle))
> -		return jbd2_journal_restart(handle, nblocks);
> +		return jbd2_journal_restart(handle, nblocks, false);
>  	return 0;
>  }
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..03eac6a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
>   * ext4 prevents a new handle from being started by s_frozen, which
>   * is in an upper layer.
>   */
> -handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> +static handle_t *__ext4_journal_start_sb(struct super_block *sb,
> +					 int nblocks, bool errok)
>  {
>  	journal_t *journal;
>  	handle_t  *handle;
> @@ -279,7 +280,17 @@ handle_t *ext4_journal_start_sb(struct
> super_block *sb, int nblocks)
>  		ext4_abort(sb, "Detected aborted journal");
>  		return ERR_PTR(-EROFS);
>  	}
> -	return jbd2_journal_start(journal, nblocks);
> +	return jbd2_journal_start(journal, nblocks, errok);
> +}
> +
> +handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> +{
> +	return __ext4_journal_start_sb(sb, nblocks, true);
> +}
> +
> +handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks)
> +{
> +	return __ext4_journal_start_sb(sb, nblocks, false);
>  }
> 
>  /*
> -- 
> 1.7.1
> 
> -- 
> Thanks -
> Manish

> From 365d29cd8d5b139e332965a536dd380e656bbd15 Mon Sep 17 00:00:00 2001
> From: Manish Katiyar <mkatiyar@gmail.com>
> Date: Sun, 24 Apr 2011 16:49:48 -0700
> Subject: [PATCH 2/5] Update low level ext4 journal routines to pass an extra paramter
>  to journal allocation routines to specify whether transaction allocation
>  can fail or not. With this patch ext4_journal_start() can fail due to
>  ENOMEM. Added a new interface ext4_journal_start_tryhard() which isn't
>  supposed to fail and keep retrying till the allocation succeeds.
> 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.h |    8 +++++++-
>  fs/ext4/super.c     |   15 +++++++++++++--
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d0f5353..ee6385c 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -162,6 +162,7 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
>  	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
>  
>  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
> +handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks);
>  int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
>  
>  #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
> @@ -207,6 +208,11 @@ static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
>  	return ext4_journal_start_sb(inode->i_sb, nblocks);
>  }
>  
> +static inline handle_t *ext4_journal_start_tryhard(struct inode *inode, int nblocks)
> +{
> +	return ext4_journal_start_sb_tryhard(inode->i_sb, nblocks);
> +}
> +
>  #define ext4_journal_stop(handle) \
>  	__ext4_journal_stop(__func__, __LINE__, (handle))
>  
> @@ -225,7 +231,7 @@ static inline int ext4_journal_extend(handle_t *handle, int nblocks)
>  static inline int ext4_journal_restart(handle_t *handle, int nblocks)
>  {
>  	if (ext4_handle_valid(handle))
> -		return jbd2_journal_restart(handle, nblocks);
> +		return jbd2_journal_restart(handle, nblocks, false);
>  	return 0;
>  }
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..03eac6a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
>   * ext4 prevents a new handle from being started by s_frozen, which
>   * is in an upper layer.
>   */
> -handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> +static handle_t *__ext4_journal_start_sb(struct super_block *sb,
> +					 int nblocks, bool errok)
>  {
>  	journal_t *journal;
>  	handle_t  *handle;
> @@ -279,7 +280,17 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
>  		ext4_abort(sb, "Detected aborted journal");
>  		return ERR_PTR(-EROFS);
>  	}
> -	return jbd2_journal_start(journal, nblocks);
> +	return jbd2_journal_start(journal, nblocks, errok);
> +}
> + 
> +handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> +{
> +	return __ext4_journal_start_sb(sb, nblocks, true);
> +}
> +
> +handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks)
> +{
> +	return __ext4_journal_start_sb(sb, nblocks, false);
>  }
>  
>  /*
> -- 
> 1.7.1
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
