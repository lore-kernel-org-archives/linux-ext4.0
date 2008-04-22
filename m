From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 09:03:04 +0800
Message-ID: <20080422010304.GA14994@gondor.apana.org.au>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39614 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757693AbYDVBDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 21:03:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 08:49:58AM -0700, Linus Torvalds wrote:
>
> That is *not* the main problem.
> 
> If you use "rcu_dereference()" on the wrong access, it not only loses the 
> "smp_read_barrier_depends()" (which is a no-op on all sane architectures 
> anyway), but it loses the ACCESS_ONCE() thing *entirely*.

Actually rcu_dereference didn't have ACCESS_ONCE when I did this.
That only appearaed later with the preemptible RCU work.

The original purpose of rcu_dereference was exactly to replace the
explicit barriers that people were using for RCU, nothing more,
nothing less.

Oh and I totally agree that the compiler is going to generate insane
code whenever ACCESS_ONCE is used.  In this case we may have avoided
it by rearranging the code, but in general the introduction of ACCESS_ONCE
in rcu_dereference is likely to have a negative impact on the code
generated.

Remember that "volatile" discussion? I think this is where it all came
from.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
