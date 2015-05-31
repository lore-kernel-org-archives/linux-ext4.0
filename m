From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/8] ext4 crypto: fix memory leaks in
 ext4_encrypted_zeroout
Date: Sun, 31 May 2015 10:26:01 -0400
Message-ID: <20150531142601.GA11642@thunk.org>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
 <20150529180834.GA22657@jaegeuk-mac02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39276 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbbEaO0E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 10:26:04 -0400
Content-Disposition: inline
In-Reply-To: <20150529180834.GA22657@jaegeuk-mac02>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 11:08:34AM -0700, Jaegeuk Kim wrote:
> Not sure why __GFP_WAIT is defined here.
> Even GFP_NOFS has __GFP_WAIT.
> 
> #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
> 
> IMO, __GFP_NOFAIL should be used here?
> Otherwise, we seem to handle ENOMEM instead.

You're right, thanks for pointing that out.  I've since changed the
patch so that we just return ENOMEM, and then made sure that we could
correctly handle ENOMEM.


On a different front, I've been thinking more about your proposal to
swap alloc_pages() and mempool_alloc(), since you were apparently
seeing OOM killers with a sufficiently aggressive fio workload on a
memory constrained device.

I took a closer look at how mempool_alloc() works, and in fact it will
try alloc_pages() first; but with GFP flags which causes it to not try
very hard.  (__GFP_NOMEMALLOC, __GFP_NORETRY, __GFP_NOWARN,
!__GFP_WAIT, !__GFP_IO).

If this fails, it tries to use the memory pool, and then assuming the
original request includes __GFP_WAIT, it will retry the alloc_pages()
using the original gfp mask, if this *still* fails, it will wait for a
page to be released to the mempool.  As a result, mempool_alloc() will
never fail when called with __GFP_WAIT, which means my original
concerns over mempool_alloc() failing were misplaced.

This has lead me to the following thoughts/conclusions:

1) We can just drop the alloc_page() call from alloc_bounce_page(),
since mempool_alloc() will call alloc_page() first.  This also allows
us to remove all of the complexity relating to the
EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL flag.

2) Since mempool_alloc() will end up calling alloc_pages() --- and in
fact will try to alloc_pages() *twice* --- once with a "don't try
hard", and then a second time the way we would have alwyas called it
--- in practice this won't reduce the number of calls to allocate and
free pages assuming that there is enough memory in the system.

3) I don't think increasing num_prealloc_crypto_pages() to BIO_MAX is
the best idea; (a) it sequesters a large amount of memory, and (b)
even 256 pages is guaranteed to be enough.  On a Samsung 840 EVO (for
example), you can have up to 32767k in a single request, and up to 31
requests in its NCQ.  So in the worst case, you can have close to a
gigabyte of outstanding writes, and thus with a sufficiently evil set
of fio options, we could end up needing that many bounce pages.  And
remember, the mempool is a shared resource; if we have multiple
devices with encrypted file systems, the memory pressure could be even
greater.

4) I need to run the experiment, but what might make sense is to just
call mempool_alloc() with GFP_NOWAIT.  This will allow us to use
memory if it is available, but if not, we will simply retry the page
for writeback.  The mempool is there simply to provide a bit of extra
spare capacity so that we send out reasonably sized I/O's when under
very high memory pressure.  We can make the size of the mempool a
tunable which is dynamically adjustable using a sysfs file, and we can
see what seems to be the best tradeoff between having a fixed memory
allocation and performance under high memory pressure and heavy write
loads.

What do you think?  Does that make sense?  If so, you might want to
try a similar experiment; try removing the alloc_page() fallback
altogether, try calling mempool_alloc() with GFP_NOWAIT, and then try
different settings for num_prealloc_crypto_pages.

						- Ted

