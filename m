From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 19:06:44 +0200
Message-ID: <480CC9A4.9090503@gmail.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763145AbYDURHP@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/21/2008 06:54 PM, Linus Torvalds wrote:
> Jiri - could you also confirm whether you are usign SLUB (which is not 
> necessarily at all indicative of a SLUB bug itself - it's just that SLAB 
> won't ever even merge different allocations of the same size into the same 
> buckets, so if it's a cross-slab corruption, you'd simply never see it 
> with SLAB).

Yeah, I'm using slub. Going to boot to slub_debug.

Thanks so far.

BTW. I haven't see this without suspend/resume cycle, do you, Rafael? It doesn't 
mean anything, since it needs longer time to trigger, but anyway, it might be a 
clue.
