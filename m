From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Sat, 18 Mar 2017 20:39:28 -0400
Message-ID: <20170319003928.shnxljfcpvmovcw4@thunk.org>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
 <E3BFD2D7-CCEF-4A10-A4E6-ED634C56436F@gmail.com>
 <07B442BA-D335-4079-8691-0AB1FAD7368F@dilger.ca>
 <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
 <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
 <EA1BCCB1-AEC7-4193-823B-6230B6860C0C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54124 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdCSAj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 18 Mar 2017 20:39:59 -0400
Content-Disposition: inline
In-Reply-To: <EA1BCCB1-AEC7-4193-823B-6230B6860C0C@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 18, 2017 at 08:17:55PM +0300, Alexey Lyashkov wrote:
> > 
> > That's not true.  We normally only read in one block a time.  If there
> > is a hash collision, then we may need to insert into the rbtree in a
> > subsequent block's worth of dentries to make sure we have all of the
> > directory entries corresponding to a particular hash value.  I think
> > you misunderstood the code.
>
> As i see it not about hash collisions, but about merging a several
> blocks into same hash range on up level hash entry.  so if we have a
> large hash range originally assigned to the single block, all that
> range will read at memory at single step.  With «aged» directory
> when hash blocks used already - it’s easy to hit.

If you look at ext4_htree_fill_tree(), we are only iterating over the
leaf blocks.  We are using a 31-bit hash, where the low-order bit is
one if there has been a collision.  In that case, we need to read the
next block to make sure all of the directory entries which have the
same 31-bit hash are in the rbtree.

So *even* if the directory is so badly fragmeneted that there is only
one directory entry per block, we will eventually find a block where
the last (only) directory entry has a different directory entry from
the current hash value, at which point we can stop.

And I'll note that this is a problem that can be solved without
changing the on-disk format, but simply adding code so we can merge
adjacent directory entry blocks.  The main reason why it hasn't been
done is (a) no one has sent me patches, and (b) I haven't seen
workloads where this has been anything other than a theoretical /
academic concern.

You seem very passionate about this.  Is this a problem you've
personally seen?  If so, can you give me more details about your use
case, and how you've been running into this issue?  Instead of just
arguing about it from a largely theoretical perspective?

> Yes, i expect to have some seek penalty. But may testing say it too huge now.
> directory creation rate started with 80k create/s have dropped to the 20k-30k create/s with hash tree extend to the level 3.
> Same testing with hard links same create rate dropped slightly.

So this sounds like it's all about the seek penalty of the _data_
blocks.  If you use hard links the creation rate only dropped a
little, am I understanding you corretly?  (Sorry, your English is a
little fracturered so I'm having trouble parsing the meaning out of
your sentences.)

So what do you think the creation rate _should_ be?  And where do you
think the time is going to, if it's not the fact that we have to place
the data blocks further and further from the directory?  And more
importantly, what's your proposal for how to "fix" this?

> > As for the other optimizations --- things like allowing parallel
> > directory modifications, or being able to shrink empty directory
> > blocks or shorten the tree are all improvements we can make without
> > impacting the on-disk format.  So they aren't an argument for halting
> > the submission of the new on-disk format, no?
> > 
> It’s argument about using this feature. Yes, we can land it, but it decrease an expected speed in some cases.

But there are cases where today, the workload would simply fail with
ENOSPC when the directory couldn't grow any farther.  So in those
cases _maybe_ there is something we could do differently that might
make things faster, but you have yet to convince me that the
fundamental fault is one that can only be cured by an on-disk format
change.  (And if you believe this is to be true, please enlighten us
on how we can make the on-disk format better!)

Cheers,

					- Ted
