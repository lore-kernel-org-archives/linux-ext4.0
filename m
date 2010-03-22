From: tytso@mit.edu
Subject: Re: [PATCH] ext4: check missed return value ext4_sync_file
Date: Sun, 21 Mar 2010 20:50:13 -0400
Message-ID: <20100322005013.GB11560@thunk.org>
References: <87wrxij28h.fsf@openvz.org>
 <20100311162707.GB19923@atrey.karlin.mff.cuni.cz>
 <87y6hy9bqg.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51216 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0CVCMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:18 -0400
Content-Disposition: inline
In-Reply-To: <87y6hy9bqg.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 12, 2010 at 11:37:43AM +0300, Dmitry Monakhov wrote:
> The most unpleasant part in ext4_sync_file implementation is that 
> barrier is issued on each fsync() call.  So some bad user may perform:
> while(1) fsync(fd);
> which result in bad system performance. And since barrier request is 
> empty it is hard to detect the reason of troubles.
> Off course we may solve it by introducing some sort of dirty flag
> which is set in write_page, and clear in fsync. But it looks as
> ugly workaround.

We could potentially put the dirty flag in the inode instead, and set
it write_prepare() and writepages() code paths.  I'm not entirely sure
it's worth it, though.

> In respect to previous comments the patch reduced to simple missed
> error check fix.

I've added this to the ext4 patch queue, and I will ignore your
earlier version of the patch.

					- Ted
