From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
 filesystem
Date: Fri, 22 Jun 2012 01:51:46 +0200
Message-ID: <20120621235146.GC11645@quack.suse.cz>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760662Ab2FUXvs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 19:51:48 -0400
Content-Disposition: inline
In-Reply-To: <1340269733-25922-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 21-06-12 13:08:51, Dmitry Monakhov wrote:
> * Abstract
>   A subtree of a directory tree T is a tree consisting of a directory
>   (the subtree root) in T and all of its descendants in T.
> 
>   *NOTE*: User is allowed to break pure subtree hierarchy via manual
>           id manipulation.
> 
>   Project subtrees assumptions:
>   (1) Each inode has an id. This id is persistently stored inside
>       inode (xattr, usually inside ibody)
>   (2) Project id is inherent from parent directory
> 
>   This feature is similar to project-id in XFS. One may assign some id to
>   a subtree. Each entry from the subtree may be accounted in directory
>   project quota. Will appear in later patches.
> 
> * Disk layout
>   Project id is stored on disk inside xattr usually inside ibody.
>   Xattr is used only as a data storage, It has not user visible xattr
>   interface.
> 
> * User interface
>   Project id is accessible via generic xattr interface "system.project_id"
> 
> * Notes
>   ext4_setattr interface to prjid: Semantically prjid must being changed
>   similar to uid/gid, but project_id is stored inside xattr so on-disk
>   structures updates is not that trivial, so I've move prjid change
>   logic to separate function.
  Generally, I like the patch. Some comments are below.

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/Kconfig   |    8 ++
>  fs/ext4/Makefile  |    1 +
>  fs/ext4/ext4.h    |    4 +
>  fs/ext4/ialloc.c  |    6 ++
>  fs/ext4/inode.c   |    4 +
>  fs/ext4/project.c |  213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/project.h |   45 +++++++++++
>  fs/ext4/super.c   |   16 ++++
>  fs/ext4/xattr.c   |    7 ++
>  fs/ext4/xattr.h   |    2 +
>  10 files changed, 306 insertions(+), 0 deletions(-)
>  create mode 100644 fs/ext4/project.c
>  create mode 100644 fs/ext4/project.h
> 
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index c22f170..377af40 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -76,6 +76,14 @@ config EXT4_FS_SECURITY
>  
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
> +config EXT4_PROJECT_ID
> +	bool "Ext4 project_id support"
> +	depends on PROJECT_ID
> +	depends on EXT4_FS_XATTR
> +	help
> +	  Enables project inode identifier support for ext4 filesystem.
> +	  This feature allow to assign some id to inodes similar to
> +	  uid/gid. 
  Is separate config option useful? The amount of code added for this is
not really big and there is not other speed / space benefit in disabling
this, is there?

>  config EXT4_DEBUG
>  	bool "EXT4 debugging support"
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index 56fd8f8..692fe56 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -12,3 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
>  ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
>  ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
>  ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
> +ext4-$(CONFIG_EXT4_PROJECT_ID)		+= project.o
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cfc4e01..c0e33d7 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -925,6 +925,9 @@ struct ext4_inode_info {
>  
>  	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
>  	__u32 i_csum_seed;
> +#ifdef CONFIG_EXT4_PROJECT_ID
> +	__u32 i_prjid;
> +#endif
>  };
>  
>  /*
> @@ -962,6 +965,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
>  #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
>  #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
> +#define EXT4_MOUNT_PROJECT_ID		0x40000 /* project owner id support */
  And I would even question the necessity of the mount option. Can we make
the rule that no system.prjid xattr simply means prjid == 0. When someone
sets prjid, it gets further automatically inherited and everything works
fine. I don't see the need for special mount option for this - again no
significant overhead is introduced when we always check whether we should
inherit non-zero prjid... Thoughts?

>  #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
>  #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
>  #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index d48e8b1..d4b72e5 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -28,6 +28,7 @@
>  #include "ext4_jbd2.h"
>  #include "xattr.h"
>  #include "acl.h"
> +#include "project.h"
>  
>  #include <trace/events/ext4.h>
>  
> @@ -898,6 +899,8 @@ got:
>  
>  	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
>  
> +	ext4_setprjid(inode, ext4_getprjid(dir));
> +
>  	ret = inode;
>  	dquot_initialize(inode);
>  	err = dquot_alloc_inode(inode);
> @@ -911,6 +914,9 @@ got:
>  	err = ext4_init_security(handle, inode, dir, qstr);
>  	if (err)
>  		goto fail_free_drop;
> +	err = ext4_prj_init(handle, inode);
> +	if (err)
> +		goto fail_free_drop;
>  
>  	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
>  		/* set extent flag only for directory, file and normal symlink*/
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 02bc8cb..c98d8d6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -42,6 +42,7 @@
>  #include "xattr.h"
>  #include "acl.h"
>  #include "truncate.h"
> +#include "project.h"
>  
>  #include <trace/events/ext4.h>
>  
> @@ -3870,6 +3871,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	}
>  	if (ret)
>  		goto bad_inode;
> +	ret = ext4_prj_read(inode);
> +	if (ret)
> +		goto bad_inode;
>  
>  	if (S_ISREG(inode->i_mode)) {
>  		inode->i_op = &ext4_file_inode_operations;
> diff --git a/fs/ext4/project.c b/fs/ext4/project.c
> new file mode 100644
> index 0000000..a262a49
> --- /dev/null
> +++ b/fs/ext4/project.c
> @@ -0,0 +1,213 @@
> +/*
> + * linux/fs/ext4/projectid.c
> + *
> + * Copyright (C) 2010 Parallels Inc
> + * Dmitry Monakhov <dmonakhov@openvz.org>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/capability.h>
> +#include <linux/fs.h>
> +#include <linux/quotaops.h>
> +#include "ext4_jbd2.h"
> +#include "ext4.h"
> +#include "xattr.h"
> +#include "project.h"
> +
> +
> +/*
> + * PROJECT SUBTREE
> + * A subtree of a directory tree T is a tree consisting of a directory
> + * (the subtree root) in T and all of its descendants in T.
> + *
> + * Project Subtree's assumptions:
> + * (1) Each inode has subtree id. This id is persistently stored inside
> + *     inode's xattr, usually inside ibody
> + * (2) Subtree id is inherent from parent directory
> + */
> +
> +/*
> + * Read project_id id from inode's xattr
> + * Locking: none
> + */
> +int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid)
> +{
> +	__le32 dsk_prjid;
> +	int retval;
  Please add empty line between declarations and function body... Also
holds for some functions below.

> +	retval = ext4_xattr_get(inode, EXT4_XATTR_INDEX_PROJECT_ID, "",
> +				&dsk_prjid, sizeof (dsk_prjid));
> +	if (retval > 0) {
> +		if (retval != sizeof(dsk_prjid))
> +			return -EIO;
> +		else
> +			retval = 0;
> +	}
> +	*prjid = le32_to_cpu(dsk_prjid);
> +	return retval;
> +
> +}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
