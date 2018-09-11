From: Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v3 2/2] f2fs: fix setattr project check upon
 fssetxattr ioctl
Date: Wed, 12 Sep 2018 00:27:36 +0800
Message-ID: <82357beb-e079-816a-e0e4-efc859435bdc@kernel.org>
References: <1536623661-5912-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, wshilong@ddn.com, dchinner@redhat.com
To: Wang Shilong <wangshilong1991@gmail.com>, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1536623661-5912-1-git-send-email-wshilong1991@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On 2018/9/11 7:54, Wang Shilong wrote:
> From: Wang Shilong <wangshilong1991@gmail.com>
> 
> Currently, project quota could be changed by fssetxattr
> ioctl, and existed permission check inode_owner_or_capable()
> is obviously not enough, just think that common users could
> change project id of file, that could make users to
> break project quota easily.
> 
> This patch try to follow same regular of xfs project
> quota:
> 
> "Project Quota ID state is only allowed to change from
> within the init namespace. Enforce that restriction only
> if we are trying to change the quota ID state.
> Everything else is allowed in user namespaces."
> 
> Besides that, check and set project id'state should
> be an atomic operation, protect whole operation with
> inode lock.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
> v2->v3: remove inode_lock() and mnt_want_write_file()
> inside f2fs_ioc_setproject()

I missed to check that, my bad.

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,

> v1->v2: rename f2fs_ioctl_setattr_check_projid()
> to f2fs_ioctl_check_project()
>  fs/f2fs/file.c | 61 ++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 5474aaa..f5170e6 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -2617,34 +2617,26 @@ static int f2fs_ioc_setproject(struct file *filp, __u32 projid)
>  	if (projid_eq(kprojid, F2FS_I(inode)->i_projid))
>  		return 0;
>  
> -	err = mnt_want_write_file(filp);
> -	if (err)
> -		return err;
> -
>  	err = -EPERM;
> -	inode_lock(inode);
> -
>  	/* Is it quota file? Do not allow user to mess with it */
>  	if (IS_NOQUOTA(inode))
> -		goto out_unlock;
> +		return err;
>  
>  	ipage = f2fs_get_node_page(sbi, inode->i_ino);
> -	if (IS_ERR(ipage)) {
> -		err = PTR_ERR(ipage);
> -		goto out_unlock;
> -	}
> +	if (IS_ERR(ipage))
> +		return PTR_ERR(ipage);
>  
>  	if (!F2FS_FITS_IN_INODE(F2FS_INODE(ipage), fi->i_extra_isize,
>  								i_projid)) {
>  		err = -EOVERFLOW;
>  		f2fs_put_page(ipage, 1);
> -		goto out_unlock;
> +		return err;
>  	}
>  	f2fs_put_page(ipage, 1);
>  
>  	err = dquot_initialize(inode);
>  	if (err)
> -		goto out_unlock;
> +		return err;
>  
>  	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
>  	if (!IS_ERR(transfer_to[PRJQUOTA])) {
> @@ -2658,9 +2650,6 @@ static int f2fs_ioc_setproject(struct file *filp, __u32 projid)
>  	inode->i_ctime = current_time(inode);
>  out_dirty:
>  	f2fs_mark_inode_dirty_sync(inode, true);
> -out_unlock:
> -	inode_unlock(inode);
> -	mnt_drop_write_file(filp);
>  	return err;
>  }
>  #else
> @@ -2736,6 +2725,31 @@ static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
>  	return 0;
>  }
>  
> +static int
> +f2fs_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
> +{
> +	/*
> +	 * Project Quota ID state is only allowed to change from within the init
> +	 * namespace. Enforce that restriction only if we are trying to change
> +	 * the quota ID state. Everything else is allowed in user namespaces.
> +	 */
> +	if (current_user_ns() == &init_user_ns)
> +		return 0;
> +
> +	if (__kprojid_val(F2FS_I(inode)->i_projid) != fa->fsx_projid)
> +		return -EINVAL;
> +
> +	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
> +		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
> +			return -EINVAL;
> +	} else {
> +		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> @@ -2763,19 +2777,20 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
>  		return err;
>  
>  	inode_lock(inode);
> +	err = f2fs_ioctl_check_project(inode, &fa);
> +	if (err)
> +		goto out;
>  	flags = (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
>  				(flags & F2FS_FL_XFLAG_VISIBLE);
>  	err = __f2fs_ioc_setflags(inode, flags);
> -	inode_unlock(inode);
> -	mnt_drop_write_file(filp);
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	err = f2fs_ioc_setproject(filp, fa.fsx_projid);
> -	if (err)
> -		return err;
> -
> -	return 0;
> +out:
> +	inode_unlock(inode);
> +	mnt_drop_write_file(filp);
> +	return err;
>  }
>  
>  int f2fs_pin_file_control(struct inode *inode, bool inc)
> 
