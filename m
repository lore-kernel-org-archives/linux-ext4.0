From: Nick Piggin <npiggin@suse.de>
Subject: IO error semantics
Date: Mon, 18 Jan 2010 17:05:18 +1100
Message-ID: <20100118060518.GA9151@laptop>
References: <4B4EB5B9.4020809@hitachi.com>
 <4B4EDE5C.8040600@hitachi.com>
 <4B4EEE86.7080807@hitachi.com>
 <20100114141803.GB3146@quack.suse.cz>
 <20100118051847.GA8678@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0ARGFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jan 2010 01:05:23 -0500
Content-Disposition: inline
In-Reply-To: <20100118051847.GA8678@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 18, 2010 at 04:18:47PM +1100, Nick Piggin wrote:
> We also need to remove some ClearPageUptodate calls I think (similar
> issues), so keep those in mind too. Unfortunately it looks like there
> are also a lot of filesystem specific tests of PageUptodate... but you
> could also move those under the new compatibility s_flag.
> 
> I don't know of a really good way to inject and test filesystem errors.
> Make request failures causes most fs to quickly go readonly or have
> bigger problems. If you're careful like try to only fail read IOs for
> data, or only fail write IOs not involved in integrity or journal
> operations, then test programs just tend to abort pretty quickly. Does
> anyone know of anything more systematic?

This might be a good time to bring up IO error behaviour again. I got
into some debates I think on Andi's hwpoison thread a while back, but
probably not appropriate thread to find a real solution to this.

The problem we have now is that IO error semantics are not well defined.
It is hard to even enumerate all the issues.

read IOs
  how to retry? appropriate defaults should happen at the block layer I
  think. Should retry behaviour be tunable by the mm/fs, or should that
  be coded explicitly as submission retry loops? Either way does imply
  there is either similar defaults for all types (or maybe classes) of
  drivers, or some way to query/set this.

  It would be nice to be able to set fs/driver behaviour from userspace
  too, in a generic (not driver or fs specific way). But defaults should
  be reasonable and similar between all, I guess.

write IOs
  This is more interesting. How to handle write IO errors. In my opinion
  we must not invalidate the data before an IO error is returned to
  somebody (whether it be fsync or a synchronous write syscall). Any
  earlier and the app just gets RAW consistency randomly violated. And I
  think it is important to treat IO errors as transparently as possible
  until the error can be detected.

  I happen to think that actually we should go further and not
  invalidate the data at all. This makes implementation simpler, and
  also allows us to retry writes like we can retry reads. It's also
  problematic to throw out errors at that point because *sync syscalls
  coming from elsewhere could result in loss of error reporting (think,
  sys_sync).

  If we go this way, we probably need another syscall and fs helper call
  to invalidate the dirty data when we give up on retries. truncate_range
  probably not appropriate because it is much harder to implement and
  maybe we want to try to get at the most recent data that is on disk.

  Also do we need to think about O_SYNC or -o sync type of writes that
  are implemented via writeback cache? We could invalidate the dirtied
  cache ASAP, which would leave a window where a concurrent read can see
  first new, then old data. It would also kind of break the above scheme
  in case the pagecache was already dirty via a descriptor without
  O_SYNC. It might just make sense to leave the pagecache dirty. Either
  way it should be documented I think.

Do we even care enough to bother thinking about this now? (serious question)

