From: InvTraySts <invtrasys@gmail.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 12:35:59 -0400
Message-ID: <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com> <524302D5.10701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:63401 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3IYQgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Sep 2013 12:36:41 -0400
Received: by mail-we0-f173.google.com with SMTP id w62so6290096wes.4
        for <linux-ext4@vger.kernel.org>; Wed, 25 Sep 2013 09:36:39 -0700 (PDT)
In-Reply-To: <524302D5.10701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not used to mailing list courtesy so forgive how gmail responds to these...

I didn't have any kind of error on the RAID controller itself. When I
went back for one of the weekends, I went into the RAID controller
BIOS and everything was reported as normal. Of the four logical drives
experiencing problems, only two of them were on the controller, one
was plugged into the motherboard, the last one was plugged into an
add-on SATA card.

I don't know what happened on the 24th of August, all I know is that
it was working fine the previous night, tried to get on the network,
and everything had stopped working (web server, DHCP, bind, samba,
etc). Went down to inspect the machine and noticed that it was running
but there was nothing showing up the monitor when plugging it in. So I
am not sure of the exact events of how it failed, I just know that
after hardware testing, the processor was dead.

I have tried using dd and ddrescue using the following commands:
 dd if=/dev/sdc of=/dev/sdf bs=4096 conv=notrunc,noerror,sync
 ddrescue -vf /dev/sdh /dev/sdf /home/andrew/logfile.txt

On Wed, Sep 25, 2013 at 11:35 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/24/13 9:25 PM, InvTraySts wrote:
>> So long story short, I had a server running that had a processor fail
>> while powered on, causing the file systems to become corrupt. I
>> replaced the motherboard, processor and power supply just to be on the
>> safe side. However, I am at a bit of a loss as to what to do now. I
>> was working sandeen in the OFTC IRC channel, but, on his
>> recommendation he suggested me to post something to the mailing list.
>
> Just so we had a record of things.  :)
>
> (also: removing -fsdevel cc:)
>
>> Lets start off with one drive at a time (I have 4 that are corrupt).
>> The specific logical drive in question was in RAID1 on a Dell PERC 5/i
>> card.
>> If I try to mount this using:
>> mount -t ext4 /dev/sda1 /media/tmp
>>
>> It complains in dmesg with the following output:
>> 685621.845207] EXT4-fs error (device sda1): ext4_iget:3888: inode #8:
>> comm mount: bad extra_isize (18013 != 256)
>> [685621.845213] EXT4-fs (sda1): no journal found
>
> (FWIW, inode #8 is the journal inode.)
>
> Do you have any idea what happened *first* - did you have any kind of
> errors from the raid controller back on Aug 24?
>
> First step is to be sure the storage is in decent shape.  No amount
> of fsck or whatnot will fix misconfigured or degraded storage, scrambled
> raids, etc...
>
> and if you have 4 "bad" logical drives on that raid, it sure sounds like
> something went wrong storage-wise.
>
>
>> However, if I run dumpe2fs -f /dev/sda1 I get the following output:
>> root@server:~# dumpe2fs -f /dev/sda1
>> dumpe2fs 1.42.5 (29-Jul-2012)
>> Filesystem volume name:   root
>> Last mounted on:          /media/ubuntu/root
>> Filesystem UUID:          f959e195-[removed]
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index
>> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
>> dir_nlink extra_isize
>> Filesystem flags:         signed_directory_hash
>> Default mount options:    user_xattr acl
>> Filesystem state:         not clean with errors
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              4849664
>> Block count:              19398144
>> Reserved block count:     969907
>> Free blocks:              17034219
>> Free inodes:              4592929
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Reserved GDT blocks:      1019
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         8192
>> Inode blocks per group:   512
>> Flex block group size:    16
>> Filesystem created:       Sat May 25 14:59:50 2013
>> Last mount time:          Sat Aug 24 11:04:25 2013
>> Last write time:          Tue Sep 24 13:55:36 2013
>> Mount count:              0
>> Maximum mount count:      -1
>> Last checked:             Sat Aug 24 16:56:09 2013
>> Check interval:           0 (<none>)
>> Lifetime writes:          107 GB
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:               256
>> Required extra isize:     28
>> Desired extra isize:      28
>> Journal inode:            8
>> Default directory hash:   half_md4
>> Directory Hash Seed:      01a8f605-b2bc-41ee-b7b5-11d843ab622f
>> Journal backup:           inode blocks
>> FS Error count:           8
>> First error time:         Sat Aug 24 13:44:55 2013
>> First error function:     ext4_iget
>> First error line #:       3889
>> First error inode #:      8
>> First error block #:      0
>> Last error time:          Tue Sep 24 13:55:36 2013
>> Last error function:      ext4_iget
>> Last error line #:        3888
>> Last error inode #:       8
>> Last error block #:       0
>> dumpe2fs: Corrupt extent header while reading journal super block
>
> inode 8 is the journal inode.
>
>>
>> So I attempted to clone the drive to a 2TB backup drive that is empty,
>> and currently I am having more problems with the cloned drive than I
>> am with the original.
>
> cloned how?  Working on a backup is a good idea, to be sure.
>
>> sandeen said something about using tune2fs to tell it to remove the
>> has_journal flag, but I might need some assistance with that.
>
> I had suggested that just because the journal superblock seems
> corrupted, and removing & recreating the journal is fairly harmless.
>
> To do so, it'd be tune2fs -O ^has_journal /dev/sda1
>
> But there may well be other problems behind that one.
>
>> I would appreciate any help that you could give me, as I know my
>> chances of recovering data are slim, but I would definitely like to
>> try and recover as much data as I can.
>>
>> Thanks
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
