From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v5 00/15] ext4: add new online resize
Date: Fri, 30 Dec 2011 22:37:57 +0800
Message-ID: <CAGBYx2bWQekPEasXAK9cYrisTdo+Cp0d7sZYnmv_rjFy7rEv5g@mail.gmail.com>
References: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
	<20111229040738.GK12370@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36790 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1L3Oh6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 09:37:58 -0500
Received: by mail-tul01m020-f174.google.com with SMTP id wo16so10192121obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 06:37:57 -0800 (PST)
In-Reply-To: <20111229040738.GK12370@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Sorry for my carelessness.   I updated the patch and wrote a
regression test as you suggested which is put on my github
https://github.com/YANGYongqiang/ext4-online-resize-regression-tests.
The latest patch passed the regression test.

Yongqiang.
On Thu, Dec 29, 2011 at 12:07 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Hi,
>
> FYI, I just updated the online resizes in the unstable portion of the
> ext4 series to the V5 version. =A0Unfortunately, I was able to trigge=
r a
> BUG_ON at line 497 of resize.c trying to resize a simple ext3 file
> system. =A0(See below)
>
> I'd suggest that you use a regression test suite that tries a various
> different mke2fs commands with -t ext3, -t ext4, as well as different
> file system options (i.e., -t ext3 -O extents, -t ext4 -O bigalloc,
> etc.) =A0Also make sure you try different sizes so that you we check
> extending a flex_bg, growing a new flex_bg, etc.
Ok.  I know what happened.

>
> In this particular case, the problem is that the resize code appears
> to assume the uninit_bg file system feature aka
> EXT4_FEATURE_RO_COMPAT_GDT_CSUM is always going to be set.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0- Ted
>
> # grep vdc /proc/partitions
> =A0254 =A0 =A0 =A0 32 =A0 =A05242880 vdc
> # mke2fs -t ext3 /dev/vdc 512M
> # mount /dev/vdc
> # resize2fs /dev/vdc
> resize2fs 1.42-WIP (16-Oct-2011)
> Filesystem at /dev/vdc is mounted on /vdc; on-line resizing required
> old_desc_blocks =3D 1, new_desc_blocks =3D 1
> [ =A0187.749591] ------------[ cut here ]------------
> [ =A0187.751725] kernel BUG at /usr/projects/linux/ext4/fs/ext4/resiz=
e.c:497!
> [ =A0187.752756] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ =A0187.752756] Modules linked in:
> [ =A0187.752756]
> [ =A0187.752756] Pid: 2204, comm: resize2fs Not tainted 3.2.0-rc6-000=
30-g82a1181 #46 Bochs Bochs
> [ =A0187.752756] EIP: 0060:[<c035281a>] EFLAGS: 00010202 CPU: 0
> [ =A0187.752756] EIP is at setup_new_flex_group_blocks+0x33f/0x6d2
> [ =A0187.752756] EAX: 00000001 EBX: f6297000 ECX: 00570a4a EDX: 00000=
000
> [ =A0187.752756] ESI: 00000000 EDI: 00000001 EBP: f62f3d8c ESP: f62f3=
d0c
> [ =A0187.752756] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0187.752756] Process resize2fs (pid: 2204, ti=3Df62f2000 task=3Df=
5eca940 task.ti=3Df62f2000)
> [ =A0187.752756] Stack:
> [ =A0187.752756] =A0c01ce2dc f6824ee0 00000020 0000001f 00000000 0000=
0004 f6a2d778 f6297000
> [ =A0187.752756] =A000020001 00000000 00000000 00000000 f6297c00 f62f=
3d6c f37877c0 00000004
> [ =A0187.752756] =A0f6ab9c30 f37877c0 00000000 f6824f2c 00020001 0000=
0000 f6415168 c020b5a0
> [ =A0187.752756] Call Trace:
> [ =A0187.752756] =A0[<c01ce2dc>] ? trace_hardirqs_on_caller+0x10f/0x1=
40
> [ =A0187.752756] =A0[<c020b5a0>] ? __delayacct_blkio_end+0x55/0x5b
> [ =A0187.752756] =A0[<c03534d4>] ext4_flex_group_add+0xc2/0x10c6
> [ =A0187.752756] =A0[<c0a33706>] ? __wait_on_bit+0x6e/0x77
> [ =A0187.752756] =A0[<c02bfcf5>] ? unmap_underlying_metadata+0x5d/0x5=
d
> [ =A0187.752756] =A0[<c02bfcf5>] ? unmap_underlying_metadata+0x5d/0x5=
d
> [ =A0187.752756] =A0[<c02847ec>] ? trace_kmalloc+0x2f/0x95
> [ =A0187.752756] =A0[<c035489d>] ? ext4_resize_fs+0x3c5/0xb56
> [ =A0187.752756] =A0[<c0284ca5>] ? __kmalloc+0x20d/0x219
> [ =A0187.752756] =A0[<c035489d>] ? ext4_resize_fs+0x3c5/0xb56
> [ =A0187.752756] =A0[<c0354d33>] ext4_resize_fs+0x85b/0xb56
> [ =A0187.752756] =A0[<c01cf1df>] ? lock_release_non_nested+0xb5/0x1e8
> [ =A0187.752756] =A0[<c03343a7>] ext4_ioctl+0xbcf/0xda4
> [ =A0187.752756] =A0[<c01bc804>] ? sched_clock_cpu+0x22e/0x23e
> [ =A0187.752756] =A0[<c01cba23>] ? trace_hardirqs_off+0xb/0xd
> [ =A0187.752756] =A0[<c0282f25>] ? slab_free_hook+0x5e/0x6b
> [ =A0187.752756] =A0[<c029d5e6>] vfs_ioctl+0x4a/0x78
> [ =A0187.752756] =A0[<c029ddf5>] do_vfs_ioctl+0x66d/0x67f
> [ =A0187.752756] =A0[<c0284725>] ? kmem_cache_free+0xe8/0x144
> [ =A0187.752756] =A0[<c02988b5>] ? putname+0x62/0x66
> [ =A0187.752756] =A0[<c02988b5>] ? putname+0x62/0x66
> [ =A0187.752756] =A0[<c028727e>] ? do_sys_open+0x12c/0x136
> [ =A0187.752756] =A0[<c029de7b>] sys_ioctl+0x74/0xaa
> [ =A0187.752756] =A0[<c0a3600d>] syscall_call+0x7/0xb
> [ =A0187.752756] Code: 83 e0 05 48 0f 95 c0 31 c9 0f b6 f8 b8 64 11 0=
4 c1 89 fa e8 14 05 ed ff 8b 04 bd c8 6e 12 c1 40 85 ff 89 04 bd c8 6e =
12 c1 74 04 <0f> 0b eb fe 8b 55 98 8b 7d c8 0f b7 04 7a d1 e8 83 e0 01 =
8b 14
> [ =A0187.752756] EIP: [<c035281a>] setup_new_flex_group_blocks+0x33f/=
0x6d2 SS:ESP 0068:f62f3d0c
> [ =A0187.822687] ---[ end trace aa45447d850e7921 ]---
> Segmentation fault
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
>
> On Fri, Dec 23, 2011 at 04:14:50PM +0800, Yongqiang Yang wrote:
>> Hi all,
>>
>> This is the 5th version of patch series adding new online resize to =
ext4.
>>
>> -- What's new resize implementation?
>> =A0 =A0It is a new online resize interface for ext4. =A0It can be us=
ed via
>> =A0 =A0ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating=
 size
