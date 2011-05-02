From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Block reservation on page fault time for ext3
Date: Mon,  2 May 2011 22:56:52 +0200
Message-ID: <1304369816-14545-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1EBU5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 16:57:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  ext3 has a problem that mmap writes end up allocating blocks only in
writepage() callback. This then effectively invalidates any quota checking
because writepage() is called from flusher thread thus with root priviledges.
So any user is able to arbitrarily exceed quota limit using mmap write.

The following four patches try to address this problem. The patches implement
page_mkwrite() callback which allocates all necessary metadata and reserves
space for data block (this is the main difference from the patches I was
sending last autumn which did not allocate metadata). Then during writepage()
(or write()) time the reservation gets converted into real block allocation.

With this implementation I don't see any performance difference in heavy
BerkleyDB load from the ext3 without these patches. Simple allocation in
page_mkwrite() ends up being about 3x slower than this reservation scheme
because of fragmentation.

I've tested the patch on both x86_64 (1K and 4K blocksize) and ppc with 64k
pages (1K and 4K blocksize) to catch possible bugs. I've also run tests in
ENOSPC conditions and conditions when quota is getting exceeded. All these
tests run fine with this version of patches (actually, I've triggered two
genuine ext3 bugs during this testing which I'm going to merge separately).

So I'd like to merge these patches but before I do that I'd like another
pair of eyes to have a look at these changes... So comments are welcome.

Maybe one more addition: As we spoke at LSF, we plan to remove ext3 driver
from kernel. But it's still going to take significant amount of time (more
than an year) so I'd like to have this serious issue fixed in ext3.

								Honza
