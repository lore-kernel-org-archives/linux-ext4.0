From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Filesystem size problem.
Date: Tue, 13 Dec 2016 17:43:56 -0800
Message-ID: <CAEUYfyOZWQHCb8SWzSxq5Fs+o6pqOUz4_kDZG4qTO8McKqBizw@mail.gmail.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
 <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
 <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca> <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
 <7393F8E6-AD83-430E-AE3E-A800DAB91FD3@dilger.ca> <CAEUYfyN373=Eacbu=jL-YPfcmLC0VjvMc++__eVUAJb++gq6Ug@mail.gmail.com>
 <33CFACFE-D772-4961-A94A-42479ECCB173@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34994 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753149AbcLNBn6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2016 20:43:58 -0500
Received: by mail-qk0-f173.google.com with SMTP id n204so5139238qke.2
        for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2016 17:43:58 -0800 (PST)
In-Reply-To: <33CFACFE-D772-4961-A94A-42479ECCB173@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 13, 2016 at 12:48 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Dec 12, 2016, at 7:48 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>
>> On Mon, Dec 12, 2016 at 2:36 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>>> On Dec 9, 2016, at 9:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>>
>>>> On 12/9/16 2:29 PM, Andreas Dilger wrote:
>>>>> On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>>>>>
>>>>>> I have an ext3 filesystem that will not mount under newer versions of
>>>>>> the kernel and I hope someone here can help.
>>>>>>
>>>>>> Obviously, one solution is "backup and re-create from scratch". I have
>>>>>> the backups, but I hope that there may be a quicker method to fix the
>>>>>> issues.
>>>>>>
>>>>>> The root issue is that the filesystem is very slightly smaller than
>>>>>> the allocated space.
>>>>
>>>> So the device is now smaller than the filesystem thinks, right?
>>>>
>>>>>> The filesystem exists on a MDRAID device and I think that when I
>>>>>> converted the MDRAID to a newer metadata version, it truncated the
>>>>>> available size, slightly. However, how I got here isn't really
>>>>>> important, fixing it now is.
>>>>>
>>>>> Running "e2fsck -fy" should fix this.  I'd recommend to use the latest
>>>>> version of e2fsck.
>>>>
>>>> Reaslly?  e2fsck can change total blocks in the superblock to accomodate
>>>> a shrunken device?  That's a new one for me...
>>>
>>> Strange, I thought this case was handled properly by e2fsck.
>>>
>>> You could probably fix this with:
>>>
>>> # debugfs -w -R "ssv blocks_count 693359326" /dev/md5
>>
>>
>> "probably"?
>>
>> How safe or dangerous is this? Does the filesystem have to be unmounted first?
>
> The filesystem *definitely* needs to be unmounted first.
>
> I wouldn't classify this change as being super dangerous, because it is
> only removing a few blocks from the end of the filesystem, and e2fsck
> should handle the case where inodes reference blocks beyond EOFS as any
> other corrupt blocks.  I don't think that is likely to happen in this
> case, unless your filesystem is extremely full, since extN filesystems
> front-end bias allocations to the faster part of the storage device.
>
> That said, I haven't tested this process[*], and if you are concerned that
> it may eat your data (that is always possible) you should make a backup.
> You should probably make a backup even if you aren't going to do this, as
> that is always a good idea.  As with any free advice you on the internet
> YMMV, and the final decision is up to you.
>
> The other option is to make a new filesystem on a second set of storage
> and then copy the old files over.  That also has benefits that the old
> filesystem acts as your backup, you get any new features enabled in ext4
> when the filesystem is newly formatted, and the files will likely be laid
> laid out on disk contiguously during the copy, so it will defragment the
> filesystem (not that ext4 needs this very much).
>
> PS: I added "-w" to the debugfs command above, or it would have failed

Thanks for this. I think that the best solution is to get new drives
and build a new ext4 filesystem on those.

It's always best to know that I have options.

We are using nfsv3 because performance of nfsv4 was terrible. Do you
have any idea if nfsv4 will work better with ext4?

Simon

>
> Cheers, Andreas
>
> [*] I did just try this on a test filesystem and it worked OK for me:
>
> [root@mookie ~]# dumpe2fs -h /dev/dm-53 | grep "Block count"
> dumpe2fs 1.42.13.wc5 (15-Apr-2016)
> Block count:              2621440
> [root@mookie ~]# debugfs -w -R "ssv blocks_count 2621400" /dev/dm-53
> debugfs 1.42.13.wc5 (15-Apr-2016)
> [root@mookie ~]# e2fsck -fn /dev/dm-53
> e2fsck 1.42.13.wc5 (15-Apr-2016)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #79 (26047, counted=26007).
> Fix? no
>
> Free blocks count wrong (2226761, counted=2226721).
> Fix? no
>
> Padding at end of block bitmap is not set. Fix? no
>
>
> myth_2-MDT0000: ********** WARNING: Filesystem still has errors **********
>
> myth_2-MDT0000: 1010990/2621440 files (0.1% non-contiguous), 394639/2621400 blocks
> [root@mookie ~]# e2fsck -fp /dev/dm-53
> myth_2-MDT0000: Padding at end of block bitmap is not set. FIXED.
> myth_2-MDT0000: 1010990/2621440 files (0.1% non-contiguous), 394679/2621400 blocks
>
>
>
>
>
