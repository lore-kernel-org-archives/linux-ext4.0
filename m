From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, take2] percpu_counter: FBC_BATCH might be too big
Date: Sun, 7 Dec 2008 20:32:44 -0800
Message-ID: <20081207203244.10372834.akpm@linux-foundation.org>
References: <4939513C.3090101@cosmosbay.com>
	<493B9699.8080603@cosmosbay.com>
	<20081207090918.595627b2.akpm@linux-foundation.org>
	<493C1632.2000901@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838AbYLHEdC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 23:33:02 -0500
In-Reply-To: <493C1632.2000901@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 07 Dec 2008 19:30:10 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> > 
> > Do
> > 
> > 	$EDITOR  $(grep -l hotcpu_notifier */*.c)
> > 
> > and you'll see lots of code gets it right, and lots of code gets it wrong.
> 
> I see nothing interesting, I must be blind.
> 
> lib/percpu_counter.c: In function 'percpu_counter_startup':
> lib/percpu_counter.c:158: error: 'percpu_counter_hotcpu_callback' undeclared (first use in this function)
> lib/percpu_counter.c:158: error: (Each undeclared identifier is reported only once
> lib/percpu_counter.c:158: error: for each function it appears in.)
> make[1]: *** [lib/percpu_counter.o] Error 1

Perhaps you still had percpu_counter_hotcpu_callback inside #ifdef.

That a look at kernel/workqueue.c, fs/buffer.c.  No #ifdef CONFIG_HOTPLUG_CPU
needed at all.

