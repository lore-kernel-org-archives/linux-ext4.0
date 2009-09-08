From: Theodore Tso <tytso@mit.edu>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Tue, 8 Sep 2009 19:36:44 -0400
Message-ID: <20090908233644.GV22901@mit.edu>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com> <20090908175605.GB7801@shell> <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com> <20090908194045.GQ22901@mit.edu> <6601abe90909081418k5de55938mfe411fccfe10a258@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Aurora <vaurora@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44992 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZIHXgt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 19:36:49 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909081418k5de55938mfe411fccfe10a258@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 02:18:35PM -0700, Curt Wohlgemuth wrote:
> 
> All bforget() does is clear the buffer's dirty bit.  Meanwhile, the
> page is still marked dirty, and can be in the middle of writeback;
> it's true that __block_write_full_page() will check the dirty bit for
> each buffer in the page, but there doesn't seem to be any
> synchronization to ensure that the write won't take place at some
> point in time after bforget() is called.  Which means it can be called
> after the bitmap is changed.

Let me make sure I got this right.  The problem that you're worried
about is a block that had previously contained an extent tree node for
an inode that gets deleted, and then that blocks gets reallocated for
use as a data block.  In ext3 and ext4, metadata blocks (such as
extent tree blocks), aren't stored in the page cache.

So I'm not sure why you're worried about the page being marked dirty.
What's the scenario you are concerned about?

If it's the case where a data block for a deleted inode getting
rewritten after the inode is deleted, when the inode is deleted,
truncate_inode_apges() end up dropping the pages from the page cache
*before* the block allocation bitmap is dropped.

> This is why I opted to wait for the buffer to be written out before
> continuing on to ext4_free_blocks().

Just to be clear, which buffer are you talking about here?

     	   	  	       	       - Ted
