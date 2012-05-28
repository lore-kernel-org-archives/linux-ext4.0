From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: remove 64-bit wrappers from ext2fs.h (v2)
Date: Mon, 28 May 2012 10:56:21 -0400
Message-ID: <20120528145621.GF19152@thunk.org>
References: <1337984034-14756-1-git-send-email-adilger@whamcloud.com>
 <1337991801-29500-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45976 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1O4X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 10:56:23 -0400
Content-Disposition: inline
In-Reply-To: <1337991801-29500-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 25, 2012 at 06:23:21PM -0600, Andreas Dilger wrote:
> The creation of inline wrappers ext2fs_open() and ext2fs_stat()
> in commit c859cb1de0d624caa0779fb17d1a53766143136e in ext2fs.h
> caused difficulties with the use of headers, since the headers
> for open64() and stat64() may already be included (and skip the
> declaration of the 64-bit variants) before ext2fs.h is ever read.
> There is no real way to solve the missing prototypes and resulting
> compiler warnings inside ext2fs.h.
> 
> Since ext2fs_open() and ext2fs_stat() are not performance critical
> operations, they do not need to be inline functions at all, and
> the needed function headers can be handled properly in one file.
> 
> Similarly, posix_memalloc() was having difficulties with headers,
> and was being defined in ext2fs.h, but it is now only being used
> by a single file, so move the required header there.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied, with a lightly edited commit description.  This commit is now
entitled:

   libext2fs: don't inline ext2fs_open_file() and ext2fs_stat()

							- Ted
