From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Thu, 5 May 2016 11:44:15 -0400
Message-ID: <20160505154415.GB10764@thunk.org>
References: <1462150237-20701-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Kitae Lee <kitae87.lee@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50282 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbcEEPoS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 11:44:18 -0400
Content-Disposition: inline
In-Reply-To: <1462150237-20701-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2016 at 09:50:37AM +0900, Daeho Jeong wrote:
> We check whether a new handle can be started through
> ext4_journal_check_start() and the function refuses to start the handle
> when the filesystem is mounted with read-only. But now, when we remount
> the filesystem with read-only option, already started handles are
> allowed to be written on disk, but the subsequent metadata modification
> using the handles are refused by ext4_journal_check_start().
> 
> As an example, in ext4_evict_inode(), i_size can be set to 0 using
> a successfully started handle, but, when we remount the filesystem
> with read-only option at that time, the subsequent ext4_truncate()
> will be failed and the filesystem integrity will be damaged.
> 
> Therefore, we need to permit the metadata modification using already
> started handles to be proceeded, even if s_flags of the filesystem is
> set to MS_RDONLY.
> 
> Kitae found the problem and suggested the solution.
> 
> Signed-off-by: Kitae Lee <kitae87.lee@samsung.com>
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>

Hmm, I'm not really comfortable with putting this hack in, since this
is papering over the real problem, which is that Android is trying to
use the emergency remount read-only sysrq option and this is
fundamentally unsafe.  I'm not sure what else could break if it is
situation normal that there is active processes busily writing to the
file system and sysrq-u followed by reboot is the normal way the
Android kernel does a reboot.

A much better solution would be to change the Android userspace to
call the FIFREEZE ioctl on each mounted file system, and then call for
a reboot.

					- Ted
