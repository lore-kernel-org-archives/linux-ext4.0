From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix quota accounting to use cluster units
Date: Thu, 13 Apr 2017 11:47:47 -0400
Message-ID: <20170413154747.vb473ynqri2nevjm@thunk.org>
References: <20170402165705.GA8705@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34232 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdDMPrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Apr 2017 11:47:49 -0400
Content-Disposition: inline
In-Reply-To: <20170402165705.GA8705@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 02, 2017 at 12:57:05PM -0400, Eric Whitney wrote:
> The quota accounting code in e2fsck's pass 1 and pass 3 uses block units
> rather than cluster units when recording the allocated space consumed by
> files and directories.  In pass 1, this causes a large undercount of
> actual quota results and test failures for xfstests generic/383, /384,
> /385, and /386 on bigalloc file systems.  In pass 3, this results in
> quota accounting errors when the lost+found directory is either extended
> or recreated on a bigalloc file system.
> 
> Use clusters rather than blocks when accounting for allocated space,
> and correct a related header comment in the quota code.
> 
> Note that pass 1b also contains call sites for quota_data_sub() that
> also need to be addressed.  However, it appears that more than just
> unit conversion may be needed, so that will be left to a future patch.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
