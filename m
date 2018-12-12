Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16557 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbeLLJUE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 04:20:04 -0500
Subject: Re: [PATCH] ext4: fix unsafe extent initialization
To: Andreas Dilger <adilger@dilger.ca>
References: <20181208142558.47955-1-yi.zhang@huawei.com>
 <20181210051037.GG1840@mit.edu>
 <38cb83c5-600b-c523-8006-5aab0a3eb9b0@huawei.com>
 <1A8D0C2B-EB45-4807-9802-C7CB6DB544E3@dilger.ca>
CC: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <2d3569d5-adc2-5757-b340-77532e78eb66@huawei.com>
Date: Wed, 12 Dec 2018 17:19:55 +0800
MIME-Version: 1.0
In-Reply-To: <1A8D0C2B-EB45-4807-9802-C7CB6DB544E3@dilger.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2018/12/11 4:14, Andreas Dilger Wrote:
> On Dec 10, 2018, at 2:26 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>
>> On 2018/12/10 13:10, Theodore Y. Ts'o Wrote:
>>> On Sat, Dec 08, 2018 at 10:25:58PM +0800, zhangyi (F) wrote:
>>>> Current ext4 will call ext4_ext_convert_to_initialized() to split and
>>>> initialize an unwritten extent if someone write something to it. It may
>>>> also zeroout the nearby blocks and expand the split extent if the
>>>> allocated extent is fully inside i_size or new_size. But it may lead to
>>>> inode inconsistency when system crash or the power fails.
>>>>
>>>> Consider the following case:
>>>> - Create an empty file and buffer write from block A to D (with delay
>>>>   allocate). It will update the i_size to D.
>>>> - Zero range from part of block B to D. It will allocate an unwritten
>>>>   extent from B to D.
>>>> - The write back worker write block B and initialize the unwritten
>>>>   extent from B to D, and then update the i_disksize to B.
>>>> - System crash.
>>>> - Remount and fsck complain about the extent size exceeds the inode
>>>>   size.
>>>>
>>>> This patch add checking i_disksize and chose the small one between
>>>> i_size to make sure it's safe to convert extent to initialized.
>>>>
>>>> ---------------------
>>>>
>>>> This problem can reproduce by xfstests generic/482 with fsstress seed
>>>> 1544025012.
>>>
>>> Hmm, your explanation is great and the patch makes sense.  I haven't
>>> been able to reproduce the problem by adding -s 1544025012 to the
>>> fsstress arguments.  This may be because fsstress being run with two
>>> processes (-p 2) and the failure may be timing dependent?
>>>
>> Yes, it is timing dependent and not quite easy to make a simple fast reproducer.
>> The default parameter of fsstress (tested by generic/482) on my machine is:
>>
>> ./ltp/fsstress -w -d /mnt/scratch -n 512 -p 8 -s 1544025012 -v
>>
>>> How easily can you replicate the problem?
>>
>> It is about 2~5% probability to replicate this problem under generic/482 on my
>> machine, and it can also appear in generic/019 and generic/455.
>>
>> After reproducing and checking this problem again, I think the above explanation
>> is not accurate. I simplify the running process in generic/482 and the real case
>> could be:
>>
>> - Create an empty file and buffer write from block A to D (with delay allocate).
>> - Buffer write from X to Z, now the i_size of this inode is updated to Z.
>> - Zero range from part of block B to D, it will allocate an unwritten extent
>>   from B to D. Note that it also will skip disksize update in
>>   ext4_zero_range() -> ext4_update_disksize_before_punch() because the i_size
>>   is large than the end of this zero range.
>> - The write back kworker write block B and initialize the whole unwritten
>>   extent from B to D, and then update the i_disksize to the end of B.
> 
> On a related note, should this just refuse to allocate uninitialized extents
> for regions that are smaller than the threshold that they would immediately
> be expanded into initialized extents on when they are modified?  This would
> avoid churn in the extent tree at the expense of (potentially) a few extra
> zero blocks written to disk.
> 
IIUC, allocating uninitialized extents are required for the zero_range
operaion (ext4_zero_range()) and also the normal fallocate operaion, we
should allocate uninitialized extents no matter the regions are smaller
than the threshold or not. So I think we cannot just refuse to allocate
uninitialized extents, am I missing something?

If we want to keep the extent tree, maybe we can update i_disksize instead
of split the extent. something like that.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6de..4b63b84 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3650,6 +3650,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,

        if (max_zeroout && (allocated > split_map.m_len)) {
                if (allocated <= max_zeroout) {
+                       loff_t disksize;
+
                        /* case 3 or 5 */
                        zero_ex1.ee_block =
                                 cpu_to_le32(split_map.m_lblk +
@@ -3663,6 +3665,22 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
                        if (err)
                                goto out;
                        split_map.m_len = allocated;
+
+                       /*
+                        * Update the i_disksize if zeroout the tail of
+                        * the second extent. Otherwise i_disksize update
+                        * can be lost as the region may have been marked
+                        * unwritten before writeback.
+                        */
+                       disksize = ((loff_t)(split_map.m_lblk +
+                                            split_map.m_len)) <<
+                                            PAGE_SHIFT;
+                       if (disksize > EXT4_I(inode)->i_disksize) {
+                               EXT4_I(inode)->i_disksize = disksize;
+                               err = ext4_mark_inode_dirty(handle, inode);
+                               if (err)
+                                       goto out;
+                       }
                }
                if (split_map.m_lblk - ee_block + split_map.m_len <
                                                                max_zeroout) {


Thoughts?

Thanks,
Yi.
