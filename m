From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: /dev/disk/by-label missing after upgrade to 1.42.7
Date: Thu, 13 Jun 2013 15:45:05 -0400
Message-ID: <CADzUK1+D2NJ3WC4jz-HKHQGyF7GGKGytLnA=bvGHsL5iNa-hMw@mail.gmail.com>
References: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:50330 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3FMTpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 15:45:07 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so7351161lab.25
        for <linux-ext4@vger.kernel.org>; Thu, 13 Jun 2013 12:45:05 -0700 (PDT)
In-Reply-To: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 13, 2013 at 2:55 PM, Autif Khan <autif.mlist@gmail.com> wrote:
> Hi,
>
> We are using /dev/disk/by-label/OURLABEL to mount USB disk partitions.
>
> We were using Ubuntu 12.04 with 1.42 version of e2fsprogs - where we
> encountered SSD corruption issues on unclean powerdown. It was
> suggested that we upgrade to the latest e2fsprogs
> (http://marc.info/?l=linux-ext4&m=137035378614543&w=2).
>
> After the upgrade to 1.42.7, we do not have /dev/disk/by-label
>
> I am not sure if this is the right place to ask this - but I thought
> that I should start here and ask in udev mailing list later - (that
> whole thing about correlation mumble causation).
>
> I am still researching how /dev/disk/by-label comes into existence -
> please advice if there is something obvious that I am missing.
>

Thanks djwong#ext4 for all the help on IRC

It seems like blkid -o udev /dev/sdb1 displays info about the volume -
which is used by udev rules to populates /dev/disk/by-label

The output when e2fsprogs version 1.42 was used:

ubuntu@mac0013950af6fb:/lib/udev/rules.d$ sudo blkid -o udev -p /dev/sdb1
ID_FS_LABEL=KOKO
ID_FS_LABEL_ENC=KOKO
ID_FS_UUID=56D8-F5EE
ID_FS_UUID_ENC=56D8-F5EE
ID_FS_VERSION=FAT32
ID_FS_TYPE=vfat
ID_FS_USAGE=filesystem
ID_PART_ENTRY_SCHEME=dos
ID_PART_ENTRY_TYPE=0xb
ID_PART_ENTRY_FLAGS=0x80
ID_PART_ENTRY_NUMBER=1
ID_PART_ENTRY_OFFSET=32
ID_PART_ENTRY_SIZE=251616
ID_PART_ENTRY_DISK=8:16


The output when e2fsprogs version 1.42.7 was used:
ubuntu@mac001395089897:~$ sudo blkid -o udev /dev/sda1
Invalid output format udev. Choose from value,
    device, list, or full

BTW, sudo blkid -o full /dev/sdb1 worked just fine - had the LABEL and
everything.

Also - looks like 1.42.7 does not support the -p option. From the man page:

-p     Switch to low-level superblock probing mode (bypass cache).

Is there a configuration option that will allow blkid to display udev
output formats? I could not find with ./configure --help

Thanks

Autif
