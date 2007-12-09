From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc4-mm1: some issues on sparc64
Date: Sun, 09 Dec 2007 00:45:17 -0800 (PST)
Message-ID: <20071209.004517.201813773.davem@davemloft.net>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712081920.28748.m.kozlowski@tuxland.pl>
	<20071208102239.2457eeaa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20071208102239.2457eeaa.akpm@linux-foundation.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 8 Dec 2007 10:22:39 -0800

> That's
> 
>         J_ASSERT_BH(bh, !buffer_jbddirty(bh));
> 
> at the end of journal_unmap_buffer().
> 
> I don't recall seeing that before and I can't think of anything we've
> done recently which could cause it, sorry.

If the per-cpu data patches are in the -mm tree that is the first
place I would start looking at for possible cause.
