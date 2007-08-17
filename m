From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 17 Aug 2007 22:42:47 +0400
Message-ID: <46C5EC27.9060003@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>	<20070427013350.d0d7ac38.akpm@linux-foundation.org>	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>	<20070427193130.GD5967@schatzie.adilger.int>	<20070427151837.f1439639.akpm@linux-foundation.org>	<463A1E02.8020506@clusterfs.com>	<20070503165428.855eb7d7.akpm@linux-foundation.org>	<463AD024.6060208@clusterfs.com>	<20070503233804.9dace4a7.akpm@linux-foundation.org>	<463AD948.9090103@clusterfs.com>	<20070504001802.0e86e9dd.akpm@linux-foundation.org>	<463AE32A.5000902@clusterfs.com>	<20070504010212.ce6eca53.akpm@linux-foundation.org>	<46C49556.4000409@clusterfs.com>	<20070816114605.5a233c7e.akpm@linux-foundation.org>	<46C506EF.5010408@clusterfs.com>	<200708162
 35250.d1e39b79.akpm@linux-foundation.org>	<46C55E10.900@clusterfs.com> <20070817020253.ed331f36.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.244.250]:33564 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbXHQSnQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2007 14:43:16 -0400
In-Reply-To: <20070817020253.ed331f36.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
>> OTOH, the faster we go through data sync part of commit, the better. given
>> that lots of inodes can be dirty with no data to sync, it's going to take
>> long in some cases. it's especially bad because commit doesn't scale to many
>> CPUs.
> 
> eh?

I mean that number inodes to scan can be order of magnitude larger than number
of inodes needing sync for this given transaction. commit thread has to scan them
all (quite amount of CPU, i guess) and we can't use >1 CPU to speed the scan up.

>> also, why would we need to flush *everything* every 5s? just because ext3 does
>> this? sounds strange. if somebody really need this we could add this possibility
>> to regular writeback path (making it tunable). but I'd rather prefer to have
>> a separate (fast, lightweight, scalable) mechanism to support data=ordered.
>>
> 
> Yeah, that would make sense, perhaps.
> 
> Or just speed the existing stuff up.  iirc the main problem in there is unrelated
> to data writeback.  There are situations where the running transaction has to block
> behind metadata writeout which the committing transaction is performing.  I
> reluctantly put that in years ago to get us out of a tight spot and it
> never got optimised.

AFAIU, existing writeback is built around dirty inodes list and dirty bit in
per-inode radix tree. in order to avoid scanning too much (see before) we'd
need a separate list and probably one more bit in radix tree. plus some code
to allow writeback to use new list/tag.

as for the main problem ... I'd very appreciate any details. probably it was
about several blocks in page when one block is allocated in transaction 1 and
next block is being allocated in transaction 2?

thanks, Alex
