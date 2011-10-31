From: Darko <darko@hytron.net>
Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk failure
Date: Mon, 31 Oct 2011 01:13:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110310108500.1654@hytron.hytron.net>
References: <Pine.LNX.4.64.1110300257510.32513@hytron.hytron.net>
 <20111030190548.2febafc0@notabene.brown> <Pine.LNX.4.64.1110301833180.1168@hytron.hytron.net>
 <CAGBYx2b62skKsU8c2A8GepVQxj+7_NJSFTDFwJ+9cU8jstU_6A@mail.gmail.com>
 <Pine.LNX.4.64.1110310045120.1603@hytron.hytron.net>
 <CAGBYx2bN7Gxm1PWJwm3Vf0-yikyo9H_xnCiGNetLVQagMRJbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-2006745895-1935391497-1320037999=:1654"
Cc: NeilBrown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adsl-99-136-217-124.dsl.sfldmi.sbcglobal.net ([99.136.217.124]:58540
	"EHLO hytron.hytron.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1JaFQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 01:16:45 -0400
In-Reply-To: <CAGBYx2bN7Gxm1PWJwm3Vf0-yikyo9H_xnCiGNetLVQagMRJbTQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2006745895-1935391497-1320037999=:1654
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Yongqiang,

I am unable to catch the dmesg, since the system locks up and I have to=20
mechanically reset it.
I have attached the same error with kernel version 2.6.37.6. Out of=20
approximately 10 times that happened yesterday, I was able to catch it=20
once...the system remained partially responsive that time.


Thanks,

Darko

On Mon, 31 Oct 2011, Yongqiang Yang wrote:

> Date: Mon, 31 Oct 2011 12:57:03 +0800
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> To: Darko <darko@hytron.net>
> Cc: NeilBrown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
>     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
> Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk fail=
ure
>=20
> On Mon, Oct 31, 2011 at 12:51 PM, Darko <darko@hytron.net> wrote:
>> Hi Yongqiang,
>>
>> I am using kernel version 3.0.8. Looking through the file super.c, the f=
ile
>> already has the code mentioned on the web. I also noticed the date of th=
e
>> post (http://lists.openwall.net/linux-ext4/2011/03/29/5) is back from Ma=
rch
>> of 2011. I think the bug I reported here was not fixed by that patch sin=
ce
>> the kernel version I am using is much newer than March 2011.
> Could you post out the dmesg log printed by 3.0.8 or 3.1?
>
> Yongqiang.
>>
>> I am not sure if I understand what you mean by "commit 0449641130 ext4"?
>>
>> Thanks,
>>
>> Darko
>>
>>
>> On Mon, 31 Oct 2011, Yongqiang Yang wrote:
>>
>>> Date: Mon, 31 Oct 2011 12:25:18 +0800
>>> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>> To: Darko <darko@hytron.net>
>>> Cc: NeilBrown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
>>> =A0 =A0linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
>>> Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk
>>> failure
>>>
>>> Hi Darko,
>>>
>>> The bug has been fixed by commit 0449641130 ext4: Init timer earlier
>>> to avoid a kernel panic in __save_error_info.
>>> http://lists.openwall.net/linux-ext4/2011/03/29/5
>>>
>>>
>>> I suspect you mounted ext2/3 partition using ext4 module.
>>>
>>>
>>> Yongqiang.
>>>
>>> On Mon, Oct 31, 2011 at 11:13 AM, Darko <darko@hytron.net> wrote:
>>>>
>>>> Thank you for your reply!
>>>>
>>>> I wanted to add to this that I was able to replicate the problem with
>>>> ext3
>>>> and ext2 file systems as well. They both hard lock the system, and the
>>>> only
>>>> way to recovery is to push the reset button. I can see the trace error=
 on
>>>> the screen, but I am unable to do anything with it, since it goes by s=
o
>>>> fast
>>>> that the portion which says "kernel BUG" is invisible. I assume they b=
oth
>>>> have similar issues with the code in kernel/timer.c
>>>>
>>>> On the other hand, I tried using raiserfs 3.5 tonight, and I got
>>>> input/output error as expected. The system did not crash. Just another
>>>> proof
>>>> that a bug is laying somewhere in the ext2/3/4 file system.
>>>>
>>>> When someone comes up with a patch, I am willing to try it out and fee=
d
>>>> you
>>>> back with the report.
>>>>
>>>> Hope this helps.
>>>>
>>>> Thank You,
>>>>
>>>> Darko Kraus
>>>>
>>>>
>>>> On Sun, 30 Oct 2011, NeilBrown wrote:
>>>>
>>>>> Date: Sun, 30 Oct 2011 19:05:48 +1100
>>>>> From: NeilBrown <neilb@suse.de>
>>>>> To: Darko <darko@hytron.net>
>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.or=
g,
>>>>> =A0 =A0linux-ext4@vger.kernel.org
>>>>> Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk
>>>>> failure
>>>>>
>>>>> On Sun, 30 Oct 2011 03:27:28 -0400 (EDT) Darko <darko@hytron.net> wro=
te:
>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> I have been doing some testing with the md RAID driver and I think I
>>>>>> discovered a problem with it.
>>>>>> Everything was performed on a system with a single hard drive using
>>>>>> loop
>>>>>> devices as virtual raid devices.
>>>>>> So here is the setup:
>>>>>> /dev/sdc is my main drive that hold entire Linux OS and has one
>>>>>> partition.
>>>>>> in the /tmp I created 7 files, 100MB each and associated them with l=
oop
>>>>>> devices:
>>>>>>
>>>>>> losetup -a
>>>>>> /dev/loop0: [0821]:294820 (/var/tmp/raid-0)
>>>>>> /dev/loop1: [0821]:294857 (/var/tmp/raid-1)
>>>>>> /dev/loop2: [0821]:300120 (/var/tmp/raid-2)
>>>>>> /dev/loop3: [0821]:301073 (/var/tmp/raid-3)
>>>>>> /dev/loop4: [0821]:301074 (/var/tmp/raid-4)
>>>>>> /dev/loop5: [0821]:301075 (/var/tmp/raid-5)
>>>>>> /dev/loop6: [0821]:301076 (/var/tmp/raid-6)
>>>>>>
>>>>>> The next step was, created an RAID6 array:
>>>>>> mdadm --create /dev/md10 --level=3D6 -raid-deviced=3D7 /dev/loop[0-6=
]
>>>>>>
>>>>>> Here is how it looks so far:
>>>>>>
>>>>>> cat /proc/mdstat
>>>>>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>>>>>> md10 : active raid6 loop6[6] loop5[5] loop4[4] loop3[3] loop2[2]
>>>>>> loop1[1]
>>>>>> loop0[0]
>>>>>> =A0 =A0 =A0 499200 blocks super 1.2 level 6, 512k chunk, algorithm 2=
 [7/7]
>>>>>> [UUUUUUU]
>>>>>>
>>>>>>
>>>>>> Then the filesystem...
>>>>>> mkfs.ext4 -b 4096 -i 4096 -m 0 /dev/md10
>>>>>>
>>>>>> Mounting the file system to a folder called 'A' right in the root of=
 my
>>>>>> system:
>>>>>>
>>>>>> mount /dev/md10 /A
>>>>>>
>>>>>> Then I copied a few files on that file system. So far everything is
>>>>>> good.
>>>>>>
>>>>>> Then I purposly failed 2 drives:
>>>>>> mdadm --manage /dev/md10 --fail /dev/loop0
>>>>>> mdadm --manage /dev/md10 --fail /dev/loop1
>>>>>>
>>>>>> The array continues to run fine in degraded mode. I was wondering wh=
at
>>>>>> would happen if another drive fails. So while I was doing a write
>>>>>> operating right in that filesystem (/dev/md10) using:
>>>>>> dd if=3D/dev/zero of=3Dtestfile bs=3D1k count=3D360000 =A0...
>>>>>>
>>>>>> ...quickly switched to a different console and entered the command:
>>>>>> mdadm --manage /dev/md10 --fail /dev/loop2
>>>>>>
>>>>>> ...which made 3 failed drives and the array can no longer work...
>>>>>>
>>>>>> Well I would be happy to see just the array not working, but kernel
>>>>>> panic
>>>>>> in both versions 2.6.37.4 and 3.0.8 made me worry that it is serious
>>>>>> bug
>>>>>> and appears to be in older and newer kernels as well.
>>>>>> I repeated this several times, and mostly the machine gets locked up
>>>>>> with
>>>>>> kernel panic. But once I was able to get it not to lock up all the w=
ay,
>>>>>> and that is how I have dmesg output.
>>>>>>
>>>>>> The attached files include dmesg from the system startup until the b=
ug
>>>>>> trace, and some additional information regarding my system that migh=
t
>>>>>> be
>>>>>> helpful.
>>>>>>
>>>>>> For any additional question, please feel free to contact me!
>>>>>>
>>>>>> I hope this info helps someone find and resolve the problem in the
>>>>>> code.
>>>>>>
>>>>>
>>>>> The important part of your kernel log message is:
>>>>>
>>>>>
>>>>> [ 1227.766202] ------------[ cut here ]------------
>>>>> [ 1227.766259] kernel BUG at kernel/timer.c:681!
>>>>> [ 1227.766311] invalid opcode: 0000 [#1] SMP
>>>>> [ 1227.766365] last sysfs file: /sys/devices/virtual/block/md10/dev
>>>>> [ 1227.766419] Modules linked in:
>>>>> [ 1227.766471]
>>>>> [ 1227.766520] Pid: 1507, comm: mount Not tainted 2.6.37.6-v5.0 #7
>>>>> MICRO-STAR INTERNATIONAL CO., LTD MS-7142/MS-7142
>>>>> [ 1227.766633] EIP: 0060:[<c104f960>] EFLAGS: 00010246 CPU: 0
>>>>> [ 1227.766690] EIP is at mod_timer+0x210/0x250
>>>>> [ 1227.766742] EAX: 00000000 EBX: f5494e1c ECX: 00000000 EDX: 0000000=
0
>>>>> [ 1227.766796] ESI: 00000000 EDI: 05348416 EBP: f54a3c90 ESP: f54a3c7=
4
>>>>> [ 1227.766851] =A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>>>> [ 1227.766904] Process mount (pid: 1507, ti=3Df54a2000 task=3Df206888=
0
>>>>> task.ti=3Df54a2000)
>>>>> [ 1227.767002] Stack:
>>>>> [ 1227.767003] =A0f2068880 f54b159c 00000010 00000000 f1f8e400 f4efc5=
7c
>>>>> 0000128d f54a3ca8
>>>>> [ 1227.767003] =A0c11cb7ba c17d4e52 f4efc400 00000124 00000000 f54a3c=
b4
>>>>> c11ce4e6 ecee6318
>>>>> [ 1227.767003] =A0f54a3cdc c11cf7cc ecec7578 00000124 00000000 f4efc4=
00
>>>>> f54a3cd4 00000124
>>>>> [ 1227.767003] Call Trace:
>>>>> [ 1227.767003] =A0[<c11cb7ba>] ? __save_error_info.clone.61+0x7a/0xf0
>>>>> [ 1227.767003] =A0[<c11ce4e6>] ? save_error_info+0x16/0x30
>>>>> [ 1227.767003] =A0[<c11cf7cc>] ? ext4_error_inode+0x4c/0xf0
>>>>> [ 1227.767003] =A0[<c11b57e1>] ? __ext4_get_inode_loc+0x201/0x410
>>>>> [ 1227.767003] =A0[<c110b62a>] ? inode_init_always+0x1aa/0x1c0
>>>>> [ 1227.767003] =A0[<c11b72f9>] ? ext4_iget+0x59/0x6f0
>>>>> [ 1227.767003] =A0[<c11d2716>] ? ext4_fill_super+0x1ab6/0x2c70
>>>>> [ 1227.767003] =A0[<c114896f>] ? disk_name+0xbf/0xd0
>>>>> [ 1227.767003] =A0[<c10fa119>] ? mount_bdev+0x179/0x1c0
>>>>> [ 1227.767003] =A0[<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
>>>>> [ 1227.767003] =A0[<c11ca17f>] ? ext4_mount+0x1f/0x30
>>>>> [ 1227.767003] =A0[<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
>>>>> [ 1227.767003] =A0[<c10f9835>] ? vfs_kern_mount+0x75/0x250
>>>>> [ 1227.767003] =A0[<c110df03>] ? get_fs_type+0x33/0xb0
>>>>> [ 1227.767003] =A0[<c11ca160>] ? ext4_mount+0x0/0x30
>>>>> [ 1227.767003] =A0[<c10f9a6e>] ? do_kern_mount+0x3e/0xe0
>>>>> [ 1227.767003] =A0[<c111080f>] ? do_mount+0x35f/0x6b0
>>>>> [ 1227.767003] =A0[<c10d47c9>] ? strndup_user+0x49/0x70
>>>>> [ 1227.767003] =A0[<c1110e0b>] ? sys_mount+0x6b/0xa0
>>>>> [ 1227.767003] =A0[<c17b550c>] ? syscall_call+0x7/0xb
>>>>> [ 1227.767003] Code: fe ff ff 8b 0e 89 4d e4 8b 46 04 83 c6 08 89 f9 =
89
>>>>> da
>>>>> ff 55 e4 8b 06 85 c0 89 45 e4 75 ea e9 aa fe ff ff 8b 75 ec e9 ee fe =
ff
>>>>> ff
>>>>> <0f> 0b 8b 55 04 89 d8 e8 34 f9 ff ff e9 2a fe ff ff 8b 35 30 b8
>>>>> [ 1227.767003] EIP: [<c104f960>] mod_timer+0x210/0x250 SS:ESP
>>>>> 0068:f54a3c74
>>>>> [ 1227.770073] ---[ end trace d7b3d7a67954d202 ]---
>>>>>
>>>>>
>>>>> which happens after:
>>>>>
>>>>> [ 1137.167043] Aborting journal on device md10-8.
>>>>> [ 1137.167058] Buffer I/O error on device md10, logical block 139265
>>>>> [ 1137.167060] lost page write due to I/O error on md10
>>>>> [ 1137.167065] JBD2: I/O error detected when updating journal superbl=
ock
>>>>> for md10-8.
>>>>> [ 1137.660922] Buffer I/O error on device md10, logical block 1
>>>>> [ 1137.660926] lost page write due to I/O error on md10
>>>>> [ 1137.660932] EXT4-fs error (device md10): ext4_journal_start_sb:260=
:
>>>>> Detected aborted journal
>>>>> [ 1137.661046] EXT4-fs (md10): Remounting filesystem read-only
>>>>> [ 1137.661103] EXT4-fs (md10): previous I/O error to superblock detec=
ted
>>>>> [ 1137.661313] Buffer I/O error on device md10, logical block 1
>>>>> [ 1137.661315] lost page write due to I/O error on md10
>>>>> [ 1219.891363] EXT4-fs (md10): previous I/O error to superblock detec=
ted
>>>>> [ 1220.050654] Buffer I/O error on device md10, logical block 1
>>>>> [ 1220.050657] lost page write due to I/O error on md10
>>>>> [ 1220.050663] EXT4-fs error (device md10): ext4_put_super:728: Could=
n't
>>>>> clean up the journal
>>>>>
>>>>> and some more "Buffer I/O error"s.
>>>>>
>>>>> So it looks like an ext4 issue.
>>>>>
>>>>> I have Cc:ed the appropriate list.
>>>>>
>>>>> Thanks for the report.
>>>>>
>>>>> NeilBrown
>>>>>
>>>>>
>>>>
>>>>
>>>> --
>>>> Darko Kraus
>>>> Enterprise Network Administrator
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel=
"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at =A0http://www.tux.org/lkml/
>>>>
>>>
>>>
>>>
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>>>
>>
>>
>> --
>> Darko Kraus
>> Enterprise Network Administrator
>
>
>
> --=20
> Best Wishes
> Yongqiang Yang
>


--
Darko Kraus
Enterprise Network Administrator

---2006745895-1935391497-1320037999=:1654
Content-Type: APPLICATION/octet-stream; name=Kernel.panic.MD.tgz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.1110310113190.1654@hytron.hytron.net>
Content-Description: 
Content-Disposition: attachment; filename=Kernel.panic.MD.tgz

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
dvW2qRuBEGOo8OulMcHhMgCFjp3Fpobq0YZyg/Grd88X//7w8usFfkzNFsUF
fuXur6eLD9NnU/8nGELssnhUbGJvRSIoLDm7Wq8SEuImirXFOEoax6pyxeVe
CFYUk+0LC3iMV/b45fnl0+8XOd7x7q3q5FjnYHzliRvg6en3NhXucpM7pKa2
0c7Yd5NDNcjOkND8KdHLUmqBaHqfhlVcDNExAJj+Krz4aiTvEu0T2pOAez64
TsCu5O43IdBeidks9qqV1s49subrCdcQQ5U8JzmgToVXEGiEBZs/4+NlA0qb
2L4duIXXtghvbtev+RdLCJnO1zdLcPvq1YrfCCb49Tk4n1M9wfmMioMfmzgJ
FSLIQiTyqwgF8+d6vTA8wpfIg/DDKnFPxITAf8OA4Kq9XV2dgx8YtiXoD3Rh
SuWzLrVrYWB/4IWIEMCHz5YRVPWDSOyQDsHevr65epWaGZjwqDFmM8Mav0i5
+WBQfqvL1WuvUHts7qNbb6gdY/spQ9wh5ImDTqQssqsVe0HCAN3NnkfXTBi6
BmthWFWuE7ZRs6TACLh0N49DMKooZZIjIkVGbQ+q2tTVvMavUfV3n/74+J9Y
mc00GCmByz51RsWxXHKD8NhlgSrIGGnogqXj3vOPePvDbIVjjuD9u48ff3r3
+NvF9xcfn3559/gf7sRsM5opid3zdCVb2GXupI0uWj4PNwW3Hbm7/nPZyjDh
CQC8g4I9DQgwND0v/5+xK2lyG1fSf0XRp9cHj0Wt1METAW4SLW4mSEnlC6O6
XN2ueLbLUeWO6f73kwlwA5lJ1sGLkB9BEEsikcjFqAZLrHHJGLTZGrbQ2k8E
fXxqIn3U9Dq3DrpF6hrp7sP34dd6hgDmES6CfaJSfXNEmYgMQ3ISDfBida2b
5oOXsSI60DAfR+utTdf52Te9EPA1VDeY3xcJ+rwORH0jxVGDSAy8e1pqaxnK
BOsJSjkwmdb2b77vL6z1YbP4T/D08niFP7/3dMjd42Hu460kXXdNBOlfMvby
jK4kFm6YID+r768opR7sQ7WK3NCDB+RddRnHRsg3ZGqcxhRefuGCRPqfSpDJ
PjN2VwXjoH3hbhPUjbsz5D+d8JwPDdOaJoam3+vpjvbMVnYTGFJDe3m1D5xE
lt3FvmBk5TI5MvdUrpASzkHsx2h9eLV2U/p5jGlBb6seZ7GmXYqikBZFTxmn
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
0yzmD+CWSjilr7O4p+Ql2Ceh7yXBmvT2PuoQrmD/CJMX4h6PkR+ypK6XeOKm
rKw4nZrQO5VWc/Ks93u/eg/NLTvtehetxSX0LL9bWdU6NZc+n5PrNrmw5F7N
+eNp8mAqvybq3Ji38snJNP1pXh2GH7zjS00FIZ6Q1fDpQi4fS3vv07drn4Nj
UpXhtKOpUjGyBL4HurFVsX82EQy7er2GDruGJG+IYR5c9iJBYz2nw27dG/sC
Rc2ybk6h1lzekFNoquxAl0xvH1wqqQM8vgAMFEbNZX1ZL72f1p0ZmVmHSQmC
d8vw8FJ4y+NsqmcS8z1bGrYpqQGmjPqXNcAdLW5rjjLIKKYd+ZreeUgYf7rr
N6tRxx3i1V7yzeNnmtlcvjIoEMheR06Tuz2Zlb+rWOgyxeOD+8WVxxJZW7uD
mVtzFnWRBBuj2UzWRC3n9Omk7iiGs/FvlCJ405caIyUplzV9CX93iIPjEQaO
igKCD4WzphIhf6k7USYzvF+qd4dMvf062pHRabcKYnLPr13g2VZ1dNaHuGpa
szKUUrGQCWdYLtm0M+Es9WXqderhk6S27IJ3t1u7JCaQ1R9zIRA99O9GS8sx
ZBMCLIZ//CiEJOnSTP+LW9529VizpPPxYTybY6Alnwi/X9TNWmBW/FLGpmS8
8Hcs3cJ02x+503Qu5i7zbQfhKvbiVxJHpyTcF14PZo6x6DDf9ufTHgYqko3m
+JYKvnACVbstzsXB4AfeTH8u98s64gEJSDqnSrd/V3zWny+W88IjTS1lId9P
AR2Bj72yFaVFty8e+ZE+xs6Di3Vp3xKf5j0ug/8yZjc74YxP8SlO45SfP33B
x+W/cdan8ozNnE+qtH1XPJkufeiK57Tlz+YPi+FtJQHXbau4t53fChNR/GnN
/FNet+X9l35hQu+ccAsJqjRl8GXoShOevtTQCzdcgS1Zspvhyo9Kx1i4eLq1
kA2/KmzWvx+5uMAnJEwW4JSIr3yNBumO+HyKF1S+dPTQL///+b/3ab3/xvYx
tQ7ePvRbw+6Sn66zDOI4iv85eSjwMXWdfcOn9G3phmH8QqlpaNTQNFX9RaGG
Co+I8s/JvvlzOiZeTMgvcRQlTXSX0v+Xfv4g8FFaqmnaJv3Kjspu4yGwpI+H
a8SnQwKj6f4b+WMwerz9Sq7609+PRCM6MYlFqEJ+pZRQ9d2/nHEszdYv4HQk
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
nofn4Xl4fvTzfz5+5hYA4AEA

---2006745895-1935391497-1320037999=:1654--
