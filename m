From: Jan Kara <jack@suse.cz>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Wed, 13 Mar 2013 22:14:06 +0100
Message-ID: <20130313211406.GB7754@quack.suse.cz>
References: <20130313095640.GC29730@quack.suse.cz>
 <CAF5pi0EYU84mVffFx5qUfK7n-T2sAJDj4JLf26ZhvDWozOCxBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhovopenvz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3CMVOK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 17:14:10 -0400
Content-Disposition: inline
In-Reply-To: <CAF5pi0EYU84mVffFx5qUfK7n-T2sAJDj4JLf26ZhvDWozOCxBA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-03-13 23:04:40, Dmitry Monakhov wrote:
> On Mar 13, 2013 11:57 AM, "Jan Kara" <jack@suse.cz> wrote:
> >
> >   Hello Dmitry,
> >
> >   I'm tracking down failure in xfstests test 274 (fallocate + ENOSPC
> > testing). The problem I found (and that's really unrelated to the question
> > I want to ask) is that if write beyond i_size fails, we truncate the file
> > to i_size to remove any blocks that may have been allocated under the page
> > by the write before it failed (think of blocksize < pagesize config).
> >
> > Now in this test the write fails because it needs to split unwritten
> extent
> > and there's no space for that and zeroing out is impossible because we are
> > beyond i_size. And here comes my question: You disallowed zeroing of
> > extents beyond i_size because fsck complains about those. Won't it be
> > better to just add inode flag saying "this inode has blocks preallocated
> > beyond i_size" and make fsck not complain about such blocks? IMHO that
> > would catch 99% of corruptions as well and would let us solve the problem
> > with ENOSPC on writes to preallocated space (plus it would simplify the
> > kernel code).
> Looks reasonable, but it will make kernel incompatible with old fsck. How
> long does it takes to force customers to move to new version of fsck?
  First we'd have to add the support into fsck and once that is released,
distros pick that up pretty quickly so after a month or two we can release
it in the kernel. After all the fsck complaint isn't anything serious and
it will happen only if we hit ENOSPC while splitting extents beyond i_size
which is pretty rare. In those cases we would have to say to the complaining
people to update e2fsprogs.

> (Sorry for inconvenient email address , I'm on vacation till the end of the
> week)
  No problem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
