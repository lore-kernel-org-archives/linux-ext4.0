From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: Re: Java Stop-the-World GC stall induced by FS flush or many large
 file deletions
Date: Thu, 12 Sep 2013 06:02:27 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA46E64D8C@ATLEXMBX4.ARRS.ARRISI.com>
References: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
 <C0F0BC787567C848B2C90989451123DA46E64D5D@ATLEXMBX4.ARRS.ARRISI.com>
 <CALQm4jj-4+Fu=1WkdzDuHH5friiWUBaaPFKkvX2VyAKM6D0JTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Cuong Tran <cuonghuutran@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It would lock-up one core whichever jdb/sdaX runs on. This will usually
happen upon commit that runs every x seconds, 5 by default (see =93comm=
it=94
mount option for ext4). I.e. deleting 5 files one by one with 1 second
interval in between is basically the same as deleting all of them =93at=
 once=94.

Yes, fallocated files are the same wrt releasing blocks.

Regards,
Andrei.

On 12.09.2013 01:45, Cuong Tran wrote:
> Awesome fix and thanks for very speedy response. I have some
> questions. We delete files one at a time, and thus that would lock up
> one core or all cores?
>
> And in our test, we use falloc w/o writing to file. That would still
> cause freeing block-by-block, correct?
> --Cuong
>
> On Wed, Sep 11, 2013 at 10:32 PM, Sidorov, Andrei
> <Andrei.Sidorov@arrisi.com> wrote:
>> Hi,
>>
>> Large file deletions are likely to lock cpu for seconds if you're
>> running non-preemptible kernel < 3.10.
>> Make sure you have this change:
>> http://patchwork.ozlabs.org/patch/232172/ (available in 3.10 if I
>> remember it right).
>> Turning on preemption may be a good idea as well.
>>
>> Regards,
>> Andrei.
>>
>> On 12.09.2013 00:18, Cuong Tran wrote:
>>> We have seen GC stalls that are NOT due to memory usage of applicat=
ions.
>>>
>>> GC log reports the CPU user and system time of GC threads, which ar=
e
>>> almost 0, and stop-the-world time, which can be multiple seconds. T=
his
>>> indicates GC threads are waiting for IO but GC threads should be
>>> CPU-bound in user mode.
>>>
>>> We could reproduce the problems using a simple Java program that ju=
st
>>> appends to a log file via log4j. If the test just runs by itself, i=
t
>>> does not incur any GC stalls. However, if we run a script that ente=
rs
>>> a loop to create multiple large file via falloc() and then deletes
>>> them, then GC stall of 1+ seconds can happen fairly predictably.
>>>
>>> We can also reproduce the problem by periodically switch the log an=
d
>>> gzip the older log. IO device, a single disk drive, is overloaded b=
y
>>> FS flush when this happens.
>>>
>>> Our guess is GC has to acquiesce its threads and if one of the thre=
ads
>>> is stuck in the kernel (say in non-interruptible mode). Then GC has=
 to
>>> wait until this thread unblocks. In the mean time, it already stops
>>> the world.
>>>
>>> Another test that shows similar problem is doing deferred writes to
>>> append a file. Latency of deferred writes is very fast but once a
>>> while, it can last more than 1 second.
>>>
>>> We would really appreciate if you could shed some light on possible
>>> causes? (Threads blocked because of journal check point, delayed
>>> allocation can't proceed?). We could alleviate the problem by
>>> configuring expire_centisecs and writeback_centisecs to flush more
>>> frequently, and thus even-out the workload to the disk drive. But w=
e
>>> would like to know if there  is a methodology to model the rate of
>>> flush vs. rate of changes and IO throughput of the drive (SAS, 15K
>>> RPM).
>>>
>>> Many thanks.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
