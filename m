From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Minimizing fragmentation in ext4, fallocate not enough?
Date: Mon, 27 Sep 2010 16:16:28 -0500
Message-ID: <4CA109AC.60408@redhat.com>
References: <4C9D3CD6.9080000@mozilla.com> <7A56949B-99B6-439F-A015-1C0398A8B525@dilger.ca> <4C9E30B7.1050607@redhat.com> <4CA1085C.5090206@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Taras Glek <tglek@mozilla.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab0I0VQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 17:16:35 -0400
In-Reply-To: <4CA1085C.5090206@mozilla.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Taras Glek wrote:
> On 09/25/2010 10:26 AM, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> On 2010-09-24, at 18:05, Taras Glek wrote:
>>>> I noticed that several random IO-heavy Firefox files got fragmented
>>>> easily. Our cache suffers most. The cache works by creating a flat
>>>> file and storing fixed-size entries in it. I though if I
>>>> fallocate() the file first, then all of the writes within the
>>>> allocated area would not cause additional fragmentation.
>>>>
>>>> This doesn't seem to completely cure fragmentation with ext4 in
>>>> 2.6.33. If I allocate a 4mb file, it gets more and more fragmented
>>>> over time. fallocate() does reduce fragmentation, but not as much
>>>> as I expected.
>>> Have you checked filefrag immediately after fallocating the file?  Is
>>> it OK?
>>>
>>> It may be that the issue is that an fallocate()'d file is using
>>> "unwritten extents" and converting these extents to "normal" extents
>>> may cause apparent fragmentation.  However, depending on which
>>> version of e2fsprogs/filefrag you are using, it may well be that
>>> these extents only appear to be fragmented due to the different
>>> extent types.
>> Agreed, please include filefrag (-v) output right after it's fallocated,
>> and also when you see this fragmentation, and then we'll have a better
>> idea
>> about what you're seeing.  And, the newer the filefrag the better.  :)
> Thanks for clarification. Turns out ext4 is performing as expected,
> nevermind my previous message.
> 
> I was confused by discrepancy  in number of extents reported by filefrag
> 1.41.10 with/without -v flag.

:) yeah, that's an odd discrepancy, I guess...

I think filefrag needs to decide what it means by "number of extents"
found, and stick to it.  For ext3 it merges in contiguous metadata,
for ext4 it doesn't count adjacent extents as separate, etc...
it does get confusing.

Anyway, glad that what you're actually seeing on disk is pretty
much what's expected.  :)  I am a little surprised that we are
leaving those little interspersed unwritten extents though, bits
of the code try to extend the conversion to avoid that, I thought.

-Eric

> filefrag _CACHE_003_
> _CACHE_003_: 17 extents found
> filefrag -v _CACHE_003_
> Filesystem type is: ef53
> File size of _CACHE_003_ is 4194304 (1024 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0   232448             128
>    1     128   232576               1 unwritten
>    2     129   232577              95
>    3     224   232672               1 unwritten
>    4     225   232673              31
>    5     256   232704               1 unwritten
>    6     257   232705              63
>    7     320   232768               1 unwritten
>    8     321   232769              95
>    9     416   232864               1 unwritten
>   10     417   232865             255
>   11     672   233120               1 unwritten
>   12     673   233121             191
>   13     864   233312               1 unwritten
>   14     865   233313             127
>   15     992   233440               3
>   16     995   233443              29 unwritten,eof
> _CACHE_003_: 1 extent found
> 
> Thanks,
> Taras

