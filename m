Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:15668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbeLJJ0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 04:26:15 -0500
Subject: Re: [PATCH] ext4: fix unsafe extent initialization
To: "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20181208142558.47955-1-yi.zhang@huawei.com>
 <20181210051037.GG1840@mit.edu>
CC: <linux-ext4@vger.kernel.org>, <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <38cb83c5-600b-c523-8006-5aab0a3eb9b0@huawei.com>
Date: Mon, 10 Dec 2018 17:26:07 +0800
MIME-Version: 1.0
In-Reply-To: <20181210051037.GG1840@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2018/12/10 13:10, Theodore Y. Ts'o Wrote:
> On Sat, Dec 08, 2018 at 10:25:58PM +0800, zhangyi (F) wrote:
>> Current ext4 will call ext4_ext_convert_to_initialized() to split and
>> initialize an unwritten extent if someone write something to it. It may
>> also zeroout the nearby blocks and expand the split extent if the
>> allocated extent is fully inside i_size or new_size. But it may lead to
>> inode inconsistency when system crash or the power fails.
>>
>> Consider the following case:
>>  - Create an empty file and buffer write from block A to D (with delay
>>    allocate). It will update the i_size to D.
>>  - Zero range from part of block B to D. It will allocate an unwritten
>>    extent from B to D.
>>  - The write back worker write block B and initialize the unwritten
>>    extent from B to D, and then update the i_disksize to B.
>>  - System crash.
>>  - Remount and fsck complain about the extent size exceeds the inode
>>    size.
>>
>> This patch add checking i_disksize and chose the small one between
>> i_size to make sure it's safe to convert extent to initialized.
>>
>> ---------------------
>>
>> This problem can reproduce by xfstests generic/482 with fsstress seed
>> 1544025012.
> 
> Hmm, your explanation is great and the patch makes sense.  I haven't
> been able to reproduce the problem by adding -s 1544025012 to the
> fsstress arguments.  This may be because fsstress being run with two
> processes (-p 2) and the failure may be timing dependent?
> 
Yes, it is timing dependent and not quite easy to make a simple fast reproducer.
The default parameter of fsstress (tested by generic/482) on my machine is:

./ltp/fsstress -w -d /mnt/scratch -n 512 -p 8 -s 1544025012 -v

> How easily can you replicate the problem?

It is about 2~5% probability to replicate this problem under generic/482 on my
machine, and it can also appear in generic/019 and generic/455.

After reproducing and checking this problem again, I think the above explanation
is not accurate. I simplify the running process in generic/482 and the real case
could be:

 - Create an empty file and buffer write from block A to D (with delay allocate).
 - Buffer write from X to Z, now the i_size of this inode is updated to Z.
 - Zero range from part of block B to D, it will allocate an unwritten extent
   from B to D. Note that it also will skip disksize update in
   ext4_zero_range() -> ext4_update_disksize_before_punch() because the i_size
   is large than the end of this zero range.
 - The write back kworker write block B and initialize the whole unwritten
   extent from B to D, and then update the i_disksize to the end of B.
 - ext4_journal_stop()
 - kjournald2 process weakup and call jbd2_journal_commit_transaction() to commit
   journal and send FUA.
 - System crash.
 - System reboot and fsck complain about the extent size exceeds the inode size.

Thanks,
Yi.
