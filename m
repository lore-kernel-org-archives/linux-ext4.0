From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC: 2.6 patch] make the *FS_SECURITY options no longer user visible
Date: Mon, 30 Jul 2007 08:12:05 -0500
Message-ID: <20070730131205.GC3707@sergelap.austin.ibm.com>
References: <20070729150209.GS16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
	sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, jffs-dev@axis.com,
	xfs-masters@oss.sgi.com
To: Adrian Bunk <bunk@stusta.de>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070729150209.GS16817@stusta.de>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Quoting Adrian Bunk (bunk@stusta.de):
> Please correct me if any of the following assumptions is wrong:
> - SELinux is currently the only user of filesystem security labels
>   shipped with the Linux kernel
> - if a user has SELinux enabled he wants his filesystems to support
>   security labels
> 
> Based on these assumption, it doesn't make sense to have the
> *FS_SECURITY user visible since we can perfectly determine automatically 
> when turning them on makes sense.

I'm not very knowledgeable on the niftier kconfig features.  Is there a
way to introduce some intermediate SECURITY_XATTR variable, which
SECURITY_SELINUX could select, and which *_FS_SECURITY could depend on?

That way patches for file capabilities (in -mm) and smack (being
discussed on linux-security-module) won't have to explicitly add
themselves to every one of those 'depends on' lines.

thanks,
-serge

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  fs/Kconfig     |   82 +++++++++++++------------------------------------
>  fs/xfs/Kconfig |   13 +------
>  2 files changed, 25 insertions(+), 70 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/fs/Kconfig.old	2007-07-28 23:12:19.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/fs/Kconfig	2007-07-28 23:17:33.000000000 +0200
> @@ -40,16 +40,10 @@ config EXT2_FS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config EXT2_FS_SECURITY
> -	bool "Ext2 Security Labels"
> -	depends on EXT2_FS_XATTR
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the ext2 filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> +	bool
> +	depends on EXT2_FS && SECURITY_SELINUX
> +	select EXT2_FS_XATTR
> +	default y
> 
>  config EXT2_FS_XIP
>  	bool "Ext2 execute in place support"
> @@ -125,16 +119,10 @@ config EXT3_FS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config EXT3_FS_SECURITY
> -	bool "Ext3 Security Labels"
> -	depends on EXT3_FS_XATTR
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the ext3 filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> +	bool
> +	depends on EXT3_FS && SECURITY_SELINUX
> +	select EXT3_FS_XATTR
> +	default y
> 
>  config EXT4DEV_FS
>  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> @@ -190,16 +178,10 @@ config EXT4DEV_FS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config EXT4DEV_FS_SECURITY
> -	bool "Ext4dev Security Labels"
> -	depends on EXT4DEV_FS_XATTR
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the ext4dev/ext4 filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> +	bool
> +	depends on EXT4DEV_FS && SECURITY_SELINUX
> +	select EXT4DEV_FS_XATTR
> +	default y
> 
>  config JBD
>  	tristate
> @@ -349,16 +331,10 @@ config REISERFS_FS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config REISERFS_FS_SECURITY
> -	bool "ReiserFS Security Labels"
> -	depends on REISERFS_FS_XATTR
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the ReiserFS filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> +	bool
> +	depends on REISERFS_FS && SECURITY_SELINUX
> +	select REISERFS_FS_XATTR
> +	default y
> 
>  config JFS_FS
>  	tristate "JFS filesystem support"
> @@ -383,16 +359,9 @@ config JFS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config JFS_SECURITY
> -	bool "JFS Security Labels"
> -	depends on JFS_FS
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the jfs filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> +	bool
> +	depends on JFS_FS && SECURITY_SELINUX
> +	default y
> 
>  config JFS_DEBUG
>  	bool "JFS debugging"
> @@ -1300,17 +1269,10 @@ config JFFS2_FS_POSIX_ACL
>  	  If you don't know what Access Control Lists are, say N
> 
>  config JFFS2_FS_SECURITY
> -	bool "JFFS2 Security Labels"
> -	depends on JFFS2_FS_XATTR
> +	bool
> +	depends on JFFS2_FS && SECURITY_SELINUX
> +	select JFFS2_FS_XATTR
>  	default y
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute handler for file security
> -	  labels in the jffs2 filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for file security labels, say N.
> 
>  config JFFS2_COMPRESSION_OPTIONS
>  	bool "Advanced compression options for JFFS2"
> --- linux-2.6.23-rc1-mm1/fs/xfs/Kconfig.old	2007-07-28 23:19:13.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/fs/xfs/Kconfig	2007-07-28 23:19:49.000000000 +0200
> @@ -36,16 +36,9 @@ config XFS_QUOTA
>  	  they are completely independent subsystems.
> 
>  config XFS_SECURITY
> -	bool "XFS Security Label support"
> -	depends on XFS_FS
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute namespace for inode security
> -	  labels in the XFS filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for inode security labels, say N.
> +	bool
> +	depends on XFS_FS && SECURITY_SELINUX
> +	default y
> 
>  config XFS_POSIX_ACL
>  	bool "XFS POSIX ACL support"
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
