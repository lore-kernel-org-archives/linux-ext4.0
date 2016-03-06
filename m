From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v4 1/6] Always read full inode structure
Date: Sun, 6 Mar 2016 00:46:22 -0500
Message-ID: <20160306054622.GK10297@thunk.org>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
 <1457237696-13770-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36938 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbcCFFqZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 00:46:25 -0500
Content-Disposition: inline
In-Reply-To: <1457237696-13770-2-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 06, 2016 at 01:14:51PM +0900, Li Xi wrote:
> Project quota need use some extra field of inode for computing quota
> accounting, this patch tries to use ext2fs_get_next_inode_full()
> everywhere to read full inode into memeory.
> 
> It also fixes a bug that only copy small inode in the function.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Um, no.  Most of the places where we are currently using
ext2fs_get_next_inode() is because they **don't** need the full inode.
For example, consider debugfs's icheck command.  Why would it need the
project quota id?  Answer: it doesn't.

If you think there is a bug, or some place where we should be using
the large inode, fine.  Let's take a look at it.  But doing a whole
sale conversion of ext2fs_get_next_inode() to
ext2fs_get_next_inode_full() makes e2fsprogs much less efficient, and
for no good purpose.

					- Ted