>> =A0 =A0of the resized fs in block.
>>
>> -- Difference between current resize and new resize.
>> =A0 =A0New resize lets kernel do all work, like allocating bitmaps a=
nd
>> =A0 =A0inode tables and can support flex_bg and BLOCK_UNINIT feature=
s.
>> =A0 =A0Besides these, new resize is much faster than current resize.
>>
>> =A0 =A0Below are benchmarks I made on my personal computer, fses wit=
h
>> =A0 =A0flex_bg size =3D 16 were resized to 230GB evry time. The firs=
t
>> =A0 =A0row shows the size of a fs from which the fs was resized to 2=
30GB.
>> =A0 =A0The datas were collected by 'time resize2fs'.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 20GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0=
 =A0100GB
>> =A0 =A0 =A0 real =A0 =A00m3.558s =A0 =A0 0m2.891s =A0 =A00m0.394s
>> =A0 =A0 =A0 user =A0 =A00m0.004s =A0 =A0 0m0.000s =A0 =A00m0.394s
>> =A0 =A0 =A0 sys =A0 =A0 0m0.048s =A0 =A0 0m0.048s =A0 =A00m0.028s
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 current resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 20GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0=
 =A0100GB
>> =A0 =A0 =A0 real =A0 =A05m2.770s =A0 =A0 4m43.757s =A03m14.840s
>> =A0 =A0 =A0 user =A0 =A00m0.040s =A0 =A0 0m0.032s =A0 0m0.024s
>> =A0 =A0 =A0 sys =A0 =A0 0m0.464s =A0 =A0 0m0.432s =A0 0m0.324s
>>
>> =A0 =A0According to data above, new resize is faster than current re=
size in both
>> =A0 =A0user and sys time. =A0New resize performs well in sys time, b=
ecause it
>> =A0 =A0supports BLOCK_UNINIT and adds multi-groups each time.
>>
>> -- About supporting new features.
>> =A0 =A0YES! New resize can support new feature like bigalloc and exc=
lude bitmap
>> =A0 =A0easily. =A0Because it lets kernel do all work.
>>
>> =A0V4->V5:
>> =A0 =A0release resizing lock in error case of IOC_RESIZEFS
>> =A0 =A0Thanks Djalal <tixxdz@opendz.org> for pointing it out and his=
 patch for
>> =A0 =A0IOC_GROUP_EXTEND and IOC_GROUP_ADD.
>>
>> =A0V3->V4:
>> =A0 =A0rename __ext4_group_extend to ext4_group_extend_no_check.
>>
>> =A0V2->V3:
>> =A0 =A0initialize block bitmap of last group.
>> =A0 =A0remove code initalizing inode bitmap and inode tables.
>>
>> Yongqiang.
>>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
