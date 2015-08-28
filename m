From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Fri, 28 Aug 2015 09:39:19 +0300
Message-ID: <CAETWcfsyBDVjdpakQeb7FzEmOHikHxsKkMQoMad1qkmVqQ2EAQ@mail.gmail.com>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
 <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca> <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
 <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com> <B71D47F8-F061-431C-B7F4-6CEF102F5C98@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36165 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbbH1Gj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2015 02:39:59 -0400
Received: by obkg7 with SMTP id g7so35296136obk.3
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2015 23:39:58 -0700 (PDT)
In-Reply-To: <B71D47F8-F061-431C-B7F4-6CEF102F5C98@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Here's the ltrace output (it's definitely running infinitive loop)"

root@rescue ~ # ltrace -p 31435 2>&1|head -n 30
ext2fs_mark_generic_bmap(0x797480, 0xf49f8345, 0x63e000, 0x64af40,
0x7ffe7148e8d0) = 0
ext2fs_blocks_count(0x641b00, 0x7ffe7148e998, 18, 0xffffffff,
0xf49f8346) = 0x2f47bfdfb
ext2fs_test_generic_bmap(0x64ae80, 0xe4dcb10f, 0x63e000, 0, 0x7ffe7148e8d0) = 0
ext2fs_mark_generic_bmap(0x64ae80, 0xe4dcb10f, 0x63e000, 0x64af40,
0x7ffe7148e8d0) = 0
ext2fs_blocks_count(0x641b00, 0x7ffe7148e998, 18, 0xffffffff,
0xe4dcb110) = 0x2f47bfdfb
ext2fs_test_generic_bmap(0x64ae80, 0x2c4ceefd, 0x63e000, 0, 0x7ffe7148e8d0) = 0
ext2fs_mark_generic_bmap(0x64ae80, 0x2c4ceefd, 0x63e000, 0x64af40,
0x7ffe7148e8d0) = 0
ext2fs_blocks_count(0x641b00, 0x7ffe7148e998, 18, 0xffffffff,
0x2c4ceefe) = 0x2f47bfdfb
ext2fs_test_generic_bmap(0x64ae80, 0x27a62eff, 0x63e000, 0, 0x7ffe7148e8d0) = 0
ext2fs_mark_generic_bmap(0x64ae80, 0x27a62eff, 0x63e000, 0x64af40,
0x7ffe7148e8d0) = 0
ext2fs_blocks_count(0x641b00, 0x7ffe7148e998, 18, 0xffffffff,
0x27a62f00) = 0x2f47bfdfb
ext2fs_test_generic_bmap(0x64ae80, 0x7887810d, 0x63e000, 0, 0x7ffe7148e8d0) = 1
ext2fs_mark_generic_bmap(0x797480, 0x7887810d, 0x63e000, 0x64af40,
0x7ffe7148e8d0) = 0
ext2fs_blocks_count(0x641b00, 0x7ffe7148e998, 18, 0xffffffff,
0x7887810e) = 0x2f47bfdfb
[skipped]

Right after running ltrace, fsck exited with the message:

fsck: Warning... fsck.ext4 for device /dev/sda3 exited with signal 5.

Will try to install latest version of e2fsprogs.

root@rescue ~ # debugfs -c -R stats /dev/sda3
debugfs 1.42.5 (29-Jul-2012)
/dev/sda3: catastrophic mode - not reading inode or group bitmaps

