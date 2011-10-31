From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk failure
Date: Mon, 31 Oct 2011 12:25:18 +0800
Message-ID: <CAGBYx2b62skKsU8c2A8GepVQxj+7_NJSFTDFwJ+9cU8jstU_6A@mail.gmail.com>
References: <Pine.LNX.4.64.1110300257510.32513@hytron.hytron.net>
	<20111030190548.2febafc0@notabene.brown>
	<Pine.LNX.4.64.1110301833180.1168@hytron.hytron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: NeilBrown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Darko <darko@hytron.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1JaEZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 00:25:19 -0400
In-Reply-To: <Pine.LNX.4.64.1110301833180.1168@hytron.hytron.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darko,

The bug has been fixed by commit 0449641130 ext4: Init timer earlier
to avoid a kernel panic in __save_error_info.
http://lists.openwall.net/linux-ext4/2011/03/29/5


I suspect you mounted ext2/3 partition using ext4 module.


Yongqiang.

On Mon, Oct 31, 2011 at 11:13 AM, Darko <darko@hytron.net> wrote:
> Thank you for your reply!
>
> I wanted to add to this that I was able to replicate the problem with=
 ext3
> and ext2 file systems as well. They both hard lock the system, and th=
e only
> way to recovery is to push the reset button. I can see the trace erro=
r on
> the screen, but I am unable to do anything with it, since it goes by =
so fast
> that the portion which says "kernel BUG" is invisible. I assume they =
both
> have similar issues with the code in kernel/timer.c
>
> On the other hand, I tried using raiserfs 3.5 tonight, and I got
> input/output error as expected. The system did not crash. Just anothe=
r proof
> that a bug is laying somewhere in the ext2/3/4 file system.
>
> When someone comes up with a patch, I am willing to try it out and fe=
ed you
> back with the report.
>
> Hope this helps.
>
> Thank You,
>
> Darko Kraus
>
>
> On Sun, 30 Oct 2011, NeilBrown wrote:
>
>> Date: Sun, 30 Oct 2011 19:05:48 +1100
>> From: NeilBrown <neilb@suse.de>
>> To: Darko <darko@hytron.net>
>> Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.o=
rg,
>> =A0 =A0linux-ext4@vger.kernel.org
>> Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk
>> failure
>>
>> On Sun, 30 Oct 2011 03:27:28 -0400 (EDT) Darko <darko@hytron.net> wr=
ote:
>>
>>> Hello,
>>>
>>> I have been doing some testing with the md RAID driver and I think =
I
>>> discovered a problem with it.
>>> Everything was performed on a system with a single hard drive using=
 loop
>>> devices as virtual raid devices.
>>> So here is the setup:
>>> /dev/sdc is my main drive that hold entire Linux OS and has one
>>> partition.
>>> in the /tmp I created 7 files, 100MB each and associated them with =
loop
>>> devices:
>>>
>>> losetup -a
>>> /dev/loop0: [0821]:294820 (/var/tmp/raid-0)
>>> /dev/loop1: [0821]:294857 (/var/tmp/raid-1)
>>> /dev/loop2: [0821]:300120 (/var/tmp/raid-2)
>>> /dev/loop3: [0821]:301073 (/var/tmp/raid-3)
>>> /dev/loop4: [0821]:301074 (/var/tmp/raid-4)
>>> /dev/loop5: [0821]:301075 (/var/tmp/raid-5)
>>> /dev/loop6: [0821]:301076 (/var/tmp/raid-6)
>>>
>>> The next step was, created an RAID6 array:
>>> mdadm --create /dev/md10 --level=3D6 -raid-deviced=3D7 /dev/loop[0-=
6]
>>>
>>> Here is how it looks so far:
>>>
>>> cat /proc/mdstat
>>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>>> md10 : active raid6 loop6[6] loop5[5] loop4[4] loop3[3] loop2[2] lo=
op1[1]
>>> loop0[0]
>>> =A0 =A0 =A0 499200 blocks super 1.2 level 6, 512k chunk, algorithm =
2 [7/7]
>>> [UUUUUUU]
>>>
>>>
>>> Then the filesystem...
>>> mkfs.ext4 -b 4096 -i 4096 -m 0 /dev/md10
>>>
>>> Mounting the file system to a folder called 'A' right in the root o=
f my
>>> system:
>>>
>>> mount /dev/md10 /A
>>>
>>> Then I copied a few files on that file system. So far everything is=
 good.
