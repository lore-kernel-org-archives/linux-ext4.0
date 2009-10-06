From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 1/3] e4defrag: output blocks per extent by -c option
Date: Tue, 06 Oct 2009 14:27:50 +0900
Message-ID: <4ACAD556.8060501@sx.jp.nec.com>
References: <4AC306B0.9070308@sx.jp.nec.com>	 <87f94c370909301128w4bfe6f4bh80bf3d6540ed83d3@mail.gmail.com>	 <4AC46529.4040605@sx.jp.nec.com> <87f94c370910020828p2a21d52cu1451a80d6fdb8a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43577 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZJFF35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Oct 2009 01:29:57 -0400
In-Reply-To: <87f94c370910020828p2a21d52cu1451a80d6fdb8a34@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/03 0:28, Greg Freemyer wrote::
> 2009/10/1 Kazuya Mio <k-mio@sx.jp.nec.com>:
>> 2009/10/01 3:28, Greg Freemyer wrote::
>>> 2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
>>>> e4defrag with -c option outputs "ratio" that means the levels of
>>>> fragmentation. However, it's difficult for users to understand, so we will
>>>> use blocks per extent instead of ratio.
>>>>
>>>> Before:
>>>> # e4defrag -c /mnt/mp1/file
>>>> <File>                                         now/best          ratio
>>>> /mnt/mp1/file                                   14/1             0.01%
>>>>
>>>>  Total/best extents                             14/1
>>>>  Fragmentation ratio                            0.01%
>>>>  Fragmentation score                            0.10
>>>>  [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
>>>>  This file(/mnt/mp1/file) does not need defragmentation.
>>>>  Done.
>>>>
>>>> After:
>>>> # e4defrag -c /mnt/mp1/file
>>>> <File>                                         now/best        blk/ext
>>>> /mnt/mp1/file                                   14/1              7142
>>>>
>>>>  Total/best extents                             14/1
>>>>  Average blocks per extent                      7142
>>>>  Fragmentation score                            0
>>>>  [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
>>>>  This file(/mnt/mp1/file) does not need defragmentation.
>>>>  Done.
>>> RFC
>>>
>>> If we are going go that far (which I like), how about adding the avg
>>> extent size in bytes.  (ie. 7142 * blocksize I assume).
>>>
>>> Also a note about the max blocks / extent might be good.
>>>
>>> ie. Add a more or less hard coded line
>>> Ext4 max blocks per extent     32,768  (128MiB)
>> Your ideas sound good. How about the following output image?
>>
>> # e4defrag -c /mnt/mp1/file
>> <File>                                         now/best         KB/ext
>> /mnt/mp1/file                                   14/1              4000
>>
>>  Total/best extents                             14/1
>>  Min bytes per extent                           1024 KB
>>  Max bytes per extent                           20489 KB
>>  Average bytes per extent                       4000 KB
>>  Fragmentation score                            0
>>  [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
>>  This file(/mnt/mp1/file) does not need defragmentation.
>>  Done.
>>
>> Regards,
>>
>> Kazuya Mio
> 
> I was thinking more of the theoretical max bytes per extent, not the
> largest extent found in the actual file.
> 
> I say this because most users of e4defrag won't know what perfection
> is, so they won't know if and when they have come close if they don't
> know what the ultimate goal is.
> 
> Specifically, think of a admin hosting a few virtual machines where
> the virtual disks are ext4 files.  They could easily be 100's of GB so
> they may think even 128MB / extent can be improved on, even though
> they have already achieved the theoretical max.
> 
> Greg

I see. But I think e4defrag doesn't always need to print logical max
bytes per extent. So, I will add it to e4defrag man page instead of
standard output. What do you think?

Regards,

Kazuya Mio