The output starts with supeblock info and continues with group info:

Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          552052d1-9e25-4b2b-bc04-21c7b4a87aa4
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype
extent 64bit flex_bg sparse_super huge_file uninit_bg dir_nlink
extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         not clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              793231360
Block count:              12691701243
Reserved block count:     634585062
Free blocks:              12641158920
Free inodes:              793231369
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
Flex block group size:    16
Filesystem created:       Thu Feb 12 16:57:47 2015
Last mount time:          Thu Aug 27 10:58:45 2015
Last write time:          Thu Aug 27 10:58:58 2015
Mount count:              4
Maximum mount count:      -1
Last checked:             Thu Feb 12 16:57:47 2015
Check interval:           0 (<none>)
Lifetime writes:          279 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      9ddd8b55-ff3f-4447-bf5c-732402ddd8d6
Journal backup:           inode blocks
FS Error count:           154
First error time:         Thu Aug 13 17:25:45 2015
First error function:     ext4_mb_generate_buddy
First error line #:       739
First error inode #:      0
First error block #:      0
Last error time:          Fri Aug 14 16:48:41 2015
Last error function:      ext4_mb_generate_buddy
Last error line #:        739
Last error inode #:       0
Last error block #:       0
Directories:              -5
 Group  0: block bitmap at 6053, inode bitmap at 6069, inode table at 6085
           24511 free blocks, 2037 free inodes, 2 used directories, 0
unused inodes
           [Checksum 0x473d]
 Group  1: block bitmap at 6054, inode bitmap at 6070, inode table at 6213
           26665 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x87ce]
 Group  2: block bitmap at 6055, inode bitmap at 6071, inode table at 6341
           32768 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0xa6fb]
 Group  3: block bitmap at 6056, inode bitmap at 6072, inode table at 6469
           26715 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x8707]
 Group  4: block bitmap at 6057, inode bitmap at 6073, inode table at 6597
           32768 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x1495]
 Group  5: block bitmap at 6058, inode bitmap at 6074, inode table at 6725
           26715 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x324b]
 Group  6: block bitmap at 6059, inode bitmap at 6075, inode table at 6853
           32768 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x3098]
 Group  7: block bitmap at 6060, inode bitmap at 6076, inode table at 6981
           26715 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes

[skipped]

 Group 387317: block bitmap at 12691439621, inode bitmap at
12691439637, inode table at 12691440288
           32768 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0xad15]
 Group 387318: block bitmap at 12691439622, inode bitmap at
12691439638, inode table at 12691440416
           32768 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0x95b4]
 Group 387319: block bitmap at 12691439623, inode bitmap at
12691439639, inode table at 12691440544
           32251 free blocks, 2048 free inodes, 0 used directories, 0
unused inodes
           [Checksum 0xbfba]

P.S. I can even mount it and walk on directories but errors still exist:
- ????????? instead of directory record
- i/o error on <directory_name>
- etc.

Regards,
Alexander

