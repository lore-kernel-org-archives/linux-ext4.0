From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] reiserfs: preserve i_mode if __reiserfs_set_acl()
 fails
Date: Mon, 17 Jul 2017 18:45:54 +0200
Message-ID: <20170717164554.GD22195@quack2.suse.cz>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <3ab632985cbf6fdd2ee5284482b9749c5893a5a1.1499805488.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54237 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751343AbdGQQqD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Jul 2017 12:46:03 -0400
Content-Disposition: inline
In-Reply-To: <3ab632985cbf6fdd2ee5284482b9749c5893a5a1.1499805488.git.ernesto.mnd.fernandez@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed 12-07-17 06:56:04, Ernesto A. Fernández wrote:
> When changing a file's acl mask, __reiserfs_set_acl() will first set the
> group bits of i_mode to the value of the mask, and only then set the
> actual extended attribute representing the new acl.
> 
> If the second part fails (due to lack of space, for example) and the file
> had no acl attribute to begin with, the system will from now on assume
> that the mask permission bits are actual group permission bits, potentially
> granting access to the wrong users.
> 
> Prevent this by only changing the inode mode after the acl has been set.
> Also make reiserfs_xattr_set_handle() return -ENODATA only in case of
> actual error, and return 0 when requested deletion of a nonexistent acl.
> This is more consistent with the behaviour of other *_xattr_set()
> functions and makes the patch simpler.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

Thanks for the patch!  I have rebased this onto my tree and merged the
resulting patch (attached).

								Honza

> ---
>  fs/reiserfs/xattr.c     |  4 ++++
>  fs/reiserfs/xattr_acl.c | 25 +++++++++----------------
>  2 files changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
> index e87aa21..936a57a 100644
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -513,6 +513,10 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
>  
>  	if (!buffer) {
>  		err = lookup_and_delete_xattr(inode, name);
> +		if (flags & XATTR_REPLACE)
> +			return err;
> +		if (err == -ENODATA)
> +			err = 0;
>  		return err;
>  	}
>  
> diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
> index 3d2256a..c02e5ac 100644
> --- a/fs/reiserfs/xattr_acl.c
> +++ b/fs/reiserfs/xattr_acl.c
> @@ -237,14 +237,17 @@ __reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
>  	void *value = NULL;
>  	size_t size = 0;
>  	int error;
> +	int update_mode = 0;
> +	umode_t mode = inode->i_mode;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
>  		name = XATTR_NAME_POSIX_ACL_ACCESS;
>  		if (acl) {
> -			error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> +			error = posix_acl_update_mode(inode, &mode, &acl);
>  			if (error)
>  				return error;
> +			update_mode = 1;
>  		}
>  		break;
>  	case ACL_TYPE_DEFAULT:
> @@ -264,25 +267,15 @@ __reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
>  
>  	error = reiserfs_xattr_set_handle(th, inode, name, value, size, 0);
>  
> -	/*
> -	 * Ensure that the inode gets dirtied if we're only using
> -	 * the mode bits and an old ACL didn't exist. We don't need
> -	 * to check if the inode is hashed here since we won't get
> -	 * called by reiserfs_inherit_default_acl().
> -	 */
> -	if (error == -ENODATA) {
> -		error = 0;
> -		if (type == ACL_TYPE_ACCESS) {
> +	kfree(value);
> +	if (!error) {
> +		set_cached_acl(inode, type, acl);
> +		if (update_mode) {
> +			inode->i_mode = mode;
>  			inode->i_ctime = current_time(inode);
>  			mark_inode_dirty(inode);
>  		}
>  	}
> -
> -	kfree(value);
> -
> -	if (!error)
> -		set_cached_acl(inode, type, acl);
> -
>  	return error;
>  }
>  
> -- 
> 2.1.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--jI8keyz6grp/JLjh
Content-Type: text/x-patch; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-reiserfs-preserve-i_mode-if-__reiserfs_set_acl-fails.patch"
Content-Transfer-Encoding: 8bit

>From 71edef97f294dbff5d84bca5721c7b30273a0786 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?=
 <ernesto.mnd.fernandez@gmail.com>
Date: Mon, 17 Jul 2017 18:42:41 +0200
Subject: [PATCH] reiserfs: preserve i_mode if __reiserfs_set_acl() fails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When changing a file's acl mask, reiserfs_set_acl() will first set the
group bits of i_mode to the value of the mask, and only then set the
actual extended attribute representing the new acl.

If the second part fails (due to lack of space, for example) and the
file had no acl attribute to begin with, the system will from now on
assume that the mask permission bits are actual group permission bits,
potentially granting access to the wrong users.

Prevent this by only changing the inode mode after the acl has been set.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/xattr_acl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index d92a1dc6ee70..54415f0e3d18 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -23,7 +23,8 @@ reiserfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	struct reiserfs_transaction_handle th;
 	size_t jcreate_blocks;
 	int size = acl ? posix_acl_xattr_size(acl->a_count) : 0;
--jI8keyz6grp/JLjh--
