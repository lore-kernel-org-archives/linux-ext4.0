From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][10/28] e2fsprogs-uninit.patch
Date: Sat, 15 Mar 2008 15:41:20 -0400
Message-ID: <20080315194120.GI27847@mit.edu>
References: <20080202075943.GB23836@webber.adilger.int> <20080202083444.GK31694@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58325 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752291AbYCOTlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 15:41:37 -0400
Content-Disposition: inline
In-Reply-To: <20080202083444.GK31694@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What is the intended use of the SF_DO_CSUM flag?  I see where it is
defined, and where it gets sets, but as far as I can tell nothing
actually tests for it or uses it.

	 				- Ted


On Sat, Feb 02, 2008 at 01:34:44AM -0700, Andreas Dilger wrote:
> Index: e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
>
> +#define EXT2_SF_DO_CSUM		0x0020
>

> Index: e2fsprogs-1.40.5/lib/ext2fs/inode.c
> ===================================================================
> --- e2fsprogs-1.40.5.orig/lib/ext2fs/inode.c
> +++ e2fsprogs-1.40.5/lib/ext2fs/inode.c
> @@ -167,6 +167,9 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
>  	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
>  				    EXT2_FEATURE_COMPAT_LAZY_BG))
>  		scan->scan_flags |= EXT2_SF_DO_LAZY;
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
> +		scan->scan_flags |= EXT2_SF_DO_LAZY | EXT2_SF_DO_CSUM;

