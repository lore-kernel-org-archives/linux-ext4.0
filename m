From: Alexander Harrowell <a.harrowell@gmail.com>
Subject: Re: Fwd: Fwd: strange e2fsck magic number behaviour
Date: Fri, 13 Sep 2013 13:34:13 +0000
Message-ID: <CA+qGm=-DcVXsWLsaM=7as_e=HPF1rvOyf12CT+=yrdr8ds+x=w@mail.gmail.com>
References: <CA+qGm=-0w+gTh6=ZJhns_=4LKksJueiaYF0gxogmj=TmFN7yQg@mail.gmail.com>
	<CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
	<5231EF7D.20501@redhat.com>
	<CA+qGm=-jHzxFmb1yHqoB9UC8c7nvJN-WVP2Bb67=G63OKE3_2Q@mail.gmail.com>
	<CA+qGm=99UEZpm4nvess8g3n4bO+iTwehVda1UY3xyTjdeMOhrA@mail.gmail.com>
	<52320EFB.6080100@redhat.com>
	<CA+qGm=-xi4SPeq6JXRqQf8fdyiE4fC27o9258_adUSqHY0jAQg@mail.gmail.com>
	<CA+qGm=8zwugE8VB3WdbTeYjxpmJP751k=wv=H=rrVmN4i6+J2Q@mail.gmail.com>
	<CA+qGm=-wZz1ZzTSxZ1U-7QkqFu-t9j=3BZZz+MFpZ=yL8=ec7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35783 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3IMNeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Sep 2013 09:34:14 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so1256246pbc.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Sep 2013 06:34:13 -0700 (PDT)
In-Reply-To: <CA+qGm=-wZz1ZzTSxZ1U-7QkqFu-t9j=3BZZz+MFpZ=yL8=ec7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

example:

Block    Inode number
16777215    2937846
debugfs:  clri <2937846>
debugfs:  icheck 16777215
Block    Inode number
16777215    2937854
debugfs:  clri <2937854>
debugfs:  icheck 16777215
Block    Inode number
16777215    2937862
debugfs:  clri <2937862>
debugfs:  icheck 16777215
Block    Inode number
16777215    2937870
debugfs:  clri <2937870>
debugfs:  icheck 16777215
Block    Inode number
16777215    2937878
debugfs:  clri <2937878>
debugfs:  icheck 16777215

debugfs:  block_dump 16777215
0000  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
2720  0000 0000 0000 0000 0000 0000 ffff ff00  ................
2740  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
3620  0000 0000 0000 0000 0000 0000 ffff ff00  ................
3640  ffff ff00 ffff ff00 ffff ff00 ffff ff00  ................
*
4000  ffff ff00 ffff ff00 ffff ff00 0000 0000  ................
4020  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
4400  ffff ff00 ffff ff00 ffff ff00 ffff ff00  ................
*
4720  ffff ff00 ffff ff00 ffff ff00 0000 0000  ................
4740  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
5640  ffff ff00 ffff ff00 ffff ff00 ffff ff00  ................
*
6000  ffff ff00 ffff ff00 0000 0000 0000 0000  ................
6020  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
6400  0000 0000 ffff ff00 ffff ff00 ffff ff00  ................
6420  ffff ff00 ffff ff00 ffff ff00 ffff ff00  ................
*
6720  ffff ff00 ffff ff00 0000 0000 0000 0000  ................
6740  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
7640  0000 0000 0000 0000 ffff ff00 ffff ff00  ................
7660  ffff ff00 ffff ff00 ffff ff00 ffff ff00  ................
*
7720  ffff ff00 0000 0000 0000 0000 0000 0000  ................
7740  0000 0000 0000 0000 0000 0000 0000 0000  ................
*

