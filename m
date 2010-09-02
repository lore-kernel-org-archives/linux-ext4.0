From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and functions
Date: Thu, 02 Sep 2010 10:55:58 +0200
Message-ID: <877hj4o76p.fsf@basil.nowhere.org>
References: <4C7F3A2A.2000007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:51246 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0IBI4E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Sep 2010 04:56:04 -0400
In-Reply-To: <4C7F3A2A.2000007@cn.fujitsu.com> (Miao Xie's message of "Thu, 02
	Sep 2010 13:46:18 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Miao Xie <miaox@cn.fujitsu.com> writes:

> Changes from V1 to V2:
> - change the version of GPL from version 2.1 to version 2
>
> the kernel's memcpy and memmove is very inefficient. But the glibc version is
> quite fast, in some cases it is 10 times faster than the kernel version. So I


Can you elaborate on which CPUs and with what workloads you measured that?

The kernel memcpy is optimized for copies smaller than a page size 
for example (kernel very rarely does anything on larger than 4k), 
the glibc isn't. etc. There are various other differences.

memcpy and memmove are very different. AFAIK noone has tried
to optimize memmove() before because traditionally it wasn't
used for anything performance critical in the kernel. Has that
that changed? memcpy on the other hand while not perfect
is actually quite optimized for typical workloads.

One big difference between the kernel and glibc is that kernel 
is often cache cold, so you e.g. the cost of a very large code footprint
memcpy/memset is harder to amortize.

Microbenchmarks often leave out that crucial variable.

I have some systemtap scripts to measure size/alignment distributions of
copies on a kernel, if you have a particular workload you're interested
in those could be tried.

Just copying the glibc bloat uncritical is very likely
the wrong move at least.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
