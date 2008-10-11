From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, e2fsprogs] libext2fs: Add ext2fs_block_iterate3()
	which has 64-bit support
Date: Sat, 11 Oct 2008 07:32:36 -0400
Message-ID: <20081011113236.GA12662@mit.edu>
References: <E1KoOpr-0003FT-2f@closure.thunk.org> <20081010220249.GA28360@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60562 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbYJKLcj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 07:32:39 -0400
Content-Disposition: inline
In-Reply-To: <20081010220249.GA28360@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 06:02:49PM -0400, Valerie Aurora Henson wrote:
> On Fri, Oct 10, 2008 at 04:43:43PM -0400, Theodore Ts'o wrote:
> > 
> > There was discussion about how to do 64-bit ABI conversation, and an
> > assertion that it might be hard to do ext2fs_block_iterate3.  So I
> > decided give an example of how I believe the most efficient way to do
> > this sort of thing.
> 
> I'm afraid there's been a misunderstanding; I wasn't saying it was
> hard, just pointing out that different versions of interfaces are
> profilerating as a result of continuing to support the old ABI at the
> same time as the new 64-bit ABI - perhaps more versions of more
> functions than was originally anticipated. (I wrote a similar patch
> and I agree it's not hard, just more cruft to maintain.)

But it's not that much more cruft to maintain.  Take a look at my
patch; the original interface gets implemented on top of the old
interface, so the amount of extra cruft to maintain is minimal.  The
implementation of ext2fs_block_iterate2 simply becomes:

	struct xlate64 xl;

	xl.real_private = priv_data;
	xl.func = func;

	return ext2fs_block_iterate3(fs, ino, flags, block_buf,
				     xlate64_func, &xl);

That wasn't that bad, was it?

> Eagerly awaiting ext2fs_block_iterate4,

If there are other changes that we need to implement at the same time,
if we haven't done a release yet, we can fold those changes into the
ext2fs_block_iterate3.

							- Ted
