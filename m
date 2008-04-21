From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 10:43:11 -0700
Message-ID: <20080421174311.GE9153@linux.vnet.ibm.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org> <20080421170526.GC9153@linux.vnet.ibm.com> <alpine.LFD.1.10.0804211023090.2779@woody.linux-foundation.org>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58570 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYDURnO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 13:43:14 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804211023090.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 10:30:19AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 21 Apr 2008, Paul E. McKenney wrote:
> > 
> > I did take a quick look for improperly freeing dentries -- unhashed
> > dentries are freed directly, so if there is a code path that somehow
> > unhashes dentries and then d_free()s them without a grace period, we
> > have a problem.
> 
> No, not even then.
> 
> We *always* unhash the dentries before freeing them, but we very 
> consciously use "hlist_del_rcu()" on them, not "hlist_del_init()".
> 
> That, in turn, will mean that the "pprev" pointer will still be set, so 
> the "hlist_unhashed()" thing will *not* trigger.
> 
> IOW, when we do that direct-free with:
> 
> 	if (hlist_unhashed(&dentry->d_hash))
> 		__d_free(dentry);
> 
> the "hlist_unhashed()" will literally guarantee that i has *never* been on 
> a hash-list at all!

Got it, hlist_del_rcu() sets ->pprev to LIST_POISON2, which is non-NULL,
so the dentry still gets to wait for a grace period.  Color me blind!!!

> (If you want to test whether it is currently unhashed or not, you actually 
> have to use "d_unhashed()" on the dentry under the dentry lock, which 
> tests the DCACHE_UNHASHED bit).

And as it looks like you guessed, I was misreading the hlist_unhashed()
above as d_unhashed().  :-/

							Thanx, Paul

> Of course, there could be some bug in there, but the thing is, none of 
> this has even changed in a long time, certainly not since 2.6.25. Which is 
> why I think the dcache code is all fine, and the bug comes from somewhere 
> else corrupting the data structures.
> 
> 		Linus
