From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Tue, 16 Dec 2008 21:16:40 +0100
Message-ID: <20081216201640.GA13555@elte.hu>
References: <4936D287.6090206@cosmosbay.com> <493F4EF4.4080205@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org> <200812152323.53592.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:57334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbYLPURT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2008 15:17:19 -0500
Content-Disposition: inline
In-Reply-To: <200812152323.53592.rusty@rustcorp.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 10 December 2008 16:19:21 Andrew Morton wrote:
> > Rusty, Christoph: talk to me.  If we add a new user of local_t in core
> > kernel, will we regret it?
> 
> Interesting.  There's new local_t infrastructure, but it's not used.
> 
> Here's a benchmark patch showing some results.  x86 is pretty close to
> optimal already, though my results on Power show atomic_long is a bad choice
> there.
> 
> I'll do an audit of the users, then send out some local_t cleanup patches etc.
> 
> Benchmarks for local_t variants
> 
> (This patch also fixes the x86 cpu_local_* macros, which are obviously
> unused).
> 
> I chose a large array (1M longs) for the inc/add/add_return tests so
> the trivalue case would show some cache pressure.
> 
> The cpu_local_inc case is always cache-hot, so it's not comparable to
> the others.
> 
> Time in ns per iteration (brackets is with CONFIG_PREEMPT=y):
> 
> 		inc	add	add_return	cpu_local_inc	read
> x86-32: 2.13 Ghz Core Duo 2
> atomic_long	118	118	115		17		17
> irqsave/rest	77	78	77		23		16
> trivalue	45	45	127		3(6)		21
> local_t		36	36	36		1(5)		17
> 
> x86-64: 2.6 GHz Dual-Core AMD Opteron 2218
> atomic_long	55	60	-		6		19
> irqsave/rest	54	54	-		11		19
> trivalue	47	47	-		5		28
> local_t		47	46	-		1		19

coolness!

> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/include/asm/local.h |   20 ++--
>  init/main.c                  |  198 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 208 insertions(+), 10 deletions(-)

it's a gem - but init/main.c is an arguably pretty sucky place for it. 
Stick it somewhere in lib/*, to be moved into testing/* later on?

	Ingo
