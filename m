From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: disable pwsalt ioctl when encryption disabled by
 config
Date: Thu, 1 Dec 2016 11:56:55 -0500
Message-ID: <20161201165655.w56cyzojmuvoinnx@thunk.org>
References: <1479774192-11528-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50808 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755290AbcLAQ5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 11:57:49 -0500
Content-Disposition: inline
In-Reply-To: <1479774192-11528-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 04:23:12PM -0800, Eric Biggers wrote:
> On a CONFIG_EXT4_FS_ENCRYPTION=n kernel, the ioctls to get and set
> encryption policies were disabled but EXT4_IOC_GET_ENCRYPTION_PWSALT was
> not.  But there's no good reason to expose the pwsalt ioctl if the
> kernel doesn't support encryption.  The pwsalt ioctl was also disabled
> pre-4.8 (via ext4_sb_has_crypto() previously returning 0 when encryption
> was disabled by config) and seems to have been enabled by mistake when
> ext4 encryption was refactored to use fs/crypto/.  So let's disable it
> again.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
