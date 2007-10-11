From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/2] Make ext3 use bit operations to manipulate i_flags
Date: Thu, 11 Oct 2007 14:08:32 -0600
Message-ID: <20071011200832.GU8122@schatzie.adilger.int>
References: <20071011175618.GF7125@duck.suse.cz> <20071011180111.GG7125@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:44944 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbXJKUIe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 16:08:34 -0400
Content-Disposition: inline
In-Reply-To: <20071011180111.GG7125@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2007  20:01 +0200, Jan Kara wrote:
>  #define EXT3_TOPDIR_FL			17 /* Top of directory hierarchies*/
> +#define EXT3_RTIME_FL			18 /* Update recursive mtime */

Could you please use "20" (0x100000) for this flag, as there were patches to
use 18 (0x40000) for EXT4_HUGE_FILE_FL, and 19 (0x80000) is definitely
reserved for EXT4_EXTENTS_FL.

I'd suggest emailing Ted to reserve a flag for this, and also adding the
other reserved flags to ext2 and ext3 so there is no risk of conflicts.

> @@ -572,6 +576,7 @@ static inline int ext3_valid_inum(struct
>  #define EXT3_FEATURE_COMPAT_EXT_ATTR		0x0008
>  #define EXT3_FEATURE_COMPAT_RESIZE_INODE	0x0010
>  #define EXT3_FEATURE_COMPAT_DIR_INDEX		0x0020
> +#define EXT3_FEATURE_COMPAT_RTIME		0x0040

Similarly, there is already
#define EXT2_FEATURE_COMPAT_LAZY_BG             0x0040

in e2fsprogs so you need to use 0x0080 for your feature.  Please update
all of the ext*_fs.h files to have the most recent flags from e2fsprogs
so that we can avoid such dangers in the future.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
