From: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH 0/4] fscrypt: remove checks for encryption key after file
 open
Date: Tue, 23 May 2017 07:56:25 +0200
Message-ID: <DA1CA888-856E-44A7-ABED-90F39D14C720@sigma-star.at>
References: <20170523003945.14279-1-ebiggers3@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbdEWF42 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 01:56:28 -0400
In-Reply-To: <20170523003945.14279-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric,

> On 23 May 2017, at 02:39, Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> From: Eric Biggers <ebiggers@google.com>
> 
> This series removes checks for a regular file's encryption key that occur
> after we've already opened the file.  We're guaranteed to already have
> the key in such places, since we require it in ->open().  open() fails
> with ENOKEY otherwise, and a file descriptor is never made available.
> 
> This pertains to regular files only.  (Directories can be opened with or
> without their key.)
> 
> Eric Biggers (4):
>  ext4: don't bother checking for encryption key in ->mmap()
>  f2fs: don't bother checking for encryption key in ->mmap()
>  ubifs: don't bother checking for encryption key in ->mmap()
>  f2fs: don't bother checking for encryption key in ->write_iter()
> 
> fs/ext4/file.c  |  7 -------
> fs/f2fs/file.c  | 13 -------------
> fs/ubifs/file.c |  9 ---------
> 3 files changed, 29 deletions(-)

The whole series looks good to me. So feel free to add my
Reviewed-by: David Gstir <david@sigma-star.at>

David
