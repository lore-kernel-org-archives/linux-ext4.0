From: Jan Kara <jack@suse.cz>
Subject: Two questions on VFS/mm
Date: Wed, 4 Jun 2008 18:34:12 +0200
Message-ID: <20080604163412.GL16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48151 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754184AbYFDQeP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 12:34:15 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  could some kind soul knowledgable in VFS/mm help me with the following
two questions? I've spotted them when testing some ext4 for patches...
  1) In write_cache_pages() we do:
...
	lock_page(page);
	...
	if (!wbc->range_cyclic && page->index > end) {
                   done = 1;
                   unlock_page(page);
                   continue;
        }
	...
	ret = (*writepage)(page, wbc, data);

  Now the problem is that if range_cyclic is set, it can happen that the
page we give to the filesystem is beyond the current end of file (and can
be already processed by invalidatepage()). Is the filesystem supposed to
handle this (what would it be good for to give such a page to the fs?) or
is it just a bug in write_cache_pages()?

  2) I have the following problem with page_mkwrite() when blocksize <
pagesize. What we want to do is to fill in a potential hole under a page
somebody wants to write to. But consider following scenario with a
filesystem with 1k blocksize:
  truncate("file", 1024);
  ptr = mmap("file");
  *ptr = 'a'
     -> page_mkwrite() is called.
        but "file" is only 1k large and we cannot really allocate blocks
        beyond end of file. So we allocate just one 1k block.
  truncate("file", 4096);
  *(ptr + 2048) = 'a'
     - nothing is called and later during writepage() time we are surprised
       we have a dirty page which is not backed by a filesystem block.

  How to solve this? One idea I have here is that when we handle truncate(),
we mark the original last page (if it is partial) as read-only again so
that page_mkwrite() is called on the next write to it. Is something like
this possible? Pointers to code doing something similar are welcome, I don't
really know these things ;).

								Thanks
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
