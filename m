From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: next/mmotm: ext4 causes !rwsem_is_locked warnings
Date: Thu, 27 Sep 2012 17:27:08 -0400
Message-ID: <20120927212708.GA10044@thunk.org>
References: <alpine.LSU.2.00.1209271334560.2226@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52770 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2I0V1P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 17:27:15 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209271334560.2226@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 27, 2012 at 02:05:00PM -0700, Hugh Dickins wrote:
> Hi Ted,
> 
> mmotm (or next) now gives me lots of WARNING at fs/fs-writeback.c:1312 from
> writeback_inodes_sb_nr().  That's WARN_ON(!rwsem_is_locked(&sb->s_umount))
> (some useful safety from hch) in writeback_inodes_sb_nr().
> 
> Your commit 40e684e5c597a98996cf4616e31fb2581ec82060
> "ext4: fix potential deadlock in ext4_nonda_switch()" needs more change
> to fs/fs-writeback.c.  I guess I'm the only one using a nearly full ext4.
> 
> I am, of course, applying the patch at the bottom to my tree for now;
> but I think you'd do better not to eliminate that check.  Maybe add a
> special wb_reason for your case, and skip rwsem check in that case.

Yeah, we were just discussing this on another thread.  I didn't think
of the option of creating a new special wb_reason option, but that's a
much better option than the other ones I had been considering, so I
think I will give that a try.   Thanks for the suggestion!!

      	     	       	 	       - Ted
