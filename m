From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Thu, 31 Jul 2014 11:27:10 -0400
Message-ID: <20140731152710.GC1566@thunk.org>
References: <20140707211349.GA12478@kvack.org>
 <20140708001655.GI8254@thunk.org>
 <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca>
 <20140730144928.GA10295@kvack.org>
 <20140731130332.GB1566@thunk.org>
 <20140731140434.GE10295@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38520 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaGaP1O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 11:27:14 -0400
Content-Disposition: inline
In-Reply-To: <20140731140434.GE10295@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2014 at 10:04:34AM -0400, Benjamin LaHaise wrote:
> 
> I'm kvetching mostly because the mballoc code is hugely complicated and 
> easy to break (and oh have I broken it).  If you can point me in the right 
> direction for possible improvements that you think might improve mballoc, 
> I'll certainly give them a try.  Hopefully the above descriptions of the 
> workload make it a bit easier to understand what's going on in the big 
> picture.

Yes, the mballoc code is hugely complicated.  A lot of this was
because there are a lot of special case hacks added over the years to
fix various corner cases that have showed up.  In particular, some of
the magic in normalize_request is probably there for Lustre, and it
gives *me* headaches.

One of the things which is clearly impacting you is that you need fast
failover, where as for most of us, we're either (a) not trying to use
large file systems (whenever possible I recommend the use of single
disk file systems), or (b) we are less worried about what happens
immediately after the file system is mounted, and more about the
steady state.

> I also don't think this problem is limited to my particular use-case.  
> Any ext4 filesystem that is 7TB or more and gets up into the 80-90% 
> utilization will probably start exhibiting this problem.  I do wonder if 
> it is at all possible to fix this issue without replacing the bitmaps used 
> to track free space with something better suited to the task on such large 
> filesystems.  Pulling in hundreds of megabytes of bitmap blocks is always 
> going to hurt.  Fixing that would mean either compressing the bitmaps into 
> something that can be read more quickly, or wholesale replacement of the 
> bitmaps with something else.

Yes, it may be that the only solution, if you really want to stick
with ext4, is to architect using some kind of extent-based tracking
system for block allocation.  I wouldn't be horribly against that,
since the nice thing about block allocation is that if we lose the
extent tree, we can always regenerate the information very easily as
part of e2fsck pass 5.  So moving to a tree-based allocation tracking
system is much easier from a file system recovery perspective than,
say, going to a fully dynamic inode table.

So if someone were willing to do the engineering work, I wouldn't be
opposed to having that be added to ext4.

I do have to ask, though, that while I always like to see more people
using ext4, and I love to have more people contributing to ext4, have
you considered using some other file system?  It might be that
something like xfs is a much closer match to your requirements?  Or
perhaps more radically, have you considered going to some cluster file
system, not from size perspective (7TB is very cute from a cluster fs
perspective), but from a reliability and robustness against server
failure perspective.

Cheers,

						- Ted
