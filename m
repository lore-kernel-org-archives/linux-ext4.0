From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
 by fsync
Date: Tue, 30 Nov 2010 08:58:02 -0500
Message-ID: <4CF502EA.20403@redhat.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130113906.176ffcad@notabene.brown> <4CF4FFE1.9060507@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb@suse.de>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Josef Bacik <josef@redhat.com>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0K3N4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 08:56:30 -0500
In-Reply-To: <4CF4FFE1.9060507@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/30/2010 08:45 AM, Tejun Heo wrote:
> Hello,
>
> On 11/30/2010 01:39 AM, Neil Brown wrote:
>> I haven't seen any of the preceding discussion do I might be missing
>> something important, but this seems needlessly complex and intrusive.
>> In particular, I don't like adding code to md to propagate these timings up
>> to the fs, and I don't the arbitrary '2ms' number.
>>
>> Would it not be sufficient to simply gather flushes while a flush is pending.
>> i.e
>>    - if no flush is pending, set the 'flush pending' flag, submit a flush,
>>      then clear the flag.
>>    - if a flush is pending, then wait for it to complete, and then submit a
>>      single flush on behalf of all pending flushes.
> Heh, I was about to suggest exactly the same thing.  Unless the delay
> is gonna be multiple times longer than avg flush time, I don't think
> the difference between the above scheme and the one w/ preemptive
> delay would be anything significant especially now that the cost of
> flush is much lower.  Also, as Neil pointed out in another message,
> the above scheme will result in lower latency for flushes issued while
> no flush is in progress.
>
> IMO, this kind of optimization is gonna make noticeable difference
> only when there are a lot of simulatenous fsyncs, in which case the
> above would behave in mostly identical way with the more elaborate
> timer based one anyway.
>
> Thanks.
>

When we played with this in ext3/4, it was important to not wait when doing 
single threaded fsync's (a pretty common case) since that would just make them 
slower.

Also, the wait time for multi-threaded fsync's should be capped at some fraction 
of the time to complete a flush. For example, we had ATA_CACHE_FLUSH_EXT 
commands that took say 16ms or so to flush and waited one jiffie (4ms) and that 
worked well. It tanked when we used that fixed waiting time for a high speed 
device that could execute a flush in say 1ms (meaning we waited 4 times as long 
as it would have taken to just submit the fsync().

I am still not clear that the scheme that you and Neil are proposing would 
really batch up enough flushes to help though since you effectively do not wait.

The workload that we used years back was single threaded fs_mark (small files), 
2 threads, 4 threads, 8 threads, 16 threads.

Single threaded should show no slow down with various schemes showing 
multi-threaded writes grow with the number threads to some point....

Ric

