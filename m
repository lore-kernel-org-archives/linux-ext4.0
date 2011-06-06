From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 03/30] ext4: snapshot hooks - inside JBD hooks
Date: Mon, 6 Jun 2011 17:53:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106061732000.3934@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <1304959308-11122-4-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab1FFPxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 11:53:46 -0400
In-Reply-To: <1304959308-11122-4-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:

> From: Amir Goldstein <amir73il@users.sf.net>
> 
> Before every metadata buffer write, the journal API is called,
> namely, one of the ext4_journal_get_XXX_access() functions.
> We use these journal hooks to call the snapshot API, namely
> ext4_snapshot_get_XXX_access(), to COW the metadata buffer before
> it is modified for the first time.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.c   |    9 +++++++--
>  fs/ext4/ext4_jbd2.h   |   15 +++++++++++----
>  fs/ext4/extents.c     |    3 ++-
>  fs/ext4/inode.c       |   22 +++++++++++++++-------
>  fs/ext4/move_extent.c |    3 ++-
>  5 files changed, 37 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 560020d..833969b 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -23,13 +23,16 @@ int __ext4_journal_get_undo_access(const char *where, unsigned int line,
>  	return err;
>  }
>  
> -int __ext4_journal_get_write_access(const char *where, unsigned int line,
> -				    handle_t *handle, struct buffer_head *bh)
> +int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
> +					 handle_t *handle, struct inode *inode,
> +					 struct buffer_head *bh, int exclude)
>  {
>  	int err = 0;
>  
>  	if (ext4_handle_valid(handle)) {
>  		err = jbd2_journal_get_write_access(handle, bh);
> +		if (!err && !exclude)
> +			err = ext4_snapshot_get_write_access(handle, inode, bh);

Agh, this is not defined anywhere again. Actually it is defined only if
snapshot is not configured in. It is quite painful to review when half
of the code is missing really. And also something like this will break
bisecting for all of us. Is not there really the other way ?

Also, could you document the new parameters ?

Anyway:
	if (!err && !exclude && inode)

>  		if (err)
>  			ext4_journal_abort_handle(where, line, __func__, bh,
>  						  handle, err);
> @@ -111,6 +114,8 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
>  
>  	if (ext4_handle_valid(handle)) {
>  		err = jbd2_journal_get_create_access(handle, bh);
> +		if (!err)
> +			err = ext4_snapshot_get_create_access(handle, bh);
>  		if (err)
>  			ext4_journal_abort_handle(where, line, __func__,
>  						  bh, handle, err);
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 8ffffb1..75662f7 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -132,9 +132,9 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
>  int __ext4_journal_get_undo_access(const char *where, unsigned int line,
>  				   handle_t *handle, struct buffer_head *bh);
>  
> -int __ext4_journal_get_write_access(const char *where, unsigned int line,
> -				    handle_t *handle, struct buffer_head *bh);
> -
> +int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
> +					 handle_t *handle, struct inode *inode,
> +					 struct buffer_head *bh, int exclude);
>  int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
>  		  int is_metadata, struct inode *inode,
>  		  struct buffer_head *bh, ext4_fsblk_t blocknr);
> @@ -151,8 +151,15 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
>  
>  #define ext4_journal_get_undo_access(handle, bh) \
>  	__ext4_journal_get_undo_access(__func__, __LINE__, (handle), (bh))
> +#define ext4_journal_get_write_access_exclude(handle, bh) \
> +	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
> +						 (handle), NULL, (bh), 1)
>  #define ext4_journal_get_write_access(handle, bh) \
> -	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
> +	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
> +						 (handle), NULL, (bh), 0)
> +#define ext4_journal_get_write_access_inode(handle, inode, bh) \
> +	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
> +						(handle), (inode), (bh), 0)

Could you add some comments so everyone knows when to use the _exclude
helper and when not?

>  #define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
>  	__ext4_forget(__func__, __LINE__, (handle), (is_metadata), (inode), \
>  		      (bh), (block_nr))
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0c3ea93..c8cab3d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -77,7 +77,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
>  {
>  	if (path->p_bh) {
>  		/* path points to block */
> -		return ext4_journal_get_write_access(handle, path->p_bh);
> +		return ext4_journal_get_write_access_inode(handle,
> +					inode, path->p_bh);
>  	}
>  	/* path points to leaf/index in inode body */
>  	/* we use in-core data, no need to protect them */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a597ff1..b848072 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -874,7 +874,8 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
>  	 */
>  	if (where->bh) {
>  		BUFFER_TRACE(where->bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, where->bh);
> +		err = ext4_journal_get_write_access_inode(handle, inode,
> +							   where->bh);
>  		if (err)
>  			goto err_out;
>  	}
> @@ -4172,7 +4173,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
>  			goto out_err;
>  		if (bh) {
>  			BUFFER_TRACE(bh, "retaking write access");
> -			err = ext4_journal_get_write_access(handle, bh);
> +			err = ext4_journal_get_write_access_inode(handle,
> +								  inode, bh);
>  			if (unlikely(err))
>  				goto out_err;
>  		}
> @@ -4223,7 +4225,8 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
>  
>  	if (this_bh) {				/* For indirect block */
>  		BUFFER_TRACE(this_bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, this_bh);
> +		err = ext4_journal_get_write_access_inode(handle, inode,
> +							   this_bh);
>  		/* Important: if we can't update the indirect pointers
>  		 * to the blocks, we can't free them. */
>  		if (err)
> @@ -4386,8 +4389,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
>  				 * pointed to by an indirect block: journal it
>  				 */
>  				BUFFER_TRACE(parent_bh, "get_write_access");
> -				if (!ext4_journal_get_write_access(handle,
> -								   parent_bh)){
> +				if (!ext4_journal_get_write_access_inode(
> +					    handle, inode, parent_bh)){
>  					*p = 0;
>  					BUFFER_TRACE(parent_bh,
>  					"call ext4_handle_dirty_metadata");
> @@ -4759,9 +4762,14 @@ has_buffer:
>  
>  int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
>  {
> -	/* We have all inode data except xattrs in memory here. */
> -	return __ext4_get_inode_loc(inode, iloc,
> +	int in_mem = (!EXT4_SNAPSHOTS(inode->i_sb) &&
>  		!ext4_test_inode_state(inode, EXT4_STATE_XATTR));
> +
> +	/*
> +	 * We have all inode's data except xattrs in memory here,
> +	 * but we must always read-in the entire inode block for COW.
> +	 */
> +	return __ext4_get_inode_loc(inode, iloc, in_mem);
>  }
>  
>  void ext4_set_inode_flags(struct inode *inode)
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index b9f3e78..ad5409a 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -421,7 +421,8 @@ mext_insert_extents(handle_t *handle, struct inode *orig_inode,
>  
>  	if (depth) {
>  		/* Register to journal */
> -		ret = ext4_journal_get_write_access(handle, orig_path->p_bh);
> +		ret = ext4_journal_get_write_access_inode(handle,
> +					orig_inode, orig_path->p_bh);
>  		if (ret)
>  			return ret;
>  	}
> 

-- 