>>>
>>> Then I purposly failed 2 drives:
>>> mdadm --manage /dev/md10 --fail /dev/loop0
>>> mdadm --manage /dev/md10 --fail /dev/loop1
>>>
>>> The array continues to run fine in degraded mode. I was wondering w=
hat
>>> would happen if another drive fails. So while I was doing a write
>>> operating right in that filesystem (/dev/md10) using:
>>> dd if=3D/dev/zero of=3Dtestfile bs=3D1k count=3D360000 =A0...
>>>
>>> ...quickly switched to a different console and entered the command:
>>> mdadm --manage /dev/md10 --fail /dev/loop2
>>>
>>> ...which made 3 failed drives and the array can no longer work...
>>>
>>> Well I would be happy to see just the array not working, but kernel=
 panic
>>> in both versions 2.6.37.4 and 3.0.8 made me worry that it is seriou=
s bug
>>> and appears to be in older and newer kernels as well.
>>> I repeated this several times, and mostly the machine gets locked u=
p with
>>> kernel panic. But once I was able to get it not to lock up all the =
way,
>>> and that is how I have dmesg output.
>>>
>>> The attached files include dmesg from the system startup until the =
bug
>>> trace, and some additional information regarding my system that mig=
ht be
>>> helpful.
>>>
>>> For any additional question, please feel free to contact me!
>>>
>>> I hope this info helps someone find and resolve the problem in the =
code.
>>>
>>
>> The important part of your kernel log message is:
>>
>>
>> [ 1227.766202] ------------[ cut here ]------------
>> [ 1227.766259] kernel BUG at kernel/timer.c:681!
>> [ 1227.766311] invalid opcode: 0000 [#1] SMP
>> [ 1227.766365] last sysfs file: /sys/devices/virtual/block/md10/dev
>> [ 1227.766419] Modules linked in:
>> [ 1227.766471]
>> [ 1227.766520] Pid: 1507, comm: mount Not tainted 2.6.37.6-v5.0 #7
>> MICRO-STAR INTERNATIONAL CO., LTD MS-7142/MS-7142
>> [ 1227.766633] EIP: 0060:[<c104f960>] EFLAGS: 00010246 CPU: 0
>> [ 1227.766690] EIP is at mod_timer+0x210/0x250
>> [ 1227.766742] EAX: 00000000 EBX: f5494e1c ECX: 00000000 EDX: 000000=
00
>> [ 1227.766796] ESI: 00000000 EDI: 05348416 EBP: f54a3c90 ESP: f54a3c=
74
>> [ 1227.766851] =A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [ 1227.766904] Process mount (pid: 1507, ti=3Df54a2000 task=3Df20688=
80
>> task.ti=3Df54a2000)
>> [ 1227.767002] Stack:
>> [ 1227.767003] =A0f2068880 f54b159c 00000010 00000000 f1f8e400 f4efc=
57c
>> 0000128d f54a3ca8
>> [ 1227.767003] =A0c11cb7ba c17d4e52 f4efc400 00000124 00000000 f54a3=
cb4
>> c11ce4e6 ecee6318
>> [ 1227.767003] =A0f54a3cdc c11cf7cc ecec7578 00000124 00000000 f4efc=
400
>> f54a3cd4 00000124
>> [ 1227.767003] Call Trace:
>> [ 1227.767003] =A0[<c11cb7ba>] ? __save_error_info.clone.61+0x7a/0xf=
0
>> [ 1227.767003] =A0[<c11ce4e6>] ? save_error_info+0x16/0x30
>> [ 1227.767003] =A0[<c11cf7cc>] ? ext4_error_inode+0x4c/0xf0
>> [ 1227.767003] =A0[<c11b57e1>] ? __ext4_get_inode_loc+0x201/0x410
>> [ 1227.767003] =A0[<c110b62a>] ? inode_init_always+0x1aa/0x1c0
>> [ 1227.767003] =A0[<c11b72f9>] ? ext4_iget+0x59/0x6f0
>> [ 1227.767003] =A0[<c11d2716>] ? ext4_fill_super+0x1ab6/0x2c70
>> [ 1227.767003] =A0[<c114896f>] ? disk_name+0xbf/0xd0
>> [ 1227.767003] =A0[<c10fa119>] ? mount_bdev+0x179/0x1c0
>> [ 1227.767003] =A0[<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
>> [ 1227.767003] =A0[<c11ca17f>] ? ext4_mount+0x1f/0x30
>> [ 1227.767003] =A0[<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
>> [ 1227.767003] =A0[<c10f9835>] ? vfs_kern_mount+0x75/0x250
>> [ 1227.767003] =A0[<c110df03>] ? get_fs_type+0x33/0xb0
>> [ 1227.767003] =A0[<c11ca160>] ? ext4_mount+0x0/0x30
>> [ 1227.767003] =A0[<c10f9a6e>] ? do_kern_mount+0x3e/0xe0
>> [ 1227.767003] =A0[<c111080f>] ? do_mount+0x35f/0x6b0
>> [ 1227.767003] =A0[<c10d47c9>] ? strndup_user+0x49/0x70
>> [ 1227.767003] =A0[<c1110e0b>] ? sys_mount+0x6b/0xa0
>> [ 1227.767003] =A0[<c17b550c>] ? syscall_call+0x7/0xb
>> [ 1227.767003] Code: fe ff ff 8b 0e 89 4d e4 8b 46 04 83 c6 08 89 f9=
 89 da
>> ff 55 e4 8b 06 85 c0 89 45 e4 75 ea e9 aa fe ff ff 8b 75 ec e9 ee fe=
 ff ff
>> <0f> 0b 8b 55 04 89 d8 e8 34 f9 ff ff e9 2a fe ff ff 8b 35 30 b8
>> [ 1227.767003] EIP: [<c104f960>] mod_timer+0x210/0x250 SS:ESP
>> 0068:f54a3c74
>> [ 1227.770073] ---[ end trace d7b3d7a67954d202 ]---
>>
>>
>> which happens after:
>>
>> [ 1137.167043] Aborting journal on device md10-8.
>> [ 1137.167058] Buffer I/O error on device md10, logical block 139265
>> [ 1137.167060] lost page write due to I/O error on md10
>> [ 1137.167065] JBD2: I/O error detected when updating journal superb=
lock
>> for md10-8.
>> [ 1137.660922] Buffer I/O error on device md10, logical block 1
>> [ 1137.660926] lost page write due to I/O error on md10
>> [ 1137.660932] EXT4-fs error (device md10): ext4_journal_start_sb:26=
0:
>> Detected aborted journal
>> [ 1137.661046] EXT4-fs (md10): Remounting filesystem read-only
>> [ 1137.661103] EXT4-fs (md10): previous I/O error to superblock dete=
cted
>> [ 1137.661313] Buffer I/O error on device md10, logical block 1
>> [ 1137.661315] lost page write due to I/O error on md10
>> [ 1219.891363] EXT4-fs (md10): previous I/O error to superblock dete=
cted
>> [ 1220.050654] Buffer I/O error on device md10, logical block 1
>> [ 1220.050657] lost page write due to I/O error on md10
>> [ 1220.050663] EXT4-fs error (device md10): ext4_put_super:728: Coul=
dn't
>> clean up the journal
>>
>> and some more "Buffer I/O error"s.
>>
>> So it looks like an ext4 issue.
>>
>> I have Cc:ed the appropriate list.
>>
>> Thanks for the report.
>>
>> NeilBrown
>>
>>
>
>
> --
> Darko Kraus
> Enterprise Network Administrator
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
