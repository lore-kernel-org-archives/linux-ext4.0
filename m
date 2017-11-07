From: mfe555 <mfe555@web.de>
Subject: Re: Significant difference in 'file size' and 'disk usage' for single
 files
Date: Tue, 7 Nov 2017 08:30:25 +0100
Message-ID: <19c817e5-1481-704e-4a4f-7b1640cf23c9@web.de>
References: <472fde11-654a-4826-0256-46149e90216e@web.de>
 <d2136540-6e7c-9e19-1ba4-fbf304b63362@web.de>
 <07f4b566-7ec5-6d36-74bb-d41b694b3194@clearskydata.com>
 <71009a7a-7875-bf6b-5db4-3eeeb6a787af@web.de>
 <590cd975-aa62-98a5-9ef8-5963484a77a0@clearskydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: mfe555@web.de
To: "Mattthew L. Martin" <linux@clearskydata.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:53604 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752549AbdKGHaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 7 Nov 2017 02:30:14 -0500
In-Reply-To: <590cd975-aa62-98a5-9ef8-5963484a77a0@clearskydata.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Matthew,

sorry about the misunderstanding. If you agree I will reply to your bug 
report at bugzilla.kernel.org, providing the details I have posted here 
initially. Is there anything else you would recommend me to do, or any 
other information you can share?

Thanks a lot
Lukas


Am 06.11.2017 um 19:56 schrieb Mattthew L. Martin:
> Lukas,
>
> I think you might have misunderstood me. We are pretty much in the 
> same situation that you find yourself. We currently un-mount and 
> remount the file systems that have this behavior to ameliorate the 
> issue. We can provide information, but we don't have the manpower or 
> skill set to effect a fix.
>
> Matthew
>
>
> On 11/6/17 12:35, mfe555 wrote:
>> Dear Mathew,
>>
>> thank you very much for your message and for your offer of helping me.
>>
>> In my case, the file system has a cluster size of 262144. bigalloc is 
>> enabled, please see below for details (tune2fs). I have been able to 
>> confirm that unmounting and re-mounting the file system helps.
>>
>> Please let me know what else I can do for giving you more clues. For 
>> example, as our linux system is built for over 100 different settop 
>> boxes, I might be able to get help from other people, performing 
>> tests on specific linux kernels.
>>
>> Kind regards
>> Lukas
>>
>> =================================
>> # tune2fs -l /dev/sdb1
>> tune2fs 1.43.4 (31-Jan-2017)
>> Filesystem volume name:   <none>
>> Last mounted on:          /media/hdd
>> Filesystem UUID:          1dbc401d-3ff4-4a46-acc7-8ec7b841bdb0
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index 
>> filetype needs_recovery extent flex_bg sparse_super large_file 
>> huge_file uninit_bg dir_nlink extra_isize bigalloc
>> Filesystem flags:         signed_directory_hash
>> Default mount options:    user_xattr acl
>> Filesystem state:         clean
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              264688
>> Block count:              488378368
>> Reserved block count:     0
>> Free blocks:              146410368
>> Free inodes:              260432
>> First block:              0
>> Block size:               4096
>> Cluster size:             262144
>> Reserved GDT blocks:      14
>> Blocks per group:         2097152
>> Clusters per group:       32768
>> Inodes per group:         1136
>> Inode blocks per group:   71
>> Flex block group size:    16
>> Filesystem created:       Sun Mar 13 16:31:29 2016
>> Last mount time:          Thu Jan  1 01:00:04 1970
>> Last write time:          Thu Jan  1 01:00:04 1970
>> Mount count:              884
>> Maximum mount count:      -1
>> Last checked:             Sun Mar 13 16:31:29 2016
>> Check interval:           0 (<none>)
>> Lifetime writes:          6971 GB
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:               256
>> Required extra isize:     28
>> Desired extra isize:      28
>> Journal inode:            8
>> Default directory hash:   half_md4
>> Directory Hash Seed:      c69a1039-0065-4c1b-8732-ff1b52b57313
>> Journal backup:           inode blocks
>>
>>
>>
>>
>> Am 06.11.2017 um 16:35 schrieb Mattthew L. Martin:
>>> I filed a bug for this a while ago:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=151491
>>>
>>> We would be happy to help track this down as it is a pain to manage 
>>> this on running servers.
>>>
>>> Matthew
>>>
>>>
>>> On 11/5/17 06:16, mfe555 wrote:
>>>> Some follow-up:
>>>>
>>>> The issue only occurs with "bigalloc" enabled.
>>>>
>>>>     echo 3 > /proc/sys/vm/drop_caches
>>>>
>>>> seems to detach the blocked disk space from the files (so that 'du 
>>>> file' no longer includes the offset), but it does not free the 
>>>> space, 'df' still shows all file overheads as used disk space.
>>>>
>>>>
>>>>
>>>> Am 02.11.2017 um 20:17 schrieb mfe555:
>>>>> Hi, I'm using ext4 on a Linux based Enigma2 set-top box, kernel 
>>>>> 4.8.3.
>>>>>
>>>>> When creating a fresh file, there is a significant difference in 
>>>>> file size (ls -la) and disk usage (du). When making two copies of 
>>>>> the file ..
>>>>>
>>>>> gbquad:/hdd/test# cp file file.copy1
>>>>> gbquad:/hdd/test# cp file file.copy2
>>>>> gbquad:/hdd/test# ls -la
>>>>> -rw-------    1 root     root     581821460 Nov  1 18:52 file
>>>>> -rw-------    1 root     root     581821460 Nov  1 18:56 file.copy1
>>>>> -rw-------    1 root     root     581821460 Nov  1 18:57 file.copy2
>>>>> gbquad:/hdd/test# du *
>>>>> 607232  file
>>>>> 658176  file.copy1
>>>>> 644864  file.copy2
>>>>>
>>>>> ... all three files show an overhead in the ~10% range, and the 
>>>>> overhead is different for these files although their md5sums are 
>>>>> equal.
>>>>>
>>>>> When deleting a file (rm), the overhead remains occupied on the 
>>>>> disk. For example, after deleting "file", "df" reports approx. 
>>>>> 581821460 more bytes free, not 607232 kbytes more free space. The 
>>>>> overhead (607232 kB - 581821460 B =pprox. 39 MB) remains blocked.
>>>>>
>>>>> When re-booting, the blocked space becomes free again, and in 
>>>>> addition the overhead of those files that were not deleted also 
>>>>> disappears, so that after a reboot the'file size' and 'disk usage' 
>>>>> match for all files (except for rounding up to some block size).
>>>>>
>>>>> A colleague and I have observed this on two different "kernel 
>>>>> 4.8.3" boxes and three ext4 disks, but not on a "kernel 3.14" box 
>>>>> also using ext4.
>>>>>
>>>>> Can anyone help me with this ?
>>>>>
>>>>> Thanks a lot
>>>>> Lukas
>>>>>
>>>>
>>>
>>
>
