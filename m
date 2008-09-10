From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] fs: revert 8ab22b9a
Date: Wed, 10 Sep 2008 12:19:32 +0200
Message-ID: <20080910101932.GA17531@wotan.suse.de>
References: <20080910045209.GA27092@wotan.suse.de> <6.0.0.20.2.20080910170208.05de1730@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@ucw.cz>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:48006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYIJKTh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 06:19:37 -0400
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20080910170208.05de1730@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 05:47:00PM +0900, Hisashi Hifumi wrote:
> 
> At 13:52 08/09/10, Nick Piggin wrote:
> >
> >Patch 8ab22b9a, "vfs: pagecache usage optimization for pagesize!=blocksize",
> >introduces a data race that might cause uninitialized data to be exposed to
> >userland. The race is conceptually the same as the one fixed for page
> >uptodateness, fixed by 0ed361de.
> >
> >The problem is that a buffer_head flags will be set uptodate after the
> >stores to bring its pagecache data uptodate[*]. This patch introduces a
> >possibility to read that pagecache data if the buffer_head flag has been
> >found uptodate. The problem is there are no barriers or locks ordering
> >the store/store vs the load/load.
> >
> >To illustrate:
> > CPU0: write(2) (1024 bytes)           CPU1: read(2) (1024 bytes)
> > 1. allocate new pagecache page        A. locate page, not fully uptodate
> > 2. copy_from_user to part of page     B. partially uptodate? load bh flags
> > 3. mark that buffer uptodate          C. if yes, then copy_to_user
> >
> >So if the store 3 is allowed to execute before the store 2, and/or the
> >load in C is allowed to execute before the load in B, then we can wind
> >up loading !uptodate data.
> >
> 
> >
> >One way to solve this is to add barriers to the buffer head operations
> >similarly to the fix for the page issue. The problem is that, unlike the
> >page race, we don't actually *need* to do that if we decide not to support
> >this functionality. The barriers are quite heavyweight on some
> >architectures, and we haven't seen really compelling numbers in favour of
> >this patch yet (a best-case microbenchmark showed some improvement of
> >course, but with memory barriers we could also produce a worst-case bench
> >that shows some slowdown on many architectures).
> 
> I think that adding wmb/rmb to all buffer_uptodate/set_buffer_uptodate is heavy
> on some architectures using BUFFER_FNS macros, but it can be possible
> to mitigate performance slowdown by minimizing memory barrier utilization.
> The patch "vfs: pagecache usage optimization for pagesize!=blocksize" is now 
> just for ext2/3/4, so is it not sufficient to solve the above uninitialized data
> exposure problem that adding one rmb to block_is_partially_uptodate() 
> and wmb to __block_commit_write() ?

I guess it could be... if you have audited all those filesystems to ensure
they don't set the buffer uptodate via any other paths.

But still, forcing a wmb for everyone in the block path is... not so nice.
As I said, I think the _best_ way to solve the problem is to ensure the
buffer is only brought uptodate under the page lock, which will then give
you serialisation against block_is_partially_uptodate (which is called with
the page locked). If you are *sure* this is the case for ext2/3/4, then there
should actually be no memory ordering problem in practice. You will have to
document the API to say that users of it must obey that rule.

Thanks,
Nick
