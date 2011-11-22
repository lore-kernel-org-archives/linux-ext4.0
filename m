From: Dave Chinner <david@fromorbit.com>
Subject: Re: Better organizing ext4 development community
Date: Tue, 22 Nov 2011 16:12:42 +1100
Message-ID: <20111122051241.GL2386@dastard>
References: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11754 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765Ab1KVFMr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Nov 2011 00:12:47 -0500
Content-Disposition: inline
In-Reply-To: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2011 at 10:58:36AM -0500, Theodore Ts'o wrote:
> Review Bottleneck
> =================
> 
> Currently, patches, especially large patch series which introduce some
> new feature, have become bottlenecked on my time to review them.   It
> would be very helpful if we had more people reviewing patches.  And it
> needs to be substantive reviews, and preferably from people who work at
> companies other than the developer who has submitted the patches.
> 
> So some way that we can get more people reviewing patches would
> certainly be helpful.  There have been some people who have suggested
> different ways that we might do things, from the method used in XFS
> (where no patch gets submitted until it gets an independent review;
> which would be a bit scary since at the moment so little review takes
> place I'm concerned it would hold back development significantly),

I think that's only a short-term concern, Ted.

Indeed, look at the numbers. For XFS, we have a core group of 4-5
active developers doing all the work and all the review for both the
userspace and kernel changes[*] - ext4 has more than 2x the active
developer base compared to XFS.

However, it's worth a look at the amount of code this XFS dev group
has changed and reviewed since 2.6.32 under the mandatory review
policy.  Kernel code [**]:

$ git diff --find-renames --stat v2.6.32.. -- fs/xfs/ |tail -1
169 files changed, 24897 insertions(+), 30340 deletions(-)

and commit count:

$ glo v2.6.32.. -- fs/xfs | wc -l
816

In the same timeframe, the ext4 kernel code:

$ git diff --find-renames --stat v2.6.32.. -- fs/ext4 fs/jdb2 |tail
-1
 34 files changed, 12080 insertions(+), 6979 deletions(-)
$ glo v2.6.32.. -- fs/ext4 fs/jdb2 | wc -l
691

The amount of change made to the ext4 kernel vs XFS kernel code
bases in terms of LOC is 3-4x less, and the commit count is about
20% less despite having 2x the developer code base than for XFS.
That's a big differential in productivity when you consider it on
a per-developer basis, regardless of the size of the code base.

My point here is that mandatory code review does not actually slow
down the rate of development. In fact, I'll argue that it speeds up
the rate of development over the medium to long term because of
several factors:

1. it forces people to understand code they are not familiar with
   and ask questions about it which the developer has to respond to,
   thereby speeding up the learning cycle for both developers and
   reviewers.

2. it encourages people to review code, because if you don't review
   patches as they are posted, then nobody is going to review your
   patches promptly in return. This speeds up the review process.

3. from 1) developer expertise improves, leading to improved quality
   of submitted patches, which also then has the effect of making
   review easier.

4. from 2) and 3), it reduces the review burden on the maintainer,
   because over time the maintainer can begin to trust that
   Reviewed-by tags indicate that the change is good. This will take
   time to build such trust, but without it there is no way for the
   maintainer to know how hard to look at any given change before
   deciding whether to merge it.

5. from 2) and 3), the maintainer no longer needs to be a gate
   keeper deciding whether changes are good or not. The maintainer
   participates in that discussion just like any other developer,
   including giving out Reviewed-by tags when they are satisfied a
   change is good. IOWs, the bar to getting a change merged is
   consensus and having sufficient reviewed-by tags on a patch
   [series] to convince the maintainer that the change is
   acceptible.

6) from 4) and 5), the trust built into reviewed-by tag when used
   in this manner removes the need for the maintainer to be the
   ultimate expert about everything. In the XFS world the maintainer
   is the person that maintains the tree that is pushed to Linus,
   but otherwise they are just another developer that proposes
   changes and reviews code like anyone else.

7) from 6), it frees experts to develop and review code and improve
   processes rather than having to spend most of their time being
   patch monkeys, cat herders, gate keepers and, ultimately, a
   bottleneck in the development process. Distributed review as
   encoded by gathering Reviewed-by tags generates consensus about
   whether changes are good or not, hence removing the need for the
   maintainer to be the sole decision maker on a project.

8) From 7), experts have more time available to mentor new
   developers and also spend more time explaining complexities to
   more experienced developers during review cycles.  This feeds
   back into improving the knowledge base of the development group
   via 1), 2) and 3).

9) from all of the above, code and product quality improves at a
   faster rate because of the continuously improving knowledge base
   and increasing level of confidence that developers have in the
   capability of their peers.

I'm not going to argue that this policy the right solution for the
problems Ted has brought up - that's for you guys to decide. All I'm
doing is explaining why I think the mandatory review policy works
for XFS, and how it could also benefit the ext4 community....

Cheers,

Dave.

[*] FYI, Lucas had a great slide describing the relative developer
breakdown between the filesystems at his talk at Linuxcon Europe.
It's the slides 5-7 of this presentation:

https://events.linuxfoundation.org/images/stories/pdf/lceu11_czerner1.pdf

[**] I've ignored userspace because I don't have a ext4 userspace
tree handy right now. The XFS xfsprogs changes (excluding
translations) over the last 2 years (since 3.0.4 was release) are
also significantly larger than the ext4 kernel codebase changes:

$ git diff --find-renames --stat v3.0.4 -- [!p]* |tail -1
 227 files changed, 11729 insertions(+), 8788 deletions(-)
$ glo v3.0.4 -- [!p]* | wc -l
934

-- 
Dave Chinner
david@fromorbit.com
