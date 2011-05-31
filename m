From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] ext4: Fix ext4 to use pass jbd allocation flags
 if they can handle ENOMEM.
Date: Tue, 31 May 2011 14:10:20 +0200
Message-ID: <20110531121020.GE5614@quack.suse.cz>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563714-4393-1-git-send-email-mkatiyar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EaMKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 08:10:23 -0400
Content-Disposition: inline
In-Reply-To: <1306563714-4393-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-05-11 23:21:54, Manish Katiyar wrote:
> This patch updates ext4 code to pass appropriate transaction
> allocation flags to callers who are safe to deal with ENOMEM.
> Pass JBD2_TOPLEVEL from the callers who are safe to do allocations
> with GFP_KERNEL instead of GFP_NOFS.
  I've indicated places where TOPLEVEL cannot be below. There are about 4
or 5 which are probably OK. Otherwise the patch is OK.

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/acl.c         |    6 ++++--
>  fs/ext4/ext4_jbd2.h   |    8 +++++---
>  fs/ext4/extents.c     |   11 ++++++-----
>  fs/ext4/ialloc.c      |    2 +-
>  fs/ext4/inode.c       |   40 ++++++++++++++++++++++++----------------
>  fs/ext4/ioctl.c       |    6 ++++--
>  fs/ext4/migrate.c     |   10 +++++-----
>  fs/ext4/move_extent.c |    3 ++-
>  fs/ext4/namei.c       |   47 ++++++++++++++++++++++++++++++-----------------
>  fs/ext4/resize.c      |    8 ++++----
>  fs/ext4/super.c       |   18 +++++++++++-------
>  fs/ext4/xattr.c       |    3 ++-
>  12 files changed, 98 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 93dc9a6..95db569 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -351,7 +351,8 @@ ext4_acl_chmod(struct inode *inode)
>  
>  	retry:
>  		handle = ext4_journal_start(inode,
> -				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> +				EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
  As I wrote in my previous email, JBD2_TOPLEVEL is not OK here because we
hold i_mutex.

>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			if (error != -ENOMEM)
> @@ -450,7 +451,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
>  		acl = NULL;
>  
>  retry:
> -	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> +	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
> +				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  The same here.

>  	if (IS_ERR(handle)) {
>  		error = PTR_ERR(handle);
>  		goto release_and_out;
...
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5199bac..b610294 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3811,7 +3811,8 @@ retry:
>  	while (ret >= 0 && ret < max_blocks) {
>  		map.m_lblk = map.m_lblk + ret;
>  		map.m_len = max_blocks = max_blocks - ret;
> -		handle = ext4_journal_start(inode, credits);
> +		handle = ext4_journal_start(inode, credits,
> +					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  And here as well.

>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
>  			break;
...
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 50d0e9c..0355858 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5329,8 +5332,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  		/* (user+group)*(old+new) structure, inode write (sb,
>  		 * inode block, ? - but truncate inode update has it) */
> -		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> -					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
> +		handle = ext4_journal_start(inode,
> +					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> +					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
> +					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			goto err_out;
  Again, TOPLEVEL cannot be here.

> @@ -5364,7 +5369,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	    (attr->ia_size < inode->i_size)) {
>  		handle_t *handle;
>  
> -		handle = ext4_journal_start(inode, 3);
> +		handle = ext4_journal_start(inode, 3,
> +					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			goto err_out;
  And here as well.

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 808c554..b88e295 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -101,7 +101,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		} else if (oldflags & EXT4_EOFBLOCKS_FL)
>  			ext4_truncate(inode);
>  
> -		handle = ext4_journal_start(inode, 1);
> +		handle = ext4_journal_start(inode, 1,
> +					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  And here as well.

>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);
>  			goto flags_out;
> @@ -157,7 +158,8 @@ flags_out:
>  			goto setversion_out;
>  		}
>  
> -		handle = ext4_journal_start(inode, 1);
> +		handle = ext4_journal_start(inode, 1,
> +					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  Here, actually TOPLEVEL is OK.

>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);
>  			goto setversion_out;
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index b57b98f..f233f12 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -485,10 +485,10 @@ int ext4_ext_migrate(struct inode *inode)
>  		return retval;
>  
>  	handle = ext4_journal_start(inode,
> -					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
> -					+ 1);
> +				EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> +				EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
> +				+ 1, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here.

>  	if (IS_ERR(handle)) {
>  		retval = PTR_ERR(handle);
>  		return retval;
...
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 2b8304b..ff4289f 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -813,7 +813,8 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  	 * inode and donor_inode may change each different metadata blocks.
>  	 */
>  	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
> -	handle = ext4_journal_start(orig_inode, jblocks);
> +	handle = ext4_journal_start(orig_inode, jblocks,
> +				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here.

>  	if (IS_ERR(handle)) {
>  		*err = PTR_ERR(handle);
>  		return 0;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b754b77..101d5d5 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1750,9 +1750,11 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, int mode,
>  	dquot_initialize(dir);
>  
>  retry:
> -	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
> +	handle = ext4_journal_start(dir,
> +				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> +				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
  OK, TOPLEVEL possibly could be here because we hold only directory mutex
so writeback won't be stalled. But it's a bit subtle. The same holds for
mknod, mkdir and rmdir below.

>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -1786,9 +1788,11 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
>  	dquot_initialize(dir);
>  
>  retry:
> -	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
> +	handle = ext4_journal_start(dir,
> +				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> +				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -1825,9 +1829,11 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  	dquot_initialize(dir);
>  
>  retry:
> -	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
> +	handle = ext4_journal_start(dir,
> +				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> +				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2140,7 +2146,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	dquot_initialize(dir);
>  	dquot_initialize(dentry->d_inode);
>  
> -	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb),
> +				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2202,7 +2209,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	dquot_initialize(dir);
>  	dquot_initialize(dentry->d_inode);
>  
> -	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb),
> +				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here.

>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2279,7 +2287,8 @@ static int ext4_symlink(struct inode *dir,
>  			  EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb);
>  	}
>  retry:
> -	handle = ext4_journal_start(dir, credits);
> +	handle = ext4_journal_start(dir,
> +				    credits, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2319,7 +2328,8 @@ retry:
>  		 */
>  		handle = ext4_journal_start(dir,
>  				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> -				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 1);
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 1,
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
  Above two cases should be OK.

>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);
>  			goto err_drop_inode;
> @@ -2364,8 +2374,10 @@ static int ext4_link(struct dentry *old_dentry,
>  	dquot_initialize(dir);
>  
>  retry:
> -	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
> +	handle = ext4_journal_start(dir,
> +				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS,
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here.

>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2416,8 +2428,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	if (new_dentry->d_inode)
>  		dquot_initialize(new_dentry->d_inode);
>  	handle = ext4_journal_start(old_dir, 2 *
> -					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
> +				EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
> +				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2,
> +				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
  And it cannot be here either.

>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
...
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index aa842f3..8beb687 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
...
> @@ -4702,7 +4706,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
>  
>  	/* Update modification times of quota files when userspace can
>  	 * start looking at them */
> -	handle = ext4_journal_start(inode, 1);
> +	handle = ext4_journal_start(inode, 1, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here because we hold s_umount on superblock.

>  	if (IS_ERR(handle))
>  		goto out;
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c757adc..e27b289 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
>  	int error, retries = 0;
>  
>  retry:
> -	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> +	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
> +				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
  TOPLEVEL cannot be here.

>  	if (IS_ERR(handle)) {
>  		error = PTR_ERR(handle);
>  	} else {
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
