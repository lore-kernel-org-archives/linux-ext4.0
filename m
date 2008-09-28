From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Sun, 28 Sep 2008 19:46:40 -0400
Message-ID: <20080928234640.GF8711@mit.edu>
References: <48DDE025.2090207@rs.jp.nec.com> <20080927144924.GA11669@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57216 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbYI1Xqn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2008 19:46:43 -0400
Content-Disposition: inline
In-Reply-To: <20080927144924.GA11669@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added online defrag version 0.95 into the ext4 patch queue.
Because of the recent patch I've added to remove the old legacy block
allocator patches 7 through 11 would no longer apply, and so they are
commented out in the patch queue.  In some cases, the patches are ones
that would go away soon anyway.  In the case of EXT4_IOC_RESERVE_BLOCK
ioctl, it was non-functional in the common case where mballoc was in
use, since mballoc never used any of the legacy block reservation
code; so any user space that depended on EXT4_IOC_RESERVE_BLOCK ioctl
couldn't possibly have worked.

If there are needed functions that were removed from mballoc.c that
really are necessary, we can certainly look at adding them back ---
but I would want to check to see if there is similar code in mballoc
that we can use instead.  One of my concerns is that there is been
duplicated code in balloc.c, mballoc.c, extents.c, and defrag.c and
one of the reasons why I wanted to pull out the legacy block
allocation code was to eliminate some of the duplicated code, and to
hopefully expose more of this duplicated code.

In the end it should make all the ext4 code base and the defrag code
more easy to understand and much more robust.

Regards,

							- Ted
