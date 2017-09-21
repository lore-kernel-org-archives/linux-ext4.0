From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: File system corruption after reboot, when rootfs in mounted over
 nfs
Date: Thu, 21 Sep 2017 10:24:38 +0200
Message-ID: <20170921082438.qpttlfzkbduzm4i3@rh_laptop>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
 <CAPXMrf-4kyxVWngN=RFu3gDsSCVbCt-SThmG31EFC6dHgg20Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: RAJESH DASARI <raajeshdasari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdIUIYl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Sep 2017 04:24:41 -0400
Content-Disposition: inline
In-Reply-To: <CAPXMrf-4kyxVWngN=RFu3gDsSCVbCt-SThmG31EFC6dHgg20Hw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 21, 2017 at 09:41:57AM +0530, RAJESH DASARI wrote:
> Could someone please respond to my query.

Hi,

Ted already did, with some questions.

https://www.spinics.net/lists/linux-ext4/msg58327.html

-Lukas

> 
> Thanks,
> Rajesh Dasari.
> 
> 
> On Mon, Sep 18, 2017 at 4:14 PM, RAJESH DASARI <raajeshdasari@gmail.com> wrote:
> > Hi ,
> >
> > Could some one please help me with the below issue.
> >
> > I have  booted a mips based hardware with linux (4.4.36 kernel
> > )image(over tftp) and rootfs over nfs by passing nfsroot command line
> > option to the kernel.
> >
> > rootfs is mounted under / in my hardware environment.
> >
> > 192.168.113.254:/rootfs / type nfs
> > (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.113.254,mountvers=3,mountproto=tcp,local_lock=all,addr=192.168.113.254)
> >
> > I have a hard disk and i am mounting  it on /mnt , this /mnt directory
> > is part of nfsroot.
> >
> > e2fsck -f -y /dev/sda1 -> disk is clean with no errors.
> >
> > mount -t ext2 /dev/sda1 /mnt  (mount was successful ,mounting ext2 using ext4)
> > touch /mnt/test.log  -> this command is failing.
> > umount /mnt
> > reboot
> >
> > when i was executing the above commands in a loop i see that /dev/sda1
> > file system is getting corrupted. touch command is failing with
> > "ext4_find_dest_de:1809: inode #2: block 771: comm touch: bad entry in
> > directory: rec_len %4 !=0 -offset =0(0),
> > inode=4278190080,rec_len=54507,name_len=229 touch : cannot touch
> > /mnt/test.log structure needs clearing" error. I am able to reproduce
> > this issue always when i boot rootfs over nfs , if i boot from hard
> > disk , i am not noticing the issue .
> >
> >
> >
> > Could someone please help me on this , what could cause the ext4 file
> > system corruption.
> >
> > Thanks,
> > Rajesh Dasari.
