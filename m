From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 18:12:15 +0200
Message-ID: <200804211812.16994.rjw@sisk.pl>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:35504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYDUQMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 12:12:00 -0400
In-Reply-To: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday, 20 of April 2008, Linus Torvalds wrote:
> 
> On Sun, 20 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > I've just got the following traces from 2.6.25-git2 on HP nx6325 (64-bit).
> > I think they are related to the hang I described yesterday:
> > 
> > [12844.066757] BUG: unable to handle kernel paging request at ffffffffffffffff
> 
> Something has added a dentry pointer that has the value -1 to the dentry 
> hash list. The access that oopses seems to be the
> 
> 	prefetch(pos->next)
> 
> which is part of hlist_for_each_entry_rcu(), where "pos" is -1.
> 
> I suspect it's an RCU error, ie somebody has released a dentry entry, and 
> free'd it without waiting for the RCU grace period.
> 
> Talking about RCU I also think that whoever did those "rcu_dereference()" 
> macros in <linux/list.h> was insane. It's totally pointless to do 
> "rcu_dereference()" on a local variable. It simply *cannot* make sense. 
> Herbert, Paul, you guys should look at it.
> 
> As far as I can tell, rcu_dereference() should _always_ be done when we 
> access the "next" pointer (except for when prefetching, where we simply 
> don't care).
> 
> Paul? Herbert? Totally untested patch appended.
> 
> NOTE! I do not expect this patch to matter for this oops. There's 
> something else going on there.

Well, it seems that the oops is actually known from -mm:

http://lkml.org/lkml/2008/4/21/55

and something similar was observed with 2.6.25-rc8-mm2.

Thanks,
Rafael
