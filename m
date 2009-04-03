From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 3 Apr 2009 11:24:50 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbZDCS1X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 14:27:23 -0400
In-Reply-To: <1238742067-30814-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 3 Apr 2009, Theodore Ts'o wrote:
> 
> Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes

Thanks, pulled. I'll be interested to see how it feels. Will report back 
after I've rebuild and gone through a few more emails.

One thing I started wondering about in your changes to start using 
WRITE_SYNC is that I'm getting closer to thinking that we did the whole 
WRITE-vs-WRITE_SYNC thing the wrong way around.

Now, it's clearly true that non-synchronous writes are hopefully always 
the common case, so in that sense it makes sense to think of "WRITE" as 
the default non-critical case, and then make the (fewer) WRITE_SYNC cases 
be the special case.

But at the same time, I now suspect that we could actually have solved 
this problem more easily by just doing things the other way around: make 
the default "WRITE" be the high-priority one (to match "READ"), and then 
just explicitly marking the data writes with "WRITE_ASYNC".

Why? Because I think that with all the writes sprinkled around in random 
places, it's probably _easier_ to find the bulk writes that cause the 
biggest issues, and just fix _those_ to be WRITE_ASYNC. They may be bulk, 
they may be the common case, but they also tend to be the case where we 
write with generic routines (eg the whole "do_writepages()" thing).

So the VFS layer tends to already do much of the bulk writeout, and maybe 
we would have been better off just changing those to ASYNC and leaving any 
more specialized cases as the SYNC case? That would have avoided a lot of 
this effort at the filesystem level. We'd just assume that the default 
filesystem-specific writes tend to all be SYNC.

Comments?

		Linus
