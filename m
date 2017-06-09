From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e4defrag: Corrupt file after running e4defrag
Date: Fri, 9 Jun 2017 11:27:09 -0400
Message-ID: <20170609152709.z4nvnq2ujqpvvgj3@thunk.org>
References: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
 <20170608223511.2dw7gyqzgwgxxz2q@thunk.org>
 <1b784854-89cc-60d6-8082-5a922b536528@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37212 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751534AbdFIP1M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Jun 2017 11:27:12 -0400
Content-Disposition: inline
In-Reply-To: <1b784854-89cc-60d6-8082-5a922b536528@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 09, 2017 at 02:31:08AM +0100, Marc Thomas wrote:
> 
> I have around 3TB unallocated space in the LVM group, so should be able
> to hold a pre-defrag and post-defrag copy of the filesystem.
> What I'll do is re-copy the source filesystem (ext3), and do the
> conversion to ext4. I'll then make a block level copy of that and
> e4defrag the copy.

*Ah*.  So this is a file system was originally ext3, which you made an
image copy, then enabled various ext4 features using tune2fs, and then
ran e4defrag, right?  That's useful to know, thanks.  I assume that
means that the "before" file was mapped using the old-style ext2/ext3
indirect block map scheme (and not extent-mapped).

I will say that e4defrag is something that wasn't well supported, and
the distributions decided not support it.  In fact, with Red Hat they
don't support using tune2fs to add ext4 features at all, because they
didn't want to deal with the QA test matrix and support effort that
this would involve.

At Google we did take file systems that were indirect block mapped
(ext2, specifically), and run add extent maps and a few other ext4
features, and so I know that works.  I can also tell you that for our
data center workload at the time, a converted file system using
tune2fs has about half of the performance improvement compared to
switching to a "native" ext4 file system.

But we never used e4defrag because it burns a lot of disk bandwidth,
and even after the defrag, the low-level layout of the inode table
blocks, bitmap allocation bitmaps, etc., of an ext2/ext3 file system
are different enough from a native ext4 file system that we didn't
think it would be worth it.  That is, even after converting a file
system to have some (but not all) of the ext4 features by using
tune2fs, the incremental improvement of running e4defrag was never
going to be the same as a fully native ext4 file system, and to be
honest, if you have the disk space, reformatting and copying probably
would be faster in the end *and* result in a more performant file
system.

So that doesn't mean we shouldn't fix the bug if we can find the root
cause, but understand that in the end you may end up find that all of
this effort may not be worth it.  (But thank you if you decide to help
gather the information so we can try to fix the bug anyway.  :-)

Cheers,

						- Ted

P.S.  This is also why companies often decide to deprecate features
that very few people are using.  It may not make business sense to
keep a feature alive just for a very few set of people using said
feature, especially if you're looking at it from a cold-hearted
business perspective, or from the "but what about the careers of the
engineers stuck maintaining a backwater feature?"  But if you are one
of the people using the feature, especially if you are journalists or
people with blogs that get lot of traffic, you tend to lash out about
how you can't trust that company because it deprecated your favorite
feature.  (Even if the numbers are that monthly active user count was
pathetically low.)

In the open source world we're less likely to do that unless the
feature is actively harmful, but we will sometimes just post "danger,
this may corrupt your data" signs if we can't get people to volunteer
to support or fix bugs on that low-use feature.  E4defrag is right on
the cusp of that, especially now that I know that it can possibly
corrupt data.  If we can fix the bug, well and good, but if not, and
no one else wants to (or has time) to fix the bug, we may just put a
"you probably don't want to use this" sign in the man page, and
perhaps stop building it by default.  Hopefully, though, the fix will
be obvious once we get a bit more data.
