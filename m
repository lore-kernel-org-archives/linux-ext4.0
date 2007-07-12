From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Wed, 11 Jul 2007 23:15:57 -0600
Message-ID: <20070712051557.GC5586@schatzie.adilger.int>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <20070710145855.GB27033@thunk.org> <20070711094410.GM6417@schatzie.adilger.int> <20070711174347.GD19456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:45232 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXGLFQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 01:16:03 -0400
Content-Disposition: inline
In-Reply-To: <20070711174347.GD19456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 11, 2007  13:43 -0400, Theodore Tso wrote:
>     Fix e2fsck segfault on very badly damaged filesystems
>     
> --- a/e2fsck/dirinfo.c
> +++ b/e2fsck/dirinfo.c
> @@ -126,7 +126,7 @@ void e2fsck_add_dir_info(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
>  		ctx->dir_info->size += 10;
>  		retval = ext2fs_resize_mem(old_size, ctx->dir_info->size *
>  					   sizeof(struct dir_info),
> -					   &ctx->dir_info);
> +					   &ctx->dir_info->array);
>  		if (retval) {
>  			ctx->dir_info->size -= 10;
>  			return;

This appears to fix the problem.  I was previously able to crash e2fsck
within a couple of runs, now it is running in a loop w/o problems.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
