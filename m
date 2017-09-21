From: RAJESH DASARI <raajeshdasari@gmail.com>
Subject: Re: File system corruption after reboot, when rootfs in mounted over nfs
Date: Thu, 21 Sep 2017 09:41:57 +0530
Message-ID: <CAPXMrf-4kyxVWngN=RFu3gDsSCVbCt-SThmG31EFC6dHgg20Hw@mail.gmail.com>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:51338 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdIUEL6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Sep 2017 00:11:58 -0400
Received: by mail-it0-f51.google.com with SMTP id o200so5138870itg.0
        for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2017 21:11:58 -0700 (PDT)
In-Reply-To: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Could someone please respond to my query.

Thanks,
Rajesh Dasari.


On Mon, Sep 18, 2017 at 4:14 PM, RAJESH DASARI <raajeshdasari@gmail.com> wrote:
> Hi ,
>
> Could some one please help me with the below issue.
>
> I have  booted a mips based hardware with linux (4.4.36 kernel
> )image(over tftp) and rootfs over nfs by passing nfsroot command line
> option to the kernel.
>
> rootfs is mounted under / in my hardware environment.
>
> 192.168.113.254:/rootfs / type nfs
> (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.113.254,mountvers=3,mountproto=tcp,local_lock=all,addr=192.168.113.254)
>
> I have a hard disk and i am mounting  it on /mnt , this /mnt directory
> is part of nfsroot.
>
> e2fsck -f -y /dev/sda1 -> disk is clean with no errors.
>
> mount -t ext2 /dev/sda1 /mnt  (mount was successful ,mounting ext2 using ext4)
> touch /mnt/test.log  -> this command is failing.
> umount /mnt
> reboot
>
> when i was executing the above commands in a loop i see that /dev/sda1
> file system is getting corrupted. touch command is failing with
> "ext4_find_dest_de:1809: inode #2: block 771: comm touch: bad entry in
> directory: rec_len %4 !=0 -offset =0(0),
> inode=4278190080,rec_len=54507,name_len=229 touch : cannot touch
> /mnt/test.log structure needs clearing" error. I am able to reproduce
> this issue always when i boot rootfs over nfs , if i boot from hard
> disk , i am not noticing the issue .
>
>
>
> Could someone please help me on this , what could cause the ext4 file
> system corruption.
>
> Thanks,
> Rajesh Dasari.
