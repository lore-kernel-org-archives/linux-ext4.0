From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: Ext4 kernel patches ready for benchmarking
Date: Sun, 13 Mar 2011 23:04:27 -0400
Message-ID: <4D7D85BB.20503@hp.com>
References: <E1PuaLr-0001dQ-Hr@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35206 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1CNDEa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Mar 2011 23:04:30 -0400
In-Reply-To: <E1PuaLr-0001dQ-Hr@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/01/2011 07:55 PM, Theodore Ts'o wrote:
> Hi Eric (and the rest of the ext4 development team),
>
> I still have some ext4 patches to merge, but all or most of the ones
> that should affect performance are in the ext4 tree now.  You can get
> them via
>
>     git fetch git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git \
> 		for-enw-benchmark
>
> This patch series is based off of 2.6.38-rc5, plus one fixup commit,
> 3abb17e82f: "vfs: fix BUG_ON() in fs/namei.c:1461", which shouldn't be
> performance relevant (FFSB doesn't use symlinks, which is probably why
> you haven't noticed any problems).
>
> This patch series has passed a large number of xfstests runs using 4k
> and 1k block sizes.  I am currently using this patch set merged with
> 2.6.38-rc7 on my laptop, and it "feels" faster, but could be becauses of
> other optimizations and improvements that went in post-2.6.38, and it
> could be because I've enabled CONFIG_SCHED_AUTOGROUP, not just the ext4
> improvements :-)  --- although commit b616844 could very well help
> synchronous write workloads.
>

<snip>

Hi Ted:

My test results for this patch series are now available for review at:
http://free.linux.hp.com/~enw/ext4/2.6.38-rc5

For this set of runs, I've also tried reworking my old system 
utilization graphs to better reflect per transaction efficiency ("CPU 
Cost").

Thanks for the patches!
Eric
