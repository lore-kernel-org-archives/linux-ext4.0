From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/34] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Sun, 21 Sep 2014 22:51:09 -0400
Message-ID: <20140922025109.GF30646@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221253.13646.7723.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40119 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaIVCvO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 22:51:14 -0400
Content-Disposition: inline
In-Reply-To: <20140913221253.13646.7723.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:12:53PM -0700, Darrick J. Wong wrote:
> +#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
> +		int flag = FALLOC_FL_ZERO_RANGE;
> +		struct stat statbuf;
> +
> +		/*
> +		 * If we're trying to zero a range past the end of the file,
> +		 * just use regular fallocate to get there, because zeroing
> +		 * a range past EOF does not extend the file.
> +		 */

If we are operating on a regular file (for example, "mkfs.ext4
/tmp/foo.img 64M") we want to keep the file a sparse one; so if we are
trying to zero a range past the end of the file, it should be
sufficient simply use trucate to set i_size.  In fact, if we can use
FALLOC_FL_PUNCH on the regular file, we should try to use that
instead, I would think.

					- Ted