On Thu, Aug 27, 2015 at 7:39 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Aug 27, 2015, at 8:23 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
>>
>> Hi,
>>
>> I've restarted fsck ~6 hours ago. It's again occupied ~30GB RAM and
>> strace shows that number of syscalls per second becomes fewer and
>> fewer.
>
> My first suggestion would be to upgrade e2fsprogs to the latest
> stable version - 1.42.13 so that you are not hitting any older bugs.
>
> What was the original problem reported that caused the e2fsck
> to be run?
>
> Next, please include the full output from the start of e2fsck,
> unless it is just a lot of the same lines repeated.  There are
> a lot of Lustre users with 32TB or 48TB ext4 filesystems that can
> finish a full e2fsck in a few hours, unless there is some kind
> of major corruption.  It may be possible to fix some of the
> corruption manually with debugfs to avoid a lengthy e2fsck run.
>
> If you can run "ltrace -p <e2fsck_pid>" on the e2fsck then it
> would tell us what code it is running.  It doesn't seem to be
> IO bound (only one seek+read per 6 seconds).
>
> Are there any special formatting options that were used for the
> filesystem originally?  What does "debugfs -c -R stats <dev>"
> report about the filesystem?
>
> Cheers, Andreas
>
>
>> Regards,
>> Alexander
>>
>> On Thu, Aug 27, 2015 at 8:28 AM, Alexander Afonyashin
>> <a.afonyashin@madnet-team.ru> wrote:
>>> Hi,
>>>
>>> The last output (2 days ago) from fsck:
>>>
>>> [skipped]
>>> Block #524296 (1235508688) causes directory to be too big.  CLEARED.
>>> Block #524297 (4003498426) causes directory to be too big.  CLEARED.
>>> Block #524298 (3113378389) causes directory to be too big.  CLEARED.
>>> Block #524299 (1368545889) causes directory to be too big.  CLEARED.
>>> Too many illegal blocks in inode 4425477.
>>> Clear inode? yes
>>>
>>> ---------------------------
>>> iostat output:
>>>
>>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>>           0.00    0.00    0.00   14.52    0.00   85.48
>>>
>>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>>> loop0             0.00     0.00    2.00    0.00    12.00     0.00
>>> 12.00     0.09   46.00   46.00    0.00  46.00   9.20
>>> sda               0.00     0.00   87.00    0.00   348.00     0.00
>>> 8.00     1.00   11.86   11.86    0.00  11.45  99.60
>>>
>>> ---------------------------
>>> strace ouput:
>>>
>>> root@rescue ~ # strace -f -t -p 4779
>>> Process 4779 attached - interrupt to quit
>>> 07:26:54 lseek(4, 14154266963968, SEEK_SET) = 14154266963968
>>> 07:26:54 read(4,
>>> "\277\224\312\371\302\356\tJC{P\244#3\"2P\327*2Q5\372\206\262\20\\\373\226\262\21\316"...,
>>> 4096) = 4096
>>> 07:27:02 lseek(4, 1408506736640, SEEK_SET) = 1408506736640
>>> 07:27:02 read(4,
>>> "\352\3041\345\1\337p\263l;\354\377E[\17\350\235\260\r\344\265\337\3655\223E\216\226\376\263!\n"...,
>>> 4096) = 4096
>>> 07:27:08 lseek(4, 5948177264640, SEEK_SET) = 5948177264640
>>> 07:27:08 read(4,
>>> "\321}\226m;1\253Z\301f\205\235\25\201\334?\311AQN(\22!\23{\345\214Vi\240=y"...,
>>> 4096) = 4096
>>> 07:27:10 brk(0x8cf18e000)               = 0x8cf18e000
>>> 07:27:14 lseek(4, 6408024879104, SEEK_SET) = 6408024879104
>>> 07:27:14 read(4,
>>> "\254n\fn\r\302$\t\213\231\256\2774\326\34\364\fY\v\365`*Br\354X\7T3J\243K"...,
>>> 4096) = 4096
>>> 07:27:21 lseek(4, 8640894586880, SEEK_SET) = 8640894586880
>>> 07:27:21 read(4,
>>> "3\372\24\357\3579\254\31\214L\rYrurj\376\250\352%\2\242\255\252\22\347XU\327\235\362\337"...,
>>> 4096) = 4096
>>> ^CProcess 4779 detached
>>>
>>> Regards,
>>> Alexander
>>>
>>> On Tue, Aug 25, 2015 at 10:43 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>>>> On Aug 25, 2015, at 9:30 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> Recently I had to run fsck on 47TB ext4 partition backed by hardware
>>>>> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
>>>>> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
>>>>> 100% of single CPU. It detected errors (and fixed them) but doesn't
>>>>> finish yet.
>>>>>
>>>>> Rescue disc is based on Debian 7.8.
>>>>> kernel: 4.1.4-5
>>>>> e2fsprogs: 1.42.5-1.1+deb7u1
>>>>>
>>>>> Any suggestions?
>>>>
>>>> Usually the only reason for e2fsck to run so long is because of
>>>> duplicate block pass 1b/1c.
>>>>
>>>> Having some of the actual output of e2fsck would allow us to give
>>>> some useful advice.
>>>>
>>>> The only thing I can offer is for you to run "strace -p <e2fsck_pid>"
>>>> and/or "ltrace -p <e2fsck_pid>" to see what it is doing.
>>>>
>>>> Cheers, Andreas
>>>>
>>>>
>>>>
>>>>
>>>>
>
>
> Cheers, Andreas
>
>
>
>
>
