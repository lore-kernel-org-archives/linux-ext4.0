From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [2/6] e2fsprogs: Add CHANNEL_FLAGS_DISCARD_ZEROES flag for
 io_manager
Date: Tue, 23 Nov 2010 09:55:06 -0500
Message-ID: <20101123145506.GB32759@thunk.org>
References: <1290087521-9123-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52346 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab0KWPSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:53 -0500
Content-Disposition: inline
In-Reply-To: <1290087521-9123-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 03:38:37AM -0000, Lukas Czerner wrote:
> When the device have discard support and simultaneously discard zeroes
> data (and it is properly advertised), then we can take advantage of such
> behavior in several e2fsprogs tools.
> 
> Add new flag CHANNEL_FLAGS_DISCARD_ZEROES for struct_io_channel so
> each io_manager can take advantage of this. The flag is properly set
> according to BLKDISCARDZEROES ioctl in unix_open.
> 
> Also remove old mke2fs_discard_zeroes_data() function and substitute it
> with helper which test this flag.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I merged this patch with a minor change; I renamed
ext2fs_discard_zeroes_data() to io_channel_discard_zeros_data().

								- Ted
