From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_fallocate
Date: Thu, 28 Jun 2012 07:27:38 -0400
Message-ID: <4FEC3FAA.1060503@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ric Wheeler <ricwheeler@gmail.com>,
	Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab2F1L1v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 07:27:51 -0400
In-Reply-To: <4FEB9115.6090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/27/2012 07:02 PM, Eric Sandeen wrote:
> On 6/27/12 3:30 PM, Theodore Ts'o wrote:
>> On Tue, Jun 26, 2012 at 04:44:08PM -0400, Eric Sandeen wrote:
>>>> I tried running this fio recipe on v3.3, which I think does a decent job of
>>>> emulating the situation (fallocate 1G, do random 1M writes into it, with
>>>> fsyncs after each):
>>>>
>>>> [test]
>>>> filename=testfile
>>>> rw=randwrite
>>>> size=1g
>>>> filesize=1g
>>>> bs=1024k
>>>> ioengine=sync
>>>> fallocate=1
>>>> fsync=1
>> A better workload would be to use a blocksize of 4k.  By using a
>> blocksize of 1024k, it's not surprising that the metadata overhead is
>> in the noise.
>>
>> Try something like this; this will cause the extent tree overhead to
>> be roughly equal to the data block I/O.
>>
>> [global]
>> rw=randwrite
>> size=128m
>> filesize=1g
>> bs=4k
>> ioengine=sync
>> fallocate=1
>> fsync=1
>>
>> [thread1]
>> filename=testfile
> Well, ok ... TBH I changed it to size=16m to finish in under 20m.... so here are the results:
>
> fallocate 1g, do 16m of 4k random IOs, sync after each:
>
> # for I in a b c; do rm -f testfile; echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
>
>    WRITE: io=16384KB, aggrb=154KB/s, minb=158KB/s, maxb=158KB/s, mint=105989msec, maxt=105989msec
>    WRITE: io=16384KB, aggrb=163KB/s, minb=167KB/s, maxb=167KB/s, mint=99906msec, maxt=99906msec
>    WRITE: io=16384KB, aggrb=176KB/s, minb=180KB/s, maxb=180KB/s, mint=92791msec, maxt=92791msec
>
> same, but overwrite pre-written 1g file (same as the expose-my-data option ;)
>
> # dd if=/dev/zero of=testfile bs=1M count=1024
> # for I in a b c; do echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
>
>    WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99515msec, maxt=99515msec
>    WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99371msec, maxt=99371msec
>    WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99677msec, maxt=99677msec
>
> so no great surprise, small synchronous 4k writes have terrible performance, but I'm still not seeing a lot of fallocate overhead.
>
> xfs, FWIW:
>
> # for I in a b c; do rm -f testfile; echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
>
>    WRITE: io=16384KB, aggrb=202KB/s, minb=207KB/s, maxb=207KB/s, mint=80980msec, maxt=80980msec
>    WRITE: io=16384KB, aggrb=203KB/s, minb=208KB/s, maxb=208KB/s, mint=80508msec, maxt=80508msec
>    WRITE: io=16384KB, aggrb=204KB/s, minb=208KB/s, maxb=208KB/s, mint=80291msec, maxt=80291msec
>
> # dd if=/dev/zero of=testfile bs=1M count=1024
> # for I in a b c; do echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
>
>    WRITE: io=16384KB, aggrb=197KB/s, minb=202KB/s, maxb=202KB/s, mint=82869msec, maxt=82869msec
>    WRITE: io=16384KB, aggrb=203KB/s, minb=208KB/s, maxb=208KB/s, mint=80348msec, maxt=80348msec
>    WRITE: io=16384KB, aggrb=202KB/s, minb=207KB/s, maxb=207KB/s, mint=80827msec, maxt=80827msec
>
> Again, I think this is just a diabolical workload ;)
>
> -Eric

We need to keep in mind what the goal of pre-allocation is (should be?) - spend 
a bit of extra time doing the allocation call so we get really good, contiguous 
layout on disk which ultimately will help in streaming read/write workloads.

If you have a reasonably small file, pre-allocation is probably simply a waste 
of time - you would be better off overwriting the maximum file size with all 
zeros (even a 1GB file would take only a few seconds).

If the file is large enough to be interesting, I think that we might want to 
think about a scheme that would bring small random IO's more into line with the 
1MB results Eric saw.

One way to do that might be to have a minimum "chunk" that we would zero out for 
any IO to an allocated but unwritten extent. You write 4KB to the middle of said 
region, we pad up and zero out to the nearest MB with zeros.

Note for the target class of drives (S-ATA) that Ted mentioned earlier, doing a 
random 4KB write vs a 1MB write is not that much slower (you need to pay the 
head movement costs already).  Of course, the sweet spot might turn out to be a 
bit smaller or larger.

Ric


