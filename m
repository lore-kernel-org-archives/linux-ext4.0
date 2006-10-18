From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH, E2FSPROGS] On-disk format for large number of subdirectors
Date: Wed, 18 Oct 2006 13:29:28 -0600
Message-ID: <20061018192928.GF3509@schatzie.adilger.int>
References: <E1Ga4qP-0004wH-85@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58345 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161298AbWJRT33
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 15:29:29 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <E1Ga4qP-0004wH-85@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  02:24 -0400, Theodore Ts'o wrote:
> On-disk format for large number of subdirectories
> 
> - EXT4_FEATURE_RO_COMPAT_DIR_NLINK (0x0020?) - allow directories to have
>   > 65000 subdirectories (i_nlinks) by setting i_nlinks = 1 for such
>   directories.  RO_COMPAT protects old filesystems from unlinking such
>   directories incorrectly and losing all files therein.  
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Looks good.  Will try to get a new patch out with this support.

> Index: e2fsprogs/lib/ext2fs/ext2_fs.h
> ===================================================================
> --- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 01:42:48.000000000 -0400
> +++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 01:49:51.000000000 -0400
> @@ -71,7 +71,7 @@
>  /*
>   * Maximal count of links to a file
>   */
> -#define EXT2_LINK_MAX		32000
> +#define EXT2_LINK_MAX		65000
>  
>  /*
>   * Macro-instructions used to manage several block sizes
> @@ -606,6 +606,7 @@
>  /* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004 not used */
>  #define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
>  #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
> +#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>  
>  #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
>  #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
