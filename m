From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/3] e4defrag: output blocks per extent by -c option
Date: Fri, 2 Oct 2009 11:28:56 -0400
Message-ID: <87f94c370910020828p2a21d52cu1451a80d6fdb8a34@mail.gmail.com>
References: <4AC306B0.9070308@sx.jp.nec.com>
	 <87f94c370909301128w4bfe6f4bh80bf3d6540ed83d3@mail.gmail.com>
	 <4AC46529.4040605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:25893 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZJBP2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 11:28:52 -0400
Received: by qw-out-2122.google.com with SMTP id 3so427631qwe.37
        for <linux-ext4@vger.kernel.org>; Fri, 02 Oct 2009 08:28:56 -0700 (PDT)
In-Reply-To: <4AC46529.4040605@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/1 Kazuya Mio <k-mio@sx.jp.nec.com>:
> 2009/10/01 3:28, Greg Freemyer wrote::
>> 2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
>>> e4defrag with -c option outputs "ratio" that means the levels of
>>> fragmentation. However, it's difficult for users to understand, so =
we will
>>> use blocks per extent instead of ratio.
>>>
>>> Before:
>>> # e4defrag -c /mnt/mp1/file
>>> <File> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 now/best =A0 =A0 =A0 =A0 =A0ratio
>>> /mnt/mp1/file =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 14/1 =A0 =A0 =A0 =A0 =A0 =A0 0.01%
>>>
>>> =A0Total/best extents =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 14/1
>>> =A0Fragmentation ratio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00.01%
>>> =A0Fragmentation score =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00.10
>>> =A0[0-30 no problem: 31-55 a little bit fragmented: 55- needs defra=
g]
>>> =A0This file(/mnt/mp1/file) does not need defragmentation.
>>> =A0Done.
>>>
>>> After:
>>> # e4defrag -c /mnt/mp1/file
>>> <File> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 now/best =A0 =A0 =A0 =A0blk/ext
>>> /mnt/mp1/file =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 14/1 =A0 =A0 =A0 =A0 =A0 =A0 =A07142
>>>
>>> =A0Total/best extents =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 14/1
>>> =A0Average blocks per extent =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A07142
>>> =A0Fragmentation score =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00
>>> =A0[0-30 no problem: 31-55 a little bit fragmented: 55- needs defra=
g]
>>> =A0This file(/mnt/mp1/file) does not need defragmentation.
>>> =A0Done.
>>
>> RFC
>>
>> If we are going go that far (which I like), how about adding the avg
>> extent size in bytes. =A0(ie. 7142 * blocksize I assume).
>>
>> Also a note about the max blocks / extent might be good.
>>
>> ie. Add a more or less hard coded line
>> Ext4 max blocks per extent =A0 =A0 32,768 =A0(128MiB)
>
> Your ideas sound good. How about the following output image?
>
> # e4defrag -c /mnt/mp1/file
> <File> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 now/best =A0 =A0 =A0 =A0 KB/ext
> /mnt/mp1/file =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 14/1 =A0 =A0 =A0 =A0 =A0 =A0 =A04000
>
> =A0Total/best extents =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 14/1
> =A0Min bytes per extent =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 1024 KB
> =A0Max bytes per extent =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 20489 KB
> =A0Average bytes per extent =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 4000 KB
> =A0Fragmentation score =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00
> =A0[0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
> =A0This file(/mnt/mp1/file) does not need defragmentation.
> =A0Done.
>
> Regards,
>
> Kazuya Mio

I was thinking more of the theoretical max bytes per extent, not the
largest extent found in the actual file.

I say this because most users of e4defrag won't know what perfection
is, so they won't know if and when they have come close if they don't
know what the ultimate goal is.

Specifically, think of a admin hosting a few virtual machines where
the virtual disks are ext4 files.  They could easily be 100's of GB so
they may think even 128MB / extent can be improved on, even though
they have already achieved the theoretical max.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
