From: Kamran Khan <krkhan@inspirated.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while unmounting
Date: Tue, 17 May 2016 18:33:05 -0700
Message-ID: <CAN0j2-fqEqXDCWnokqZPRzn_mamAShwXo2JPzUrugwYyw9ws9g@mail.gmail.com>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36514 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcERBdI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 21:33:08 -0400
Received: by mail-vk0-f48.google.com with SMTP id s184so42931536vkb.3
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 18:33:07 -0700 (PDT)
In-Reply-To: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Found the same issue in a thread from last year:

http://lists.openwall.net/linux-ext4/2015/02/18/6

Basically, it's got nothing to do with my root fs manipulations. The
problem is: after unmounting an ext4 filesystem jbd2 holds a lock to
it forever. It's impossible to do anything with the block device,
e.g., e2fsck fails because open fails with -EBUSY.

The thread became stale. I'll be glad to help with collection of any
additional information.

On Tue, May 17, 2016 at 5:46 PM, Kamran Khan <krkhan@inspirated.com> wrote:
> I'm trying to understand the difference in jbd2 behavior across Ubuntu
> 14.04 and Centos 7.1. Will appreciate any help.
>
> The uber goal is to resize the root filesystem without a reboot.
> Basically, all the necessary files are copied to a tmpfs, a pivot_root
> is performed then the old root is unmounted.
>
> On Ubuntu 14.04, after the old processes are killed I verify that no
> processes are holding handles to oldroot.
>
>> root@kakhan-ubuntu:~# fuser -vm /oldroot
>>                      USER        PID ACCESS COMMAND
>> /oldroot:            root     kernel mount /oldroot
>
> jbd2 is still running:
>
>> root@kakhan-ubuntu:~# lsof | grep sda1
>> jbd2/sda1  176            root  cwd       DIR               0,19      340          2 /
>> jbd2/sda1  176            root  rtd       DIR               0,19      340          2 /
>> jbd2/sda1  176            root  txt   unknown                                        /proc/176/exe
>> root@kakhan-ubuntu:~# ps -f -p 176
>> UID        PID  PPID  C STIME TTY          TIME CMD
>> root       176     2  0 17:19 ?        00:00:00 [jbd2/sda1-8]
>
> I can unmount the filesystem and do an fsck:
>
>> root@kakhan-ubuntu:~# umount /oldroot
>> root@kakhan-ubuntu:~# e2fsck -yf /dev/sda1
>> ...
>> /dev/sda1: 64967/1831424 files (0.1% non-contiguous), 480018/7323904 blocks
>
> jbd2 does *not* hold a handle to the now unmounted filesystem:
>
>> root@kakhan-ubuntu:~# lsof | grep sda1
>> root@kakhan-ubuntu:~#
>
> All good.
>
> On CentOS 7.1, I verify that no processed are holding handle to oldroot.
>
>> [root@kakhan-centos ~]# fuser -vm /oldroot
>>                      USER        PID ACCESS COMMAND
>> /oldroot:            root     kernel mount /oldroot
>
> I can successfully unmount the filesystem but can't fsck it:
>
>> [root@kakhan-centos ~]# umount /oldroot
>> [root@kakhan-centos ~]# e2fsck -yf /dev/sda1
>> e2fsck 1.42.9 (28-Dec-2013)
>> /dev/sda1 is in use.
>> e2fsck: Cannot continue, aborting.
>
> /dev/sda1 does not appear in /proc/mounts. Looks like jbd2 is the only
> thing that looks like it still cares about sda1:
>
>> [root@kakhan-centos ~]# lsof | grep sda1
>> jbd2/sda1  394      root  cwd       DIR               0,14       340      22591 /
>> jbd2/sda1  394      root  rtd       DIR               0,14       340      22591 /
>> jbd2/sda1  394      root  txt   unknown                                         /proc/394/exe
>> [root@kakhan-centos ~]# ps -f -p 394
>> UID        PID  PPID  C STIME TTY          TIME CMD
>> root       394     2  0 00:15 ?        00:00:00 [jbd2/sda1-8]
>
> What I'm confused about is, why is the behavior different even though
> journaling is _enabled_ in *both* cases?
>
> On Ubuntu:
>
>> root@kakhan-ubuntu:~# dumpe2fs /dev/sda1 | grep features
>> dumpe2fs 1.42.9 (4-Feb-2014)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
>> Journal features:         journal_incompat_revoke
>
> On CentOS:
>
>> [root@kakhan-centos ~]# dumpe2fs /dev/sda1 | grep features
>> dumpe2fs 1.42.9 (28-Dec-2013)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
>> Journal features:         journal_incompat_revoke journal_64bit
>
> Any ideas?
>
> Thanks,
> --
> Kamran.
>
> http://inspirated.com/



-- 
Kamran.

http://inspirated.com/
