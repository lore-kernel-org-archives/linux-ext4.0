From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/2] e2fsprogs: allow more than 32000 subdirectories
Date: Wed, 21 Mar 2007 22:00:16 -0600
Message-ID: <20070322040016.GK5967@schatzie.adilger.int>
References: <1174486353.11843.12.camel@garfield> <20070321200208.GG5967@schatzie.adilger.int> <1174512908.3080.1.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:37035 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965671AbXCVEAT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2007 00:00:19 -0400
Content-Disposition: inline
In-Reply-To: <1174512908.3080.1.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 21, 2007  19:42 +0530, Kalpak Shah wrote:
> Index: e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
> ===================================================================
> --- e2fsprogs-1.40.orig/lib/ext2fs/ext2_fs.h
> +++ e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
> @@ -635,6 +635,7 @@ struct ext2_super_block {
>  #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
>  #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>  					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
> +					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
>  					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
>  
>  /*
> Index: e2fsprogs-1.40/lib/ext2fs/ext2fs.h
> ===================================================================
> --- e2fsprogs-1.40.orig/lib/ext2fs/ext2fs.h
> +++ e2fsprogs-1.40/lib/ext2fs/ext2fs.h
> @@ -460,7 +463,8 @@ typedef struct ext2_icount *ext2_icount_
>  					 EXT3_FEATURE_INCOMPAT_RECOVER)
>  #endif
>  #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
> -					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
> +					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
> +					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)

Ted, can you give a bit of clarification for these different masks.
For EXT2_LIB_SOFTSUPP_RO_COMPAT, it says "These features are only allowed
if EXT2_FLAG_SOFTSUPP_FEATURES is passed to ext2fs_openfs()".  If the patch
from Kalpak adds DIR_NLINK to EXT2_LIB_FEATURE_RO_COMPAT_SUPP, does that
mean we should remove it from EXT2_FLAG_SOFTSUPP_FEATURES?

Also, I notice in ext2fs_open2() that there is a bit of code:

#ifdef EXT2_LIB_SOFTSUPP_RO_COMPAT
	if (flags & EXT2_FLAG_SOFTSUPP_FEATURES)
		features &= !EXT2_LIB_SOFTSUPP_RO_COMPAT;
#endif

But what does "!EXT2_LIB_SOFTSUPP_RO_COMPAT" really mean?  Should this be
~EXT2_LIB_SOFTSUPP_RO_COMPAT?  Should it be instead:

     features &= ~(EXT2_LIB_SOFTSUPP_RO_COMPAT|EXT2_LIB_FEATURE_RO_COMPAT_SUPP)
     
so that we don't mask out all of the features that are NOT in
SOFTSUPP_RO_COMPAT?  Otherwise we've just broken e2fsprogs feature compat
support badly I think.  A similar hunk exists for EXT2_LIB_SOFTSUPP_INCOMPAT.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
