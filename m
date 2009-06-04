From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 1/4] ext4: Check for only delay or unwritten
	buffer_heads
Date: Thu, 4 Jun 2009 09:16:44 -0400
Message-ID: <20090604131644.GG21314@mit.edu>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34137 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZFDNQw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 09:16:52 -0400
Content-Disposition: inline
In-Reply-To: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added this patch to the ext4 patch queue with the folloiwng
changelog comment:

ext4: Fix mmap/truncate race when blocksize < pagesize && delayed allocation

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

It is possible to see buffer_heads which are not mapped in the
writepage callback in the following scneario (where the fs blocksize
is 1k and the page size is 4k):

1) truncate(f, 1024)
2) mmap(f, 0, 4096)
3) a[0] = 'a'
4) truncate(f, 4096)
5) writepage(...)

Now if we get a writepage callback immediately after (4) and before an
attempt to write at any other offset via mmap address (which implies we
are yet to get a pagefault and do a get_block) what we would have is the
page which is dirty have first block allocated and the other three
buffer_heads unmapped.

In the above case the writepage should go ahead and try to write the
first blocks and clear the page_dirty flag. Further attempts to write
to the page will again create a fault and result in allocating blocks
and marking page dirty.  If we don't write any other offset via mmap
address we would still have written the first block to the disk and
rest of the space will be considered as a hole.

So to address this, we change all of the places where we look for
delayed, unmapped, or unwritten buffer heads, and only check for
delayed or unwritten buffer heads instead.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
