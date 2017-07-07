From: Marc Thomas <marc@dragonfly.plus.com>
Subject: Re: e4defrag: Corrupt file after running e4defrag
Date: Fri, 7 Jul 2017 19:02:36 +0100
Message-ID: <a04d7bf6-bc1b-d68d-bfd3-3674d754f7de@dragonfly.plus.com>
References: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
 <20170608223511.2dw7gyqzgwgxxz2q@thunk.org>
 <1b784854-89cc-60d6-8082-5a922b536528@dragonfly.plus.com>
 <20170609152709.z4nvnq2ujqpvvgj3@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:54186 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdGGSEu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 14:04:50 -0400
In-Reply-To: <20170609152709.z4nvnq2ujqpvvgj3@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Many thanks for your reply, and apologies for the delay in responding.

The good news is I have not been able to reproduce the e4defrag induced
file corruption since upgrading from kernel 4.11.3 to 4.11.5 or above,
so I suspect it was a kernel issue after all.
I note there were some extent manipulation fixes included in 4.11.5.

I'm going to have another attempt at the full data migration process
I've been working on, and will report back if I run into any further
problems.


For anyone else TL;DR - you can stop reading at this point.


On 09/06/17 16:27, Theodore Ts'o wrote:
> *Ah*.  So this is a file system was originally ext3, which you made an
> image copy, then enabled various ext4 features using tune2fs, and then
> ran e4defrag, right?  That's useful to know, thanks.  I assume that
> means that the "before" file was mapped using the old-style ext2/ext3
> indirect block map scheme (and not extent-mapped).

Yes, that's correct. The migrated filesystem was also expanded as well.
I verified the md5sums after each step so I knew when the corruption
occurred.
JFYI - I was also able to reproduce the corruption issue on a native
ext4 fs at kernel 4.11.3.

Prior to e4defrag, the "before" files were extent mapped as I'd also run
"e2fsck -E bmap2extent" with a patched e2fsck containing Darrick Wong's
fix "e2fsck: fix sparse bmap to extent conversion". (Commit:
855c2ecb21d1556c26d61df9b014e1c79dbbc956).

> I will say that e4defrag is something that wasn't well supported, and
> the distributions decided not support it.  In fact, with Red Hat they
> don't support using tune2fs to add ext4 features at all, because they
> didn't want to deal with the QA test matrix and support effort that
> this would involve.
>
> At Google we did take file systems that were indirect block mapped
> (ext2, specifically), and run add extent maps and a few other ext4
> features, and so I know that works.  I can also tell you that for our
> data center workload at the time, a converted file system using
> tune2fs has about half of the performance improvement compared to
> switching to a "native" ext4 file system.
>
> But we never used e4defrag because it burns a lot of disk bandwidth,
> and even after the defrag, the low-level layout of the inode table
> blocks, bitmap allocation bitmaps, etc., of an ext2/ext3 file system
> are different enough from a native ext4 file system that we didn't
> think it would be worth it.  That is, even after converting a file
> system to have some (but not all) of the ext4 features by using
> tune2fs, the incremental improvement of running e4defrag was never
> going to be the same as a fully native ext4 file system, and to be
> honest, if you have the disk space, reformatting and copying probably
> would be faster in the end *and* result in a more performant file
> system.

Understood. I would like to keep the original filesystems intact if
possible, because there is some metadata (ctime for example) which is
lost with a backup/restore or file copy.

As regards filesystem performance; I think e4defrag does have some
value. For example, with the data I'm migrating it takes approx 78mins
to verify all the md5sums on the converted ext4 filesystem. After
defragging it takes 62mins to do the same thing. This is around a 20%
improvement, which is good enough for me. The defrag itself takes around
4 hours.

It does use a lot of disk bandwidth, but these are enterprise class
drives - so hopefully they can take it.
I don't propose to use e4defrag on a regular basis, but as a one-off
post migration task, it makes sense to me.

> So that doesn't mean we shouldn't fix the bug if we can find the root
> cause, but understand that in the end you may end up find that all of
> this effort may not be worth it.  (But thank you if you decide to help
> gather the information so we can try to fix the bug anyway.  :-)

Again, understood. I'll report back if I encounter any further issues.

> P.S.  This is also why companies often decide to deprecate features
> that very few people are using.  It may not make business sense to
> keep a feature alive just for a very few set of people using said
> feature, especially if you're looking at it from a cold-hearted
> business perspective, or from the "but what about the careers of the
> engineers stuck maintaining a backwater feature?"  But if you are one
> of the people using the feature, especially if you are journalists or
> people with blogs that get lot of traffic, you tend to lash out about
> how you can't trust that company because it deprecated your favorite
> feature.  (Even if the numbers are that monthly active user count was
> pathetically low.)
>
> In the open source world we're less likely to do that unless the
> feature is actively harmful, but we will sometimes just post "danger,
> this may corrupt your data" signs if we can't get people to volunteer
> to support or fix bugs on that low-use feature.  E4defrag is right on
> the cusp of that, especially now that I know that it can possibly
> corrupt data.  If we can fix the bug, well and good, but if not, and
> no one else wants to (or has time) to fix the bug, we may just put a
> "you probably don't want to use this" sign in the man page, and
> perhaps stop building it by default.  Hopefully, though, the fix will
> be obvious once we get a bit more data.

That's fair enough. Hopefully e4defrag can have a stay of execution for
a while yet.

Finally, apologies for the malformed patches I sent, and thanks for
fixing them up and applying them anyway.

Kind Regards,
Marc
