From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] blkid,ext2fs: avoid name clash with __u{8,16,32,64}
Date: Sat, 5 Jul 2014 00:00:41 -0400
Message-ID: <20140705040041.GH11103@thunk.org>
References: <1399584236-17686-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46333 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaGEEAp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 00:00:45 -0400
Content-Disposition: inline
In-Reply-To: <1399584236-17686-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 08, 2014 at 03:23:56PM -0600, Andreas Dilger wrote:
> Try to avoid name clashes with definitions of __u8, __u16, __u32,
> and __u64 in userspace, in case other headers also define these
> types.  Define HAVE___{S,U}{8,16,32,64} preprocessor macros to
> show that these types are already defined.
> 
> This would avoid the need to check for _BLKID_TYPES_H in ext2_types.h
> and _EXT2_TYPES_H in blkid_types.h, but since older versions of these
> headers did not use HAVE___U8 et.al. keep these checks around for now.
> 
> Report an error if there are no 64-bit types available.  The code
> will not compile if these are not available.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
