From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 18:53:17 -0500
Message-ID: <4C7C446D.6070602@redhat.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>	<20100830174000.GA6647@thunk.org>	<20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>	<4C7C1D04.1080205@redhat.com> <20100830194533.6d09c38b.bill@wizard.sci.gsfc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Bill Fink <billfink@mindspring.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: Bill Fink <bill@wizard.sci.gsfc.nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0H3Xx1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 19:53:27 -0400
In-Reply-To: <20100830194533.6d09c38b.bill@wizard.sci.gsfc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill Fink wrote:
> On Mon, 30 Aug 2010, Eric Sandeen wrote:
> 
>> Bill Fink wrote:
>>> On Mon, 30 Aug 2010, Ted Ts'o wrote:
>>>
>>>> On Sun, Aug 29, 2010 at 11:11:26PM -0400, Bill Fink wrote:
>>>>> A 50% ext4 disk write performance regression was introduced
>>>>> in 2.6.32 and still exists in 2.6.35, although somewhat improved
>>>>> from 2.6.32.  Read performance was not affected).
>>>> Thanks for reporting it.  I'm going to have to take a closer look at
>>>> why this makes a difference.  I'm going to guess though that what's
>>>> going on is that we're posting writes in such a way that they're no
>>>> longer aligned or ending at the end of a RAID5 stripe, causing a
>>>> read-modify-write pass.  That would easily explain the write
>>>> performance regression.
>>> I'm not sure I understand.  How could calling or not calling
>>> ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
>>> affect the write alignment?
>>>
>>> I was wondering if the locking being done in ext4_num_dirty_pages()
>>> could somehow be affecting the performance.  I did notice from top
>>> that in the patched 2.6.35 kernel, the I/O wait time was generally
>>> in the 60-65% range, while in the unpatched 2.6.35 kernel, it was
>>> at a higher 75-80% range.  However, I don't know if that's just a
>>> result of the lower performance, or a possible clue to its cause.
>> Using oprofile might also show you how much time is getting spent there..
>>
>>>> The interesting thing is that we don't actually do anything in
>>>> ext4_da_writepages() to assure that we are making our writes are
>>>> appropriate aligned and sized.  We do pay attention to make sure they
>>>> are alligned correctly in the allocator, but _not_ in the writepages
>>>> code.  So the fact that apparently things were well aligned in 2.6.32
>>>> seems to be luck... (or maybe the writes are perfectly aligned in
>>>> 2.6.32; they're just much worse with 2.6.35, and with explicit
>>>> attention paid to the RAID stripe size, we could do even better :-)
>>> It was 2.6.31 that was good.  The regression was in 2.6.32.  And again
>>> how does the write alignment get modified simply by whether or not
>>> ext4_num_dirty_pages() is called?
>> writeback is full of deep mysteries ... :)
>>
>>>> If you could run blktraces on 2.6.32, 2.6.35 stock, and 2.6.35 with
>>>> your patch, that would be really helpful to confirm my hypothesis.  Is
>>>> that something that wouldn't be too much trouble?
>>> I'd be glad to if you explain how one runs blktraces.
>> Probably the easiest thing to do is to use seekwatcher to invoke blktrace,
>> if it's easily available for your distro.  Then it's just mount debugfs on
>> /sys/kernel/debug, and:
>>
>> # seekwatcher -d /dev/whatever -t tracename -o tracename.png -p "your dd command"
>>
>> It'll leave tracename.* blktrace files, and generate a graph of the IO
>> in the PNG file.
>>
>> (this causes an abbreviated trace, but it's probably enough to see what
>> boundaries the IO was issued on)
> 
> Thanks for the info.  How would you like me to send the blktraces?
> Even using bzip2 they're 2.6 MB.  I could send them to you and Ted
> via private e-mail or I can hunt around and try and find somewhere
> I can post them.  I'm attaching the PNG files (2.6.35 is unpatched
> and 2.6.35+ is patched).

Private email is fine I think, I don't mind a 2.6MB attachment and doubt
Ted would either.  :)

I keep meaning to patch seekwatcher to color unaligned IOs differently,
but without that we need the blktrace data to know if that's what's going
on.

It's interesting that the patched run is starting at block 0 while
unpatched is starting futher in (which would be a little slower at least)

was there a fresh mkfs in between?

Thanks!

-Eric

