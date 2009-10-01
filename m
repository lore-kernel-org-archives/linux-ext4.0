From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Kernel BUG] ext4 for v2.6.32 round II
Date: Wed, 30 Sep 2009 18:57:00 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0909301847030.6996@localhost.localdomain>
References: <E1Msrgx-0001br-MP@closure.thunk.org> <20091001014128.GA2092@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390AbZJAB5m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 21:57:42 -0400
In-Reply-To: <20091001014128.GA2092@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 1 Oct 2009, Markus Trippelsdorf wrote:
> 
> Running latest git I get the following kernel BUG message:
> 
> ------------[ cut here ]------------
> Kernel BUG at ffffffff810efa89 [verbose debug info unavailable]

You really shouldn't turn off verbose debug info unless you are _really_ 
tight on memory in some embedded device. It's not that complex, nor does 
it use a lot of memory, and it makes the error report much harder to 
figure out when the verbose debug output information isn't available.

But in this case I can do it by just looking at the function/offset:

> RIP: 0010:[<ffffffff810efa89>]  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213

The only BUG_ON() that seems relevant in that function (at least with the 
config I tried with) ends up being

	fs/ext4/inode.c:1184

in my sources, which is from "page_buffers(page)", which has a

	BUG_ON(!PagePrivate(page));

in it. And that would have been much easier to figure out if you had had 
CONFIG_DEBUG_BUGVERBOSE enabled..

Now over to the ext4 people to actually hopefully _solve_ the bug. Maybe 
bisection would help.

		Linus
