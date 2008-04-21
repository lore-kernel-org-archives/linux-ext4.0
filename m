From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 09:06:17 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804210850100.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <20080421045911.GA1812@linux.vnet.ibm.com>
 <20080421054729.GA19864@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762606AbYDUQMo@vger.kernel.org>
In-Reply-To: <20080421054729.GA19864@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Sun, 20 Apr 2008, Paul E. McKenney wrote:
> 
> And it passes.

Ok, I applied it, with hopefully an understandable commit message.

That said, now we just need to figure out what actually caused the bug in 
question.

Rafael: if it's a too-early free of the dentry (which could be because 
somebody didn't do a proper rcu read-lock, or maybe the rcu grace period 
logic itself got broken?), then enabling SLUB/SLAB debugging should catch 
it much more quickly (and hopefully we'd see the signature of a 
use-after-free - the poisoning byte pattern rather than the -1).

The other alternative is simply memory corruption. Ie the -1 may well be 
somebody *else* overwritin the ->next pointer because they did a 
use-after-free and maybe the dentry_cache is shared with some other 
allocation of the same size (SLUB does that, no?)

Rafael: your last oops does seem to imply that there is some strange 
memory corruption going on, because in that case the invalid pointer is 
different: instead of being all-ones, it is "fff0810023444c98", which is 
not a possible pointer. It very much looks like a single nybble got 
cleared (because ffff810023444c98 _would_ be a valid pointer, notice the 
"fff0" vs "ffff" prefix).

So I do suspect it's *some* kind of use-after-free thing. But nothing in 
fs/ has changed, so it's not a dentry bug, I think. Which is why my 
"preferred" suspect is that "somebody else also does allocations of the 
same size as the dentry code, and shares the same SLUB alloc space, and 
does something bad".

So Rafael - are you using SLUB, and if you are, can you enable SLUB_DEBUG, 
and then use the "slub_debug" kernel command line to enable it?

			Linus
