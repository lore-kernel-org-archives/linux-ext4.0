From: RAJESH DASARI <raajeshdasari@gmail.com>
Subject: Re: File system corruption after reboot, when rootfs in mounted over nfs
Date: Mon, 25 Sep 2017 10:53:30 +0530
Message-ID: <CAPXMrf8ykZ_h84+O67fe6640rN6gTPT+YvCCVrMY+jBKzEu=3w@mail.gmail.com>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
 <20170919132518.krlzjckc4z46ichy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:37997 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753276AbdIYFXb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Sep 2017 01:23:31 -0400
Received: by mail-it0-f66.google.com with SMTP id 85so3466604ith.5
        for <linux-ext4@vger.kernel.org>; Sun, 24 Sep 2017 22:23:31 -0700 (PDT)
In-Reply-To: <20170919132518.krlzjckc4z46ichy@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks,
Rajesh Dasari.


On Tue, Sep 19, 2017 at 6:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Sep 18, 2017 at 04:14:35PM +0530, RAJESH DASARI wrote:
>>
>> Could some one please help me with the below issue.
>>
>> I have  booted a mips based hardware with linux (4.4.36 kernel
>> )image(over tftp) and rootfs over nfs by passing nfsroot command line
>> option to the kernel.
>>
>> rootfs is mounted under / in my hardware environment.
>>
>> 192.168.113.254:/rootfs / type nfs
>> (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.113.254,mountvers=3,mountproto=tcp,local_lock=all,addr=192.168.113.254)
>>
>> I have a hard disk and i am mounting  it on /mnt , this /mnt directory
>> is part of nfsroot.
>>
>> e2fsck -f -y /dev/sda1 -> disk is clean with no errors.
>>
>> mount -t ext2 /dev/sda1 /mnt  (mount was successful ,mounting ext2 using ext4)
>> touch /mnt/test.log  -> this command is failing.
>> umount /mnt
>> reboot
>>
>> when i was executing the above commands in a loop i see that /dev/sda1
>> file system is getting corrupted.
>
> The above commands include running e2fsck?  Then it sounds like there
> is some kind of device driver bug.
    yeah.

>
> What if you include an e2fsck -f -y /dev/sda1 after the umount?  Can
> you capture the output from that e2fsck run?
>
>> I am able to reproduce
>> this issue always when i boot rootfs over nfs , if i boot from hard
>> disk , i am not noticing the issue .
>
> Is it exactly the same kernel in both cases?
>
> More detailed logs would certainly be helpful.  There's not enough
> detail in your description to do anything other than guess, since
> we're not mind readers....
>
>                                                 - Ted
