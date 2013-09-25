From: InvTraySts <invtrasys@gmail.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 19:57:32 -0400
Message-ID: <CAOWv6b2X9cwd7brTc2YaO7Fo9M_RqegCkn4uYcSv=5M8Z7_U2Q@mail.gmail.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
 <524302D5.10701@redhat.com> <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com>
 <52431462.1090906@redhat.com> <CAOWv6b3_DbKjD5aGa1g-zEbVyJOar7NXLbaVA8ZKx+9s62bO2A@mail.gmail.com>
 <5243597F.1010108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36938 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3IYX6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Sep 2013 19:58:14 -0400
Received: by mail-wg0-f47.google.com with SMTP id f12so402883wgh.14
        for <linux-ext4@vger.kernel.org>; Wed, 25 Sep 2013 16:58:12 -0700 (PDT)
In-Reply-To: <5243597F.1010108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Blkid for the drives say:

root@server:~# blkid /dev/sdf
root@server:~#
root@server:~# blkid /dev/sdf1
root@server:~#


root@server:~# blkid /dev/sda1
/dev/sda1: LABEL="root" UUID=remove TYPE="ext4"
root@server:~# blkid /dev/sda
root@server:~#

On Wed, Sep 25, 2013 at 5:45 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/25/13 12:09 PM, InvTraySts wrote:
>> So for instance, where I can run:
>> mount /dev/sda1 /media/tmp
>>
>> It will attempt to mount but complain about either a bad filesystem,
>> superblock, etc.
>
> that's userspace mount; look at dmesg to see what really went wrong.
>
>> If I try to mount the cloned drive:
>> mount: you must specify the filesystem type
>>
>> Looking back at dmesg the results are different:
>> [767942.335569] JBD2: Invalid start block of journal: 0
>> [767942.335572] EXT4-fs (sda1): error loading journal
>> [767947.740996] EXT3-fs (sdf1): error: can't find ext3 filesystem on dev sdf1.
>> [767947.741123] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem
>> [767947.741253] FAT-fs (sdf1): invalid media value (0xad)
>> [767947.741255] FAT-fs (sdf1): Can't find a valid FAT filesystem
>> [767947.741403] EXT2-fs (sdf1): error: can't find an ext2 filesystem
>> on dev sdf1.
>> [767957.299593] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem
>
> ok, you did clone it wrong.  Maybe you cloned sdc to sdf1?  What do
>
> # blkid /dev/sdf1
>
> # blkid /dev/sdf
>
> say?
>
>> Looking at dumpe2fs for the filesystem on /dev/sdf1 (sdf is the cloned
>> drive, the actual drive, sda, is in the original e-mail)
>> root@server:~# dumpe2fs /dev/sdf1
>> dumpe2fs 1.42.5 (29-Jul-2012)
>> dumpe2fs: Bad magic number in super-block while trying to open /dev/sdf1
>> Couldn't find valid filesystem superblock.
>>
>> dd didn't say it had any errors, and the log file for ddrescue doesn't
>> appear to give any errors either. I can run it again though. Should
>> there be any difference in the command that I run this time? I was
>> under the impression that notrunc,noerror,sync would have been
>> suitable to clone the drive over.
>
> Should be.  I think maybe you must "missed."
>
> -Eric
>
