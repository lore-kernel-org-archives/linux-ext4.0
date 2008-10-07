From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH, RFC] ext4: Rename ext4dev to ext4
Date: Tue, 07 Oct 2008 13:16:56 +0800
Message-ID: <48EAF0C8.9060104@cn.fujitsu.com>
References: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYJGFRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 01:17:19 -0400
In-Reply-To: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> diff --git a/fs/Kconfig b/fs/Kconfig
> index abccb5d..afb14f2 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -136,37 +136,37 @@ config EXT3_FS_SECURITY
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
>  
> -config EXT4DEV_FS
> -	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +config EXT4_FS
> +	tristate "The Extended 4 (ext4) filesystem"
>  	select JBD2
>  	select CRC16
>  	help
> -	  Ext4dev is a predecessor filesystem of the next generation
> -	  extended fs ext4, based on ext3 filesystem code. It will be
> -	  renamed ext4 fs later, once ext4dev is mature and stabilized.
> +	  This is the next generation of the ext3 filesystem.
>  
>  	  Unlike the change from ext2 filesystem to ext3 filesystem,
> -	  the on-disk format of ext4dev is not the same as ext3 any more:
> -	  it is based on extent maps and it supports 48-bit physical block
> -	  numbers. These combined on-disk format changes will allow
> -	  ext4dev/ext4 to handle more than 16 TB filesystem volumes --
> -	  a hard limit that ext3 cannot overcome without changing the
> -	  on-disk format.
> -
> -	  Other than extent maps and 48-bit block numbers, ext4dev also is
> -	  likely to have other new features such as persistent preallocation,
> -	  high resolution time stamps, and larger file support etc.  These
> -	  features will be added to ext4dev gradually.
> +	  the on-disk format of ext4 is not backwardscompatible with

s/backwardscompatible/backwards compatible

> +	  ext3; it is based on extent maps and it supports 48-bit
> +	  physical block numbers.  The ext4 filesystem also supports delayed
> +	  allocation, persistent preallocation, high resolution time stamps,
> +	  and a number of other features to improve performance and speed
> +	  up fsck time.  For more information, please see the web pages at
> +	  http://ext4.wiki.kernel.org.
> +
> +	  The ext4 filesystem will support mounting an ext3
> +	  filesystem; while there will be some performance gains from
> +	  the delayed allocation and inode table readeahad, the best

s/readeahad/readahead

> +	  performance gains will require enabling ext4 features in the
> +	  filesystem, or formating a new filesystem as an ext4
> +	  filesystem initially.
>  
>  	  To compile this file system support as a module, choose M here. The
>  	  module will be called ext4dev.
>  
>  	  If unsure, say N.

...

> diff --git a/fs/Makefile b/fs/Makefile
> index a1482a5..de404b0 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -69,7 +69,7 @@ obj-$(CONFIG_DLM)		+= dlm/
>  # Do not add any filesystems before this line
>  obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
>  obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
> -obj-$(CONFIG_EXT4DEV_FS)	+= ext4/ # Before ext2 so root fs can be ext4dev
> +obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4dev

the tailing word is still ext4dev

>  obj-$(CONFIG_JBD)		+= jbd/
>  obj-$(CONFIG_JBD2)		+= jbd2/
>  obj-$(CONFIG_EXT2_FS)		+= ext2/
