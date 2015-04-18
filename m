From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Sat, 18 Apr 2015 19:53:41 -0400
Message-ID: <20150418235341.GF25265@thunk.org>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
 <1429198977-5637-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46456 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbbDRXxn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2015 19:53:43 -0400
Content-Disposition: inline
In-Reply-To: <1429198977-5637-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 16, 2015 at 05:42:56PM +0200, Jan Kara wrote:
> Ext4 orphan inode handling is a bottleneck for workloads which heavily
> truncate / unlink small files since it contends on the global
> s_orphan_mutex lock (and generally it's difficult to improve scalability
> of the ondisk linked list of orphaned inodes).
> 
> This patch implements new way of handling orphan inodes. Instead of
> linking orphaned inode into a linked list, we store it's inode number in
> a new special file which we call "orphan file". Currently we still
> protect the orphan file with a spinlock for simplicity but even in this
> setting we can substantially reduce the length of the critical section
> and thus speedup some workloads.

Do we need to store the inode number of the orphan inodes in a file?
We only need to deal with orphaned inode if the journal exists --- so
why not just define a new journal block type, and simply dump all of
the orphaned inodes into one or more journal blocks, which get written
out as part of the commit process?

We can track the orphaned inodes using an in-memory RCU linked list,
so it can be completely lockless, and then in the transaction commit,
we can simply traverse the linked list and write out all of orphaned
inodes to the journal.  I think this would be faster and simpler, and
the only real issue is that we'll need to plumb this interface down
into the jbd2 layer.  But I don't think that would be too difficult.

What do you think?

					- Ted
