From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
Date: Sun, 23 Jun 2013 13:36:28 -0400
Message-ID: <20130623173628.GC16620@thunk.org>
References: <51C1381A.2@huawei.com>
 <20130620155555.GE28309@thunk.org>
 <51C4553B.7010809@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Ocfs2-Devel <ocfs2-devel@oss.oracle.com>,
	Li Zefan <lizefan@huawei.com>, jack@suse.cz
To: Younger Liu <younger.liu@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60476 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3FWRgg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 13:36:36 -0400
Content-Disposition: inline
In-Reply-To: <51C4553B.7010809@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 09:29:31PM +0800, Younger Liu wrote:
> 
> This bug was triggered by the following scenario:
> In ocfs2 file system, allocate a very large disk space for a small file
> with ocfs2_fallocate(), while the journal file size is 32M. 
> 
> Because there are much many journal blocks needed by jbd2_journal_restart(), 
> so that nblocks is greater than journal->j_max_transaction_buffers 
> in start_this_handle(), and then return -ENOSPC.

Ah, I see.  I have a patch that should prevent the kernel from
crashing in this situation, and which adds some additional checks to
make sure no one tries to use the handle after jbd2_journal_restart()
fails in this circumstance.

However, you may want to further pursue a fix in ocfs2 so you don't
actually return ENOSPC to userspace, since it is a very misleading
error message --- it's not that the file system is out of space, but
that the journal is too small for the amount of space that you are
trying to allocate using fallocate().

I would think a better way of handling this situation would be to log
a warning message that the journal is probably too small, and then to
break up the fallocate into smaller chunks, so that it can
successfully complete despite the fact that the journal was
unfortunately missized.

I'll be sending the proposed fix in a moment; could you check and see
if the patch prevents ocfs2/jbd2 from tripping over the assertion
given your test case?

Thanks,

					- Ted
