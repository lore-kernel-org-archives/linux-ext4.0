From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: forbid i_extra_isize not divisible by 4
Date: Thu, 1 Dec 2016 14:49:07 -0500
Message-ID: <20161201194907.wnu33j5at6l4m6vc@thunk.org>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54636 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932933AbcLATtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 14:49:16 -0500
Content-Disposition: inline
In-Reply-To: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:39:44PM -0800, Eric Biggers wrote:
> i_extra_isize not divisible by 4 is problematic for several reasons:
> 
> - It causes the in-inode xattr space to be misaligned, but the xattr
>   header and entries are not declared __packed to express this
>   possibility.  This may cause poor performance or incorrect code
>   generation on some platforms.
> - When validating the xattr entries we can read past the end of the
>   inode if the size available for xattrs is not a multiple of 4.
> - It allows the nonsensical i_extra_isize=1, which doesn't even leave
>   enough room for i_extra_isize itself.
> 
> Therefore, update ext4_iget() to consider i_extra_isize not divisible by
> 4 to be an error, like the case where i_extra_isize is too large.
> 
> This also matches the rule recently added to e2fsck for determining
> whether an inode has valid i_extra_isize.
> 
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems, since the size of ext4_inode
> has always been a multiple of 4.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
