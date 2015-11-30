From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: fix block-mapped file punch
Date: Mon, 30 Nov 2015 15:28:04 -0500
Message-ID: <20151130202804.GG4316@thunk.org>
References: <1447920799-12834-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58305 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbbK3U2J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 15:28:09 -0500
Content-Disposition: inline
In-Reply-To: <1447920799-12834-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 19, 2015 at 01:13:18AM -0700, Andreas Dilger wrote:
> If ext2fs_punch() was called with "end = ~0ULL" to indicate truncate
> to the end of file it tried to compute "count" for ext2fs_punch_ind()
> based on "start" and "end", but incorrectly passed "count = ~0U" even
> when "start" was non-zero, causing an overflow in some cases.
> 
> The calling convention for ext2fs_punch_ind() was also gratuitously
> different from ext2fs_punch() and ext2fs_punch_extent(), passing
> "count" instead of "end" as the last parameter.  Fix this by passing
> it "end" like the other functions, and handle "count" internally.
> 
> Add checks to ext2fs_punch_ind() if "end" is at or beyond the 2^32
> indirect block limit so the 32-bit internal variables don't overflow.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

					- Ted
