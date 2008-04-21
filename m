From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 09:54:07 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbYDUQzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 12:55:33 -0400
In-Reply-To: <200804211812.16994.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 21 Apr 2008, Rafael J. Wysocki wrote:
> 
> Well, it seems that the oops is actually known from -mm:
> 
> http://lkml.org/lkml/2008/4/21/55
> 
> and something similar was observed with 2.6.25-rc8-mm2.

Hmm. Sadly, I doubt that really cuts down the suspect list very much. Most 
of what has been merged since 2.6.25 has been in -mm, so while I agree 
that it looks very similar, the fact that it was possibly already in 
-rc8-mm2 doesn't much _help_.

And in fact, those oopses in rc8-mm2 don't look _that_ similar. Those are 
a corrupt f_mapping structure, it looks like (ie it looks like either 
"struct address_space" or a "struct filp" rather than a "struct dentry").

What is interesting about Jiri's version of the bug is that he has another 
value for the corruption than you do: you had either all-ones, or a value 
that *looked* like possibly a single nybble got cleared.

Jiri, in contrast, has a value of 00f0000000000000. Which is a bit 
interesting in that it's again a *nybble* that looks corrupt, but it's a 
different one.

But assuming Jiri's two oopses are related (which is not entirely 
unlikely), and assuming that this is a SLUB bucket re-use, then it's quite 
likely that the reason that his -rc8-mm2 oops looks different just because 
it was yet _another_ allocation that was in the same bucket. If so, the 
most likely one is "struct filp", because it has the right size: for me a 
filp is in the 192-byte bucket, which is very close to the 208-byte bucket 
of dentry.

So I could imagine that some config option or other change just changed 
the sizes around so that the two types ended up in different buckets in 
rc8-mm2 and in 2.6.25-mm1 (ie neither the dentry nor the filp necessarily 
changed sizes, but the *corrupting* type perhaps did?)

What I find interesting is that at least for me, I have the SLAB bucket 
size for nf_conntrack_expect being 208 bytes. And the *biggest* merge by 
far after 2.6.25 so far has been networking (and conntrack in particular)

Is that a smoking gun? Not necessarily. But it *is* intriguing. But there 
are other possible clashes (the 192-byte bucket has several different 
suspects, and not all of them are in networking).1

Jiri and Davem added to the Cc.

Jiri - could you also confirm whether you are usign SLUB (which is not 
necessarily at all indicative of a SLUB bug itself - it's just that SLAB 
won't ever even merge different allocations of the same size into the same 
buckets, so if it's a cross-slab corruption, you'd simply never see it 
with SLAB).

And if you are, can you please enable SLUB_DEBUG, and add a "slub_debug" 
to your kernel command line to enable all the debugging? That would 
hopefully catch any obvious use-after-free corruption.

I'm just whistling in the dark here, but it does seem worth pursuing this 
approach. The VFS layer has not changed *at*all* since 2.6.25, so I 
seriously doubt it's a dentry or filp bug - I think the corruption is 
external. And while networking is certainly not the only suspect (the x86 
architecture changes are pretty extensive too), the allocation size thing 
certainly makes it intriguing.

			Linus
