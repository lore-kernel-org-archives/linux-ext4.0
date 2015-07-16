From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 4/6] ocfs2: Handle error from dquot_initialize()
Date: Thu, 16 Jul 2015 10:35:16 +0800
Message-ID: <55A71864.5020901@oracle.com>
References: <1436964152-11203-1-git-send-email-jack@suse.com> <1436964152-11203-5-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1436964152-11203-5-git-send-email-jack@suse.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/15/2015 08:42 PM, Jan Kara wrote:
> dquot_initialize() can now return error. Handle it where possible.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

Looks good.

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>

> ---
>  fs/ocfs2/file.c         | 14 ++++++++----
>  fs/ocfs2/namei.c        | 59 +++++++++++++++++++++++++++++++++++++------------
>  fs/ocfs2/refcounttree.c |  5 +++--
>  3 files changed, 58 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 4d9e8275ed99..7210583b472f 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -105,8 +105,11 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
>  			      file->f_path.dentry->d_name.len,
>  			      file->f_path.dentry->d_name.name, mode);
>  
> -	if (file->f_mode & FMODE_WRITE)
> -		dquot_initialize(inode);
> +	if (file->f_mode & FMODE_WRITE) {
> +		status = dquot_initialize(inode);
> +		if (status)
> +			goto leave;
> +	}
>  
>  	spin_lock(&oi->ip_lock);
>  
> @@ -1155,8 +1158,11 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  	if (status)
>  		return status;
>  
> -	if (is_quota_modification(inode, attr))
> -		dquot_initialize(inode);
> +	if (is_quota_modification(inode, attr)) {
> +		status = dquot_initialize(inode);
> +		if (status)
> +			return status;
> +	}
>  	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
>  	if (size_change) {
>  		status = ocfs2_rw_lock(inode, 1);
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 6e6abb93fda5..948681e37cfd 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -200,11 +200,12 @@ bail:
>  static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
>  {
>  	struct inode *inode;
> +	int status;
>  
>  	inode = new_inode(dir->i_sb);
>  	if (!inode) {
>  		mlog(ML_ERROR, "new_inode failed!\n");
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	/* populate as many fields early on as possible - many of
> @@ -213,7 +214,10 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
>  	if (S_ISDIR(mode))
>  		set_nlink(inode, 2);
>  	inode_init_owner(inode, dir, mode);
> -	dquot_initialize(inode);
> +	status = dquot_initialize(inode);
> +	if (status)
> +		return ERR_PTR(status);
> +
>  	return inode;
>  }
>  
> @@ -264,7 +268,11 @@ static int ocfs2_mknod(struct inode *dir,
>  			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
>  			  (unsigned long)dev, mode);
>  
> -	dquot_initialize(dir);
> +	status = dquot_initialize(dir);
> +	if (status) {
> +		mlog_errno(status);
> +		return status;
> +	}
>  
>  	/* get our super block */
>  	osb = OCFS2_SB(dir->i_sb);
> @@ -311,8 +319,9 @@ static int ocfs2_mknod(struct inode *dir,
>  	}
>  
>  	inode = ocfs2_get_init_inode(dir, mode);
> -	if (!inode) {
> -		status = -ENOMEM;
> +	if (IS_ERR(inode)) {
> +		status = PTR_ERR(inode);
> +		inode = NULL;
>  		mlog_errno(status);
>  		goto leave;
>  	}
> @@ -708,7 +717,11 @@ static int ocfs2_link(struct dentry *old_dentry,
>  	if (S_ISDIR(inode->i_mode))
>  		return -EPERM;
>  
> -	dquot_initialize(dir);
> +	err = dquot_initialize(dir);
> +	if (err) {
> +		mlog_errno(err);
> +		return err;
> +	}
>  
>  	err = ocfs2_double_lock(osb, &old_dir_bh, old_dir,
>  			&parent_fe_bh, dir, 0);
> @@ -896,7 +909,11 @@ static int ocfs2_unlink(struct inode *dir,
>  			   (unsigned long long)OCFS2_I(dir)->ip_blkno,
>  			   (unsigned long long)OCFS2_I(inode)->ip_blkno);
>  
> -	dquot_initialize(dir);
> +	status = dquot_initialize(dir);
> +	if (status) {
> +		mlog_errno(status);
> +		return status;
> +	}
>  
>  	BUG_ON(d_inode(dentry->d_parent) != dir);
>  
> @@ -1230,8 +1247,16 @@ static int ocfs2_rename(struct inode *old_dir,
>  			   old_dentry->d_name.len, old_dentry->d_name.name,
>  			   new_dentry->d_name.len, new_dentry->d_name.name);
>  
> -	dquot_initialize(old_dir);
> -	dquot_initialize(new_dir);
> +	status = dquot_initialize(old_dir);
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	status = dquot_initialize(new_dir);
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
>  
>  	osb = OCFS2_SB(old_dir->i_sb);
>  
> @@ -1786,7 +1811,11 @@ static int ocfs2_symlink(struct inode *dir,
>  	trace_ocfs2_symlink_begin(dir, dentry, symname,
>  				  dentry->d_name.len, dentry->d_name.name);
>  
> -	dquot_initialize(dir);
> +	status = dquot_initialize(dir);
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
>  
>  	sb = dir->i_sb;
>  	osb = OCFS2_SB(sb);
> @@ -1831,8 +1860,9 @@ static int ocfs2_symlink(struct inode *dir,
>  	}
>  
>  	inode = ocfs2_get_init_inode(dir, S_IFLNK | S_IRWXUGO);
> -	if (!inode) {
> -		status = -ENOMEM;
> +	if (IS_ERR(inode)) {
> +		status = PTR_ERR(inode);
> +		inode = NULL;
>  		mlog_errno(status);
>  		goto bail;
>  	}
> @@ -2485,8 +2515,9 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>  	}
>  
>  	inode = ocfs2_get_init_inode(dir, mode);
> -	if (!inode) {
> -		status = -ENOMEM;
> +	if (IS_ERR(inode)) {
> +		status = PTR_ERR(inode);
> +		inode = NULL;
>  		mlog_errno(status);
>  		goto leave;
>  	}
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index b69dd14c0b9b..7dc818b87cd8 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4419,8 +4419,9 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
>  	}
>  
>  	mutex_lock(&inode->i_mutex);
> -	dquot_initialize(dir);
> -	error = ocfs2_reflink(old_dentry, dir, new_dentry, preserve);
> +	error = dquot_initialize(dir);
> +	if (!error)
> +		error = ocfs2_reflink(old_dentry, dir, new_dentry, preserve);
>  	mutex_unlock(&inode->i_mutex);
>  	if (!error)
>  		fsnotify_create(dir, new_dentry);
> 

