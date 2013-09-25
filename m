From: InvTraySts <invtrasys@gmail.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 13:09:57 -0400
Message-ID: <CAOWv6b3_DbKjD5aGa1g-zEbVyJOar7NXLbaVA8ZKx+9s62bO2A@mail.gmail.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
 <524302D5.10701@redhat.com> <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com>
 <52431462.1090906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:40559 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3IYRKi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Sep 2013 13:10:38 -0400
Received: by mail-we0-f180.google.com with SMTP id u57so6299063wes.25
        for <linux-ext4@vger.kernel.org>; Wed, 25 Sep 2013 10:10:37 -0700 (PDT)
In-Reply-To: <52431462.1090906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So for instance, where I can run:
mount /dev/sda1 /media/tmp

It will attempt to mount but complain about either a bad filesystem,
superblock, etc. If I try to mount the cloned drive:
mount: you must specify the filesystem type

Looking back at dmesg the results are different:
[767942.335569] JBD2: Invalid start block of journal: 0
[767942.335572] EXT4-fs (sda1): error loading journal
[767947.740996] EXT3-fs (sdf1): error: can't find ext3 filesystem on dev sdf1.
[767947.741123] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem
[767947.741253] FAT-fs (sdf1): invalid media value (0xad)
[767947.741255] FAT-fs (sdf1): Can't find a valid FAT filesystem
[767947.741403] EXT2-fs (sdf1): error: can't find an ext2 filesystem
on dev sdf1.
[767957.299593] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem

Looking at dumpe2fs for the filesystem on /dev/sdf1 (sdf is the cloned
drive, the actual drive, sda, is in the original e-mail)
root@server:~# dumpe2fs /dev/sdf1
dumpe2fs 1.42.5 (29-Jul-2012)
dumpe2fs: Bad magic number in super-block while trying to open /dev/sdf1
Couldn't find valid filesystem superblock.

dd didn't say it had any errors, and the log file for ddrescue doesn't
appear to give any errors either. I can run it again though. Should
there be any difference in the command that I run this time? I was
under the impression that notrunc,noerror,sync would have been
suitable to clone the drive over.



On Wed, Sep 25, 2013 at 12:50 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/25/13 11:35 AM, InvTraySts wrote:
>> Not used to mailing list courtesy so forgive how gmail responds to these...
>>
>> I didn't have any kind of error on the RAID controller itself. When I
>> went back for one of the weekends, I went into the RAID controller
>> BIOS and everything was reported as normal. Of the four logical drives
>> experiencing problems, only two of them were on the controller, one
>> was plugged into the motherboard, the last one was plugged into an
>> add-on SATA card.
>>
>> I don't know what happened on the 24th of August, all I know is that
>> it was working fine the previous night, tried to get on the network,
>> and everything had stopped working (web server, DHCP, bind, samba,
>> etc). Went down to inspect the machine and noticed that it was running
>> but there was nothing showing up the monitor when plugging it in. So I
>> am not sure of the exact events of how it failed, I just know that
>> after hardware testing, the processor was dead.
>
> Ok, so pretty extreme hardware failure.
>
>> I have tried using dd and ddrescue using the following commands:
>>  dd if=/dev/sdc of=/dev/sdf bs=4096 conv=notrunc,noerror,sync
>>  ddrescue -vf /dev/sdh /dev/sdf /home/andrew/logfile.txt
>
> (you said the copy was worse; what was wrong with it?)
> (did the dd or ddrescue encounter any errors while doing the copy?)
>
> dd should have worked fine, and you should be able to play with that
> image.  First thing I'd try, if it still throws the bad journal
> error first, is to tune2fs -O ^has_journal /dev/sdf
>
> Then try to mount and /or run e2fsck on it, see how it fares.
> The journal is just the first thing mount's going to look at;
> if the corruption is widespread you may just have a cascade of other
> errors behind it, but worth a shot.
>
> -Eric
>
