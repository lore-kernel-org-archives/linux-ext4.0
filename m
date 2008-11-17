From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] ext2/ext3: allocate ->s_blockgroup_lock separately to
 avoid wasting space
Date: Mon, 17 Nov 2008 23:27:47 +0200
Message-ID: <4921E1D3.8040700@cs.helsinki.fi>
References: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI> <1226840289.8172.8.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cl@linux-foundation.org,
	mpm@selenic.com, eduard.munteanu@linux360.ro
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36636 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYKQVbk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 16:31:40 -0500
In-Reply-To: <1226840289.8172.8.camel@lappy.programming.kicks-ass.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Zijlstra wrote:
> On Fri, 2008-11-14 at 11:17 +0200, Pekka J Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes and ext3_sb_info is
>> 17152 bytes on 64-bit which makes them a very bad fit for SLAB allocators. In
>> fact, both allocations are round up to the next available page size of 
>> order 3 which is 32 KB.
>>
>> The culprit if the wasted memory is the ->s_blockgroup_lock which can be as big
>> as 16 KB when CONFIG_NR_CPUS is set to 32. As struct blockgroup_lock is a
>> perfect fit for order 2 page in the worst case, allocate ->s_blockgroup_lock
>> separately to avoid wasting space.
> 
> And here I was thinking that NR_CPUS=4096 is currently our worst
> case ;-)

Sure but look at <linux/blockgroup_lock.h>. NR_BG_LOCKS is capped to 128 
for >= 32 CPUs.
