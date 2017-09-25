From: RAJESH DASARI <raajeshdasari@gmail.com>
Subject: Re: File system corruption after reboot, when rootfs in mounted over nfs
Date: Mon, 25 Sep 2017 11:05:24 +0530
Message-ID: <CAPXMrf87tQMUqw0yXncNvYa4z3Sojv-6VbMjLo1By_n-EETo6w@mail.gmail.com>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
 <20170919132518.krlzjckc4z46ichy@thunk.org> <CAPXMrf8ykZ_h84+O67fe6640rN6gTPT+YvCCVrMY+jBKzEu=3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37852 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753225AbdIYFfZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Sep 2017 01:35:25 -0400
Received: by mail-io0-f193.google.com with SMTP id 93so2411411iol.4
        for <linux-ext4@vger.kernel.org>; Sun, 24 Sep 2017 22:35:25 -0700 (PDT)
In-Reply-To: <CAPXMrf8ykZ_h84+O67fe6640rN6gTPT+YvCCVrMY+jBKzEu=3w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Thanks Ted for your reply , Please find my response in line and
please let me know if any other logs are needed.

Thanks,
Rajesh Dasari.


On Mon, Sep 25, 2017 at 10:53 AM, RAJESH DASARI <raajeshdasari@gmail.com> wrote:
> Thanks,
> Rajesh Dasari.
>
>
> On Tue, Sep 19, 2017 at 6:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Sep 18, 2017 at 04:14:35PM +0530, RAJESH DASARI wrote:
>>>
>>> Could some one please help me with the below issue.
>>>
>>> I have  booted a mips based hardware with linux (4.4.36 kernel
>>> )image(over tftp) and rootfs over nfs by passing nfsroot command line
>>> option to the kernel.
>>>
>>> rootfs is mounted under / in my hardware environment.
>>>
>>> 192.168.113.254:/rootfs / type nfs
>>> (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.113.254,mountvers=3,mountproto=tcp,local_lock=all,addr=192.168.113.254)
>>>
>>> I have a hard disk and i am mounting  it on /mnt , this /mnt directory
>>> is part of nfsroot.
>>>
>>> e2fsck -f -y /dev/sda1 -> disk is clean with no errors.
>>>
>>> mount -t ext2 /dev/sda1 /mnt  (mount was successful ,mounting ext2 using ext4)
>>> touch /mnt/test.log  -> this command is failing.
>>> umount /mnt
>>> reboot
>>>
>>> when i was executing the above commands in a loop i see that /dev/sda1
>>> file system is getting corrupted.
>>
>> The above commands include running e2fsck?  Then it sounds like there
>> is some kind of device driver bug.
      yeah. e2fsck command also included and all the above commands
were executed in a loop.
>
>>
>> What if you include an e2fsck -f -y /dev/sda1 after the umount?  Can
>> you capture the output from that e2fsck run?
    I tried running e2fsck after unmount also , i still see the issue
. Here is the output of e2fsck after
    unmount .


e2fsck -f -y /dev/sda1
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
 Pass 5: Checking group summary information /dev/sda1: 12/262144 files
(0.0% non-contiguous), 18510/1048576 blocks

e2fsck return code was 0. after executing e2fsck, i rebooted the node
and when i  mount the Hard disk it is failed with the below error.

[ 87.685184] EXT4-fs (sda1): mounting ext2 file system using the ext4
subsystem [ 87.694393] EXT4-fs error (device sda1): ext4_iget:4337:
inode #2: comm mount: bad extended attribute block 4278190080 [
87.707920] EXT4-fs (sda1): get root inode failed [ 87.712639] EXT4-fs
(sda1): mount failed mount: mounting /dev/sda1 on /mnt failed:
Structure needs cleaning

>>
>>> I am able to reproduce
>>> this issue always when i boot rootfs over nfs , if i boot from hard
>>> disk , i am not noticing the issue .
>>
>> Is it exactly the same kernel in both cases?
     Kernel version and steps executed hardware environment everything
is same in both the cases.
>>
>> More detailed logs would certainly be helpful.  There's not enough
>> detail in your description to do anything other than guess, since
>> we're not mind readers....
>>
>>                                                 - Ted
