From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: File system corruption after reboot, when rootfs in mounted over
 nfs
Date: Tue, 19 Sep 2017 09:25:18 -0400
Message-ID: <20170919132518.krlzjckc4z46ichy@thunk.org>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: RAJESH DASARI <raajeshdasari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56738 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdISN1e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Sep 2017 09:27:34 -0400
Content-Disposition: inline
In-Reply-To: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 18, 2017 at 04:14:35PM +0530, RAJESH DASARI wrote:
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
> file system is getting corrupted.

The above commands include running e2fsck?  Then it sounds like there
is some kind of device driver bug.

What if you include an e2fsck -f -y /dev/sda1 after the umount?  Can
you capture the output from that e2fsck run?

> I am able to reproduce
> this issue always when i boot rootfs over nfs , if i boot from hard
> disk , i am not noticing the issue .

Is it exactly the same kernel in both cases?

More detailed logs would certainly be helpful.  There's not enough
detail in your description to do anything other than guess, since
we're not mind readers....

						- Ted
