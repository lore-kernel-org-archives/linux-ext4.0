From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4, jbd2: ensure entering into panic after
 recording an error in superblock
Date: Sun, 18 Oct 2015 19:38:04 -0400
Message-ID: <20151018233804.GO2678@thunk.org>
References: <1444616359-21149-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57952 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbbJRXiI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2015 19:38:08 -0400
Content-Disposition: inline
In-Reply-To: <1444616359-21149-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 11:19:19AM +0900, Daeho Jeong wrote:
> If a EXT4 filesystem utilizes JBD2 journaling and an error occurs, the
> journaling will be aborted first and the error number will be recorded
> into JBD2 superblock and, finally, the system will enter into the
> panic state in "errors=panic" option.  But, in the rare case, this
> sequence is little twisted like the below figure and it will happen
> that the system enters into panic state, which means the system reset
> in mobile environment, before completion of recording an error in the
> journal superblock. In this case, e2fsck cannot recognize that the
> filesystem failure occurred in the previous run and the corruption
> wouldn't be fixed.
> 
> Task A                        Task B
> ext4_handle_error()
> -> jbd2_journal_abort()
>   -> __journal_abort_soft()
>     -> __jbd2_journal_abort_hard()
>     | -> journal->j_flags |= JBD2_ABORT;
>     |
>     |                         __ext4_abort()
>     |                         -> jbd2_journal_abort()
>     |                         | -> __journal_abort_soft()
>     |                         |   -> if (journal->j_flags & JBD2_ABORT)
>     |                         |           return;
>     |                         -> panic()
>     |
>     -> jbd2_journal_update_sb_errno()
> 
> Tested-by: Hobin Woo <hobin.woo@samsung.com>
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Applied, thanks.

						- Ted
