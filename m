From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create
 permission flags
Date: Fri, 24 Sep 2010 11:54:23 -0400
Message-ID: <20100924115423.530813c3@tlielax.poochiereds.net>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0IXPye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Sep 2010 11:54:34 -0400
In-Reply-To: <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Sep 2010 18:18:11 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: Andreas Gruenbacher <agruen@suse.de>
> 
> Some permission models distinguish between the permission to create a
> non-directory and a directory.  Pass this information down to
> inode_permission() as mask flags
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c         |   21 ++++++++++++---------
>  include/linux/fs.h |    2 ++
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b0b8a71..ed786b2 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -253,7 +253,8 @@ int generic_permission(struct inode *inode, int mask,
>   * for filesystem access without changing the "normal" uids which
>   * are used for other things.
>   *
> - * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
> + * When checking for MAY_APPEND, MAY_CREATE_FILE, MAY_CREATE_DIR,
> + * MAY_WRITE must also be set in @mask.
>   */
>  int inode_permission(struct inode *inode, int mask)
>  {
> @@ -1337,13 +1338,15 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
>   *  3. We should have write and exec permissions on dir
>   *  4. We can't do it if dir is immutable (done in permission())
>   */
> -static inline int may_create(struct inode *dir, struct dentry *child)
> +static inline int may_create(struct inode *dir, struct dentry *child, int isdir)
									^^^^^
								nit: maybe saner as a bool?
>  {
> +	int mask = isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
>  	if (child->d_inode)
>  		return -EEXIST;
>  	if (IS_DEADDIR(dir))
>  		return -ENOENT;
> -	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
>  }
>  
>  /*
> @@ -1391,7 +1394,7 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
>  int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
>  		struct nameidata *nd)
>  {
> -	int error = may_create(dir, dentry);
> +	int error = may_create(dir, dentry, 0);
>  
>  	if (error)
>  		return error;
> @@ -1953,7 +1956,7 @@ EXPORT_SYMBOL_GPL(lookup_create);
>  
>  int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
>  {
> -	int error = may_create(dir, dentry);
> +	int error = may_create(dir, dentry, 0);
>  
>  	if (error)
>  		return error;
> @@ -2057,7 +2060,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
>  
>  int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  {
> -	int error = may_create(dir, dentry);
> +	int error = may_create(dir, dentry, 1);
>  
>  	if (error)
>  		return error;
> @@ -2342,7 +2345,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
>  
>  int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
>  {
> -	int error = may_create(dir, dentry);
> +	int error = may_create(dir, dentry, 0);
>  
>  	if (error)
>  		return error;
> @@ -2415,7 +2418,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>  	if (!inode)
>  		return -ENOENT;
>  
> -	error = may_create(dir, new_dentry);
> +	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));

						^^^^ this is a little
						scary, but even if it's
						a directory, it'll get
						kicked out in a later
						check. Would it be
						clearer to move up the
						S_ISDIR() check in this
						function and then pass
						this in as false?

>  	if (error)
>  		return error;
>  
> @@ -2631,7 +2634,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		return error;
>  
>  	if (!new_dentry->d_inode)
> -		error = may_create(new_dir, new_dentry);
> +		error = may_create(new_dir, new_dentry, is_dir);
>  	else
>  		error = may_delete(new_dir, new_dentry, is_dir);
>  	if (error)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 26fc8ae..5dc1ebd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -55,6 +55,8 @@ struct inodes_stat_t {
>  #define MAY_ACCESS 16
>  #define MAY_OPEN 32
>  #define MAY_CHDIR 64
> +#define MAY_CREATE_FILE 128
> +#define MAY_CREATE_DIR 256
>  
>  /*
>   * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond


-- 
Jeff Layton <jlayton@redhat.com>
