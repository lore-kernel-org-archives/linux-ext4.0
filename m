From: tytso@mit.edu
Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the preallocation
Date: Sun, 16 Mar 2014 23:02:01 -0400
Message-ID: <20140317030201.GE14162@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <1393355679-11160-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42323 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbaCQDCK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 23:02:10 -0400
Content-Disposition: inline
In-Reply-To: <1393355679-11160-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:14:34PM +0100, Lukas Czerner wrote:
> Currently in ext4_fallocate we would update inode size, c_time and sync
> the file with every partial allocation which is entirely unnecessary. It
> is true that if the crash happens in the middle of truncate we might end
> up with unchanged i size, or c_time which I do not think is really a
> problem - it does not mean file system corruption in any way. Note that
> xfs is doing things the same way e.g. update all of the mentioned after
> the allocation is done.
> 
> This commit moves all the updates after the allocation is done. In
> addition we also need to change m_time as not only inode has been change
> bot also data regions might have changed (unwritten extents). However
> m_time will be only updated when i_size changed.
> 
> Also we do not need to be paranoid about changing the c_time only if the
> actual allocation have happened, we can change it even if we try to
> allocate only to find out that there are already block allocated. It's
> not really a big deal and it will save us some additional complexity.
> 
> Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
> section.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Further testing has shown that this patch (applied on top of the ext4
dev branch) is causing a regression failure of xfstests shared/243.

Could you take a look?

						- Ted
