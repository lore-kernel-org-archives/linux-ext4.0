From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fallocate creating fragmented files
Date: Wed, 30 Jan 2013 09:56:51 -0600
Message-ID: <510942C3.1070503@redhat.com>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com> <5108B833.6010004@redhat.com> <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Rob Mueller <robm@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3A3P4z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 10:56:55 -0500
In-Reply-To: <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/30/13 12:35 AM, Bron Gondwana wrote:
> On Wed, Jan 30, 2013, at 05:05 PM, Eric Sandeen wrote:
>> On 1/29/13 11:46 PM, Bron Gondwana wrote:
>>> Hi All,
>>>
>>> I'm trying to understand why my ext4 filesystem is creating highly fragmented files even though it's only just over 50% full.
>>
>> It's at least possible that freespace is very fragmented; you could try the "e2freefrag" command to see.
> 
> [brong@imap14 ~]$ e2freefrag /dev/md0
> Device: /dev/md0
> Blocksize: 1024 bytes
> Total blocks: 62522624
> Free blocks: 26483551 (42.4%)
> 
> Min. free extent: 1 KB 
> Max. free extent: 757 KB
> Avg. free extent: 14 KB
> Num. free extent: 1940838
> 
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>     1K...    2K-  :        538480        538480    2.03%
>     2K...    4K-  :        362189        870860    3.29%
>     4K...    8K-  :        321158       1681591    6.35%
>     8K...   16K-  :        268848       2934959   11.08%
>    16K...   32K-  :        210746       4697440   17.74%
>    32K...   64K-  :        151755       6738418   25.44%
>    64K...  128K-  :         63761       5512870   20.82%
>   128K...  256K-  :         20563       3552580   13.41%
>   256K...  512K-  :          3308       1047995    3.96%
>   512K... 1024K-  :            30         17615    0.07%

Ok, TBH I'd not certain why the allocator is doing just what it's doing.
There are quite a lot of larger-than-3-block free spaces. OTOH, it might be
trying for some kind of locality.

I think it'd take some digging into the allocator behavior; there may 
be tracepoints that'd help.

-Eric

>>> Now looking at the verbose output, we can see that there are many extents of just 3 or 4 blocks:
>>>
>>> [brong@imap14 conf]$ filefrag -v testfile | awk '{print $5}' | sort -n | uniq -c | head
>>>       2 
>>>       1 is
>>>       1 length
>>>       1 unwritten
>>>       6 3
>>>      10 4
>>>       6 5
>>>       5 6
>>>       3 7
>>>       1 8
>>
>> But longer extents too, right:
>>
>> $ filefrag -v testfile | awk '{print $5}' | sort -n | uniq -c | tail
>>       1 162
>>       1 164
>>       1 179
>>       1 188
>>       1 215
>>       1 231
>>       1 233
>>       1 255
>>       1 322
>>       1 357
>>
>>> Yet looking at the next file,
>>>
>>> [brong@imap14 conf]$ filefrag -v testfile2 | awk '{print $5}' | sort -n | uniq -c | tail
>>>       1 173
>>>       1 175
>>>       1 178
>>>       1 184
>>>       1 187
>>>       1 189
>>>       1 194
>>>       1 289
>>>       1 321
>>>       1 330
>>>
>>
>> and presumably shorter extents at the beginning?
> 
> Well, that's sorted.  Yes, there were shorter extents too.
> 
>> So it sounds like both files are a mix of long & short extents.
> 
> Definitely. 
> 
>>> There are multiple extents of hundreds of blocks in length.  Why weren't they used in allocating the first file?
>>
>> I'm not sure, offhand.  But just to be clear, while contiguous allocations are usually a nice side-effect of fallocate, nothing at all guarantees it.  It only guarantees that you'll have that space available for future writes.
> 
> Sure.  I was hoping it would help though!
> 
>> Still, it'd be interesting to figure out why the allocator is behaving this way.
>> It'd be interesting to see the freefrag info, the allocator might really be in scavenger mode.
> 
> What do you think from the output above.  Is that reasonable?  I'll check a more recently set-up machine.
> 
> [brong@imap30 ~]$ e2freefrag /dev/sdf1
> Device: /dev/sdf1
> Blocksize: 1024 bytes
> 
> Total blocks: 97124320
> Free blocks: 68429391 (70.5%)
> 
> Min. free extent: 1 KB 
> Max. free extent: 1009 KB
> Avg. free extent: 25 KB
> Num. free extent: 2781696
> 
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>     1K...    2K-  :        705257        705257    1.03%
>     2K...    4K-  :        553577       1348712    1.97%
>     4K...    8K-  :        349406       1789755    2.62%
>     8K...   16K-  :        289102       3185026    4.65%
>    16K...   32K-  :        279061       6307452    9.22%
>    32K...   64K-  :        271631      12321046   18.01%
>    64K...  128K-  :        205191      18340308   26.80%
>   128K...  256K-  :        110082      19121199   27.94%
>   256K...  512K-  :         16962       5584384    8.16%
>   512K... 1024K-  :          1427        882388    1.29%
> 
> This one is 100Gb SSDs from some other vendor (can't remember which) on hardware RAID1.  It's never been more than about 30% full.  It looks like a similar histogram of extent sizes.  Again it's a 1kb block size (piles of small files on these filesystems)
> 
> [brong@imap30 ~]$ dumpe2fs -h /dev/sdf1
> dumpe2fs 1.42.4 (12-Jun-2012)
> Filesystem volume name:   ssd30
> Last mounted on:          /mnt/ssd30
> Filesystem UUID:          c2623b6a-b3f4-4a5a-99e3-495f29112ba6
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              12140544
> Block count:              97124320
> Reserved block count:     4856216
> Free blocks:              68429391
> Free inodes:              7157347
> First block:              1
> Block size:               1024
> Fragment size:            1024
> Reserved GDT blocks:      256
> Blocks per group:         8192
> Fragments per group:      8192
> Inodes per group:         1024
> Inode blocks per group:   256
> Flex block group size:    16
> Filesystem created:       Tue Aug  2 07:39:40 2011
> Last mount time:          Thu Jan 24 23:15:41 2013
> Last write time:          Thu Jan 24 23:15:41 2013
> Mount count:              10
> Maximum mount count:      39
> Last checked:             Tue Aug  2 07:39:40 2011
> Check interval:           15552000 (6 months)
> Next check after:         Sun Jan 29 06:39:40 2012
> Lifetime writes:          13 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:	          256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      0ecbfe75-57e3-4d4e-b4a8-bf0114dc0997
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke
> Journal size:             32M
> Journal length:           32768
> Journal sequence:         0x32367a0d
> Journal start:            1537
> 
> Regards,
> 
> Bron.
> 

