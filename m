From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Ext4 Documentation updates.
Date: Thu, 3 Jul 2008 21:30:59 -0400
Message-ID: <20080704013059.GL30506@mit.edu>
References: <20080702172200.14990.37737.stgit@rx8> <1215035155.6788.43.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59825 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757345AbYGDBbE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 21:31:04 -0400
Content-Disposition: inline
In-Reply-To: <1215035155.6788.43.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 02, 2008 at 02:45:55PM -0700, Mingming Cao wrote:
> +In ext4/JBD2 this ordered mode implementation is different than ext3/JBD
> +ordered mode. First it get rid of using buffer heads to enforce the ordering
> +between metadata change with the related data chage. Instead, in the new
> +ordering mode, it keeps track of per transaction journalled inode list, and
> +flush all the dirty pages for those inodes, when committing that transaction.
> +Second, the new ordered mode reverse the lock ordering of the page lock and
> +transaction lock, to fixing the locking issue in the new mode, and also provide
> +easy support for delayed allocation over the new ordered mode

This is implementation detail that doesn't belong in
Documentation/filesystems/ext4.txt; a user won't care about this kind
of detail.

However, it is *perfect* for the the (as-yet-undocumented) patch
comment for the new ordered mode patch in the series.  I rewrote it
for gramatical correctness and clarity thusly, for the patch
delalloc-new-ordered-mode.patch:

    This provides a new ordered mode implementation which gets rid of using
    buffer heads to enforce the ordering between metadata change with the
    related data chage.  Instead, in the new ordering mode, it keeps track
    of all of the inodes touched by each transaction on a list, and when
    that transaction is committed, it flushes all of the dirty pages for
    those inodes.  In addition, the new ordered mode reverses the lock
    ordering of the page lock and transaction lock, which provides easier
    support for delayed allocation.

					- Ted
