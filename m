From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 16:45:35 -0500
Message-ID: <5243597F.1010108@redhat.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com> <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com> <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com> <524302D5.10701@redhat.com> <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com> <52431462.1090906@redhat.com> <CAOWv6b3_DbKjD5aGa1g-zEbVyJOar7NXLbaVA8ZKx+9s62bO2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3IYVpi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 17:45:38 -0400
In-Reply-To: <CAOWv6b3_DbKjD5aGa1g-zEbVyJOar7NXLbaVA8ZKx+9s62bO2A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/25/13 12:09 PM, InvTraySts wrote:
> So for instance, where I can run:
> mount /dev/sda1 /media/tmp
> 
> It will attempt to mount but complain about either a bad filesystem,
> superblock, etc.

that's userspace mount; look at dmesg to see what really went wrong.

> If I try to mount the cloned drive:
> mount: you must specify the filesystem type
> 
> Looking back at dmesg the results are different:
> [767942.335569] JBD2: Invalid start block of journal: 0
> [767942.335572] EXT4-fs (sda1): error loading journal
> [767947.740996] EXT3-fs (sdf1): error: can't find ext3 filesystem on dev sdf1.
> [767947.741123] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem
> [767947.741253] FAT-fs (sdf1): invalid media value (0xad)
> [767947.741255] FAT-fs (sdf1): Can't find a valid FAT filesystem
> [767947.741403] EXT2-fs (sdf1): error: can't find an ext2 filesystem
> on dev sdf1.
> [767957.299593] EXT4-fs (sdf1): VFS: Can't find ext4 filesystem

ok, you did clone it wrong.  Maybe you cloned sdc to sdf1?  What do

# blkid /dev/sdf1

# blkid /dev/sdf

say?

> Looking at dumpe2fs for the filesystem on /dev/sdf1 (sdf is the cloned
> drive, the actual drive, sda, is in the original e-mail)
> root@server:~# dumpe2fs /dev/sdf1
> dumpe2fs 1.42.5 (29-Jul-2012)
> dumpe2fs: Bad magic number in super-block while trying to open /dev/sdf1
> Couldn't find valid filesystem superblock.
> 
> dd didn't say it had any errors, and the log file for ddrescue doesn't
> appear to give any errors either. I can run it again though. Should
> there be any difference in the command that I run this time? I was
> under the impression that notrunc,noerror,sync would have been
> suitable to clone the drive over.

Should be.  I think maybe you must "missed."

-Eric

