From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Kernel BUG] ext4 for v2.6.32 round II
Date: Thu, 1 Oct 2009 04:15:31 +0200
Message-ID: <20091001021531.GA2025@phenom2.trippelsdorf.de>
References: <E1Msrgx-0001br-MP@closure.thunk.org>
 <20091001014128.GA2092@phenom2.trippelsdorf.de>
 <alpine.LFD.2.01.0909301847030.6996@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-042.synserver.de ([212.40.180.42]:1090 "HELO
	smtp-out-042.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755441AbZJACP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 22:15:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909301847030.6996@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2009 at 06:57:00PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 Oct 2009, Markus Trippelsdorf wrote:
> > 
> > Running latest git I get the following kernel BUG message:
> > 
> > ------------[ cut here ]------------
> > Kernel BUG at ffffffff810efa89 [verbose debug info unavailable]
> 
> You really shouldn't turn off verbose debug info unless you are _really_ 
> tight on memory in some embedded device. It's not that complex, nor does 
> it use a lot of memory, and it makes the error report much harder to 
> figure out when the verbose debug output information isn't available.
> 
> But in this case I can do it by just looking at the function/offset:
> 
> > RIP: 0010:[<ffffffff810efa89>]  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213
> 
> The only BUG_ON() that seems relevant in that function (at least with the 
> config I tried with) ends up being
> 
> 	fs/ext4/inode.c:1184
> 
> in my sources, which is from "page_buffers(page)", which has a
> 
> 	BUG_ON(!PagePrivate(page));
> 
> in it. And that would have been much easier to figure out if you had had 
> CONFIG_DEBUG_BUGVERBOSE enabled..
> 

You're right (with CONFIG_DEBUG_BUGVERBOSE=y):

------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:1184!
...

> Now over to the ext4 people to actually hopefully _solve_ the bug. Maybe 
> bisection would help.

-- 
Markus
