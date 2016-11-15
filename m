From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: allow inode expansion for nojournal file systems
Date: Mon, 14 Nov 2016 21:52:32 -0500
Message-ID: <20161115025232.6vfs6v2mkpq3ttae@thunk.org>
References: <20161025211405.GA15502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37594 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933542AbcKOCwh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Nov 2016 21:52:37 -0500
Content-Disposition: inline
In-Reply-To: <20161025211405.GA15502@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2016 at 05:14:05PM -0400, Eric Whitney wrote:
> Runs of xfstest ext4/022 on nojournal file systems result in failures
> because the inodes of some of its test files do not expand as expected.
> The cause is a conditional in ext4_mark_inode_dirty() that prevents inode
> expansion unless the test file system has a journal.  Remove this
> unnecessary restriction.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
