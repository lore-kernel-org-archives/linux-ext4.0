From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 1/3] e4defrag: output blocks per extent by -c option
Date: Thu, 01 Oct 2009 17:15:37 +0900
Message-ID: <4AC46529.4040605@sx.jp.nec.com>
References: <4AC306B0.9070308@sx.jp.nec.com> <87f94c370909301128w4bfe6f4bh80bf3d6540ed83d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61671 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbZJAIRN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 04:17:13 -0400
In-Reply-To: <87f94c370909301128w4bfe6f4bh80bf3d6540ed83d3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/01 3:28, Greg Freemyer wrote::
> 2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
>> e4defrag with -c option outputs "ratio" that means the levels of
>> fragmentation. However, it's difficult for users to understand, so we will
>> use blocks per extent instead of ratio.
>>
>> Before:
>> # e4defrag -c /mnt/mp1/file
>> <File>                                         now/best          ratio
>> /mnt/mp1/file                                   14/1             0.01%
>>
>>  Total/best extents                             14/1
>>  Fragmentation ratio                            0.01%
>>  Fragmentation score                            0.10
>>  [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
>>  This file(/mnt/mp1/file) does not need defragmentation.
>>  Done.
>>
>> After:
>> # e4defrag -c /mnt/mp1/file
>> <File>                                         now/best        blk/ext
>> /mnt/mp1/file                                   14/1              7142
>>
>>  Total/best extents                             14/1
>>  Average blocks per extent                      7142
>>  Fragmentation score                            0
>>  [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
>>  This file(/mnt/mp1/file) does not need defragmentation.
>>  Done.
> 
> RFC
> 
> If we are going go that far (which I like), how about adding the avg
> extent size in bytes.  (ie. 7142 * blocksize I assume).
> 
> Also a note about the max blocks / extent might be good.
> 
> ie. Add a more or less hard coded line
> Ext4 max blocks per extent     32,768  (128MiB)

Your ideas sound good. How about the following output image?

# e4defrag -c /mnt/mp1/file
<File>                                         now/best         KB/ext
/mnt/mp1/file                                   14/1              4000

 Total/best extents                             14/1
 Min bytes per extent                           1024 KB
 Max bytes per extent                           20489 KB
 Average bytes per extent                       4000 KB
 Fragmentation score                            0
 [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
 This file(/mnt/mp1/file) does not need defragmentation.
 Done.

Regards,

Kazuya Mio
