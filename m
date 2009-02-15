From: Theodore Tso <tytso@mit.edu>
Subject: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 00:32:06 -0500
Message-ID: <20090215053206.GA4803@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60670 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZBOFdM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 00:33:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I was looking at the ext4 code to see how hard it would be to add a
function that would take a struct inode *, and make sure that all of
the pages in the page cache had been allocated a physical block on
disk (but not necessarily writing the I/O to disk).  The idea would be
to do this on close if the file had been truncated or opened with
O_TRUNC, and to also call this function if the inode had been renamed
and in the process a destination inode was freed.  That way if we have
data=ordered, the blocks would be allocated, and at the next commit,
we would force the data blocks to disk.

While I was looking at the code, it looks to me like we are currently
only allocating a page at a time; ext4_da_writepages() may end up
allocating a number of pages, but it's doing it one page at a time,
not an extent at a time.  So if the filesystem blocksize is 4k (and
the page size is 4k), the only time we will ever call the mballoc with
an allocation request greater than 1 is in the fallocate() system call
handler.   This seems... non-optimal.   Am I missing something?

	   		 		     - Ted


