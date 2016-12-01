From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: correctly detect when an xattr value has an
 invalid size
Date: Thu, 1 Dec 2016 15:00:09 -0500
Message-ID: <20161201200009.w34cs5n2zovzx4fx@thunk.org>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
 <1480228786-106775-3-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54906 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751997AbcLAUAL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 15:00:11 -0500
Content-Disposition: inline
In-Reply-To: <1480228786-106775-3-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:39:46PM -0800, Eric Biggers wrote:
> It was possible for an xattr value to have a very large size, which
> would then pass validation on 32-bit architectures due to a pointer
> wraparound.  Fix this by validating the size in a way which avoids
> pointer wraparound.
> 
> It was also possible that a value's size would fit in the available
> space but its padded size would not.  This would cause an out-of-bounds
> memory write in ext4_xattr_set_entry when replacing the xattr value.
> For example, if an xattr value of unpadded size 253 bytes went until the
> very end of the inode or block, then using setxattr(2) to replace this
> xattr's value with 256 bytes would cause a write to the 3 bytes past the
> end of the inode or buffer, and the new xattr value would be incorrectly
> truncated.  Fix this by requiring that the padded size fit in the
> available space rather than the unpadded size.
> 
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