On Fri, Sep 13, 2013 at 1:33 PM, Alexander Harrowell
<a.harrowell@gmail.com> wrote:
> Hmm, coming back to this, block 16777215 with identical content is
> recurring at intervals of 8 inodes.
>
> On Fri, Sep 13, 2013 at 11:46 AM, Alexander Harrowell
> <a.harrowell@gmail.com> wrote:
>> To update, I've found that a) even with 8GB RAM and 8GB swap, e2fsck
>> can silently run out of memory.
>>
>> b) something is clearly wrong in block 16777215.
>>
>> c) debugfs places that block in inode 409774, in use, with an extent
>> of 16777212-5 and 10 associated filenames, plus several dozen ext2
>> directory errors.
>>
>> d) after a first attempt with the updated (1.42.8) version of
>> e2fsprogs this morning, the disk is mountable again but not much on it
>> is accessible and the % usage is still screwy.
>>
>> e) that said, "new" debugfs and e2fsck seem to find more things to fix.
>>
>> f) trying to decrypt the filenames, most of them don't get found by
>> ecryptfs-find but the first one produces a list of the files in /home/
>> and a lot of find: no such file or directory messages.
>>
>> g) dumpe2fs -b reports no bad blocks. smart reports drive in good condition.
>>
>> h) I'm quite tempted to zap 409774.
>>
>> On Thu, Sep 12, 2013 at 7:33 PM, Alexander Harrowell
>> <a.harrowell@gmail.com> wrote:
>>> investigating dmesg, I think e2fsck may have been running out of memory.
>>>
>>> On Thu, Sep 12, 2013 at 6:59 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>> On 9/12/13 11:56 AM, Alexander Harrowell wrote:
>>>>> ---------- Forwarded message ----------
>>>>> From: Alexander Harrowell <a.harrowell@gmail.com>
>>>>> Date: Thu, Sep 12, 2013 at 4:54 PM
>>>>> Subject: Re: Fwd: strange e2fsck magic number behaviour
>>>>> To: Eric Sandeen <sandeen@redhat.com>
>>>>>
>>>>>
>>>>> It was 63GB and I just wanted to fork over 3GB of extra space from my
>>>>> Windows partition...
>>>>
>>>> Ok, so you tried to resize from 63G to 66G?  Should have been relatively
>>>> easy/safe.  I forgot to ask which version of e2fsprogs you had, but if
>>>> you did the grow online/mounted, most of the work is done in the kernel.
>>>>
>>>> As Ted said, knowing more info might yield clues:
>>>>
>>>> 1) what e2fsprogs version?
>>>> 2) what were the kernel messages when it crashed/hung?
>>>> 3) what was the fsck output?
>>>>
>>>> If you didn't save that stuff, it makes it harder to do a post-mortem...
>>>>
>>>>> The fstab is as follows
>>>>>
>>>>> /dev/sda1 SYSTEM_DRV ntfs 1.17g (boot)
>>>>> /dev/sda2 Windows7_OS ntfs 63.4G
>>>>> /dev/sda4 extended partition containing:
>>>>> -- /dev/sda6 swap linux-swap 8.05G
>>>>> -- /dev/sda5 /home ext4 66.14G
>>>>> /dev/sda3 Lenovo_Recovery ntfs 10.25G
>>>>> unallocated 1M
>>>>>
>>>>> that's what was intended and is what gparted reports. (however,
>>>>> weirdly, if you ask Ubuntu Disk Utility, it says /dev/sda5 is 71GB and
>>>>> /dev/sda4 is correspondingly bigger. this I have only just noticed.)
>>>>
>>>> TBH, I have no idea what Ubuntu Disk Utility does.  I'd trust fdisk -lu
>>>> output or /proc/partitions for accurate size info.
>>>>
>>>> Oh; 61.14GiB (powers of 2) == 71 GB (powers of 10)
>>>>
>>>> (61.14*1024*1024*1024/1000/1000/1000 = 71)
>>>>
>>>> So Ubuntu Disk Utility is in cahoots w/ the drive manufacturers, and
>>>> using more favorable units.  ;)
>>>>
>>>> -Eric
>>>>
>>>>> kernel is 3.2.0-29-generic, machine is a ThinkPad X200s with 160GB disk.
>>>>>
>>>>> thanks for your help.
>>>>>
>>>>>
>>>>> On Thu, Sep 12, 2013 at 4:44 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>>>> On 9/12/13 11:39 AM, Alexander Harrowell wrote:
>>>>>>> I'm currently trying to recover an ext4 filesystem. Last night, during
>>>>>>> a resize operation,
>>>>>>
>>>>>> from what size to what size? On what kernel?
>>>>>>
>>>>>>> the system (Ubuntu 12.04 LTS on my fix-stuff usb
>>>>>>> stick) locked up hard and eventually crashed. Restarting,
>>>>>>> unsurprisingly, gparted offered to check the volume. e2fsck, called
>>>>>>> from within gparted, replayed the journal overnight and completed the
>>>>>>> resize.
>>>>>>
>>>>>> hmmm... perhaps.
>>>>>>
>>>>>>> however, where I was expecting a volume with about 3.5GB of free
>>>>>>> space, there was now a volume with 32GB free space, a bit more than
>>>>>>> 50% utilised. inevitably, trying to boot the linux that lives in there
>>>>>>> dropped into grub rescue.
>>>>>>>
>>>>>>> going back, I tried to e2fsck it. this reported large numbers of inode
>>>>>>> issues and eventually reported clean. I could mount the volume, but
>>>>>>> file metadata looked generally broken (lots of ?s). testdisk showed
>>>>>>> the partitions were intact, although it claimed the drive was the
>>>>>>> wrong size (incorrectly), and found lots of deleted files within my
>>>>>>> ecryptfs home folder. It also found the backup superblocks for the
>>>>>>> damaged volume.
>>>>>>>
>>>>>>> the first couple I tried were corrupt, but the third was valid. e2fsck
>>>>>>> -b [superblock] -y reports fixing a lot of inode things, checksums,
>>>>>>> and then restarts.  it then starts to report hunormous numbers of
>>>>>>> multiply-claimed blocks.
>>>>>>>
>>>>>>> and now comes the interesting bit - at some point, block 16777215
>>>>>>> starts to appear more and more often in the inodes, often duplicated,
>>>>>>> until it starts to print out the number 16777215 in a fast loop. in
>>>>>>> fact, it looks like it hits some inode and keeps printing block
>>>>>>> 16777215 to the same very long line (it's generated 500MB of log)
>>>>>>
>>>>>> = 111111111111111111111111 binary.
>>>>>>
>>>>>> Guessing it's maybe a bitmap block?
>>>>>>
>>>>>> Resize2fs has had a lot of trouble lately it seems.  You may have just
>>>>>> been the unlucky recipient of a resize2fs bug...
>>>>>>
>>>>>> -Eric
>>>>>>
>>>>>>> I removed the first inode containing this block via debugfs, without
>>>>>>> this helping.
>>>>>>>
>>>>>>> It sticks out that 16777215 is a magic number (the maximum in a 48 bit
>>>>>>> address space) and I google that either ext4 or e2fsck has had a bug
>>>>>>> involving it before.
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
