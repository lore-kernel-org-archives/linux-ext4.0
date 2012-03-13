From: manikanta <manikanta4u@gmail.com>
Subject: EXT4-fs error
Date: Tue, 13 Mar 2012 15:09:07 +0530
Message-ID: <CA+WnoXMqBAsbE_o=GYUObSJ8Hu4nzVmJt8Ru5ryeYk6nbaUJsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38829 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2CMJjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 05:39:08 -0400
Received: by eekc41 with SMTP id c41so75282eek.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2012 02:39:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

=C2=A0 =C2=A0 =C2=A0I am working on android ICS. I got an=C2=A0EXT4-fs =
error saying=C2=A0lblock
0 mapped to illegal pblock (length 1) and then kernel panic.

Below are the result of cat /proc/mounts

rootfs / rootfs ro,relatime 0 0
tmpfs /dev tmpfs rw,nosuid,relatime,mode=3D755 0 0
devpts /dev/pts devpts rw,relatime,mode=3D600 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
none /acct cgroup rw,relatime,cpuacct 0 0
tmpfs /mnt/asec tmpfs rw,relatime,mode=3D755,gid=3D1000 0 0
tmpfs /mnt/obb tmpfs rw,relatime,mode=3D755,gid=3D1000 0 0
none /dev/cpuctl cgroup rw,relatime,cpu 0 0
/dev/block/mmcblk0p14 /system ext4 ro,relatime,user_xattr,barrier=3D1,d=
ata=3Dordered
=C2=A00 0
/dev/block/mmcblk0p15 /data ext4 rw,nosuid,nodev,noatime,user_xattr,bar=
rier=3D1,jo
urnal_async_commit,data=3Dordered,noauto_da_alloc 0 0
/dev/block/mmcblk0p16 /persist ext4 rw,nosuid,nodev,relatime,user_xattr=
,barrier=3D
1,data=3Dordered 0 0

*******************************
/dev/block/mmcblk0p17 /cache ext4 rw,nosuid,nodev,relatime,user_xattr,b=
arrier=3D1,
data=3Dordered 0 0
****************************************
/dev/block/mmcblk0p11 /efs ext4 rw,nosuid,nodev,relatime,user_xattr,bar=
rier=3D1,da
ta=3Dordered 0 0
/dev/block/mmcblk0p16 /tombstones ext4 rw,nosuid,nodev,relatime,user_xa=
ttr,barri
er=3D1,data=3Dordered 0 0
/dev/block/mmcblk0p1 /firmware vfat ro,relatime,fmask=3D0006,dmask=3D00=
06,allow_utim
e=3D0020,codepage=3Dcp437,iocharset=3Diso8859-1,shortname=3Dlower,error=
s=3Dremount-ro 0 0
/dev/fuse /mnt/sdcard fuse rw,nosuid,nodev,relatime,user_id=3D1023,grou=
p_id=3D1023,d
efault_permissions,allow_other 0 0

Below are the error logs,
<2>[ 4236.400030] [0: =C2=A0 =C2=A0 Thread-980:11795] EXT4-fs error (de=
vice
mmcblk0p17): ext4_map_blocks:1304: inode #2: block 3900: comm
Thread-980: lblock 0 mapped to illegal pblock (length 1)
<3>[ 4236.400121] [0: =C2=A0 =C2=A0 Thread-980:11795] Aborting journal =
on device
mmcblk0p17-8.
<0>[ 4236.401250] [0: =C2=A0 =C2=A0 Thread-980:11795] Kernel panic - no=
t
syncing: EXT4-fs (device mmcblk0p17): panic forced after error
<0>[ 4236.401311] [0: =C2=A0 =C2=A0 Thread-980:11795]
<4>[ 4236.401372] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c010c6c0>]
(unwind_backtrace+0x0/0x12c) from [<c07d941c>] (panic+0xa4/0x1e8)
<4>[ 4236.401464] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c07d941c>]
(panic+0xa4/0x1e8) from [<c02a7f3c>] (ext4_handle_error+0x8c/0x98)
<4>[ 4236.401525] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c02a7f3c>]
(ext4_handle_error+0x8c/0x98) from [<c02a8268>]
(ext4_error_inode+0xb8/0xcc)
<4>[ 4236.401617] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c02a8268>]
(ext4_error_inode+0xb8/0xcc) from [<c028fdec>]
(__check_block_validity.clone.0+0x68/0x7c)
<4>[ 4236.401708] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c028fdec>]
(__check_block_validity.clone.0+0x68/0x7c) from [<c028fe90>]
(ext4_map_blocks+0x90/0x1b8)
<4>[ 4236.401769] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c028fe90>]
(ext4_map_blocks+0x90/0x1b8) from [<c0288054>]
(ext4_readdir+0x2b4/0x660)
<4>[ 4236.401861] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c0288054>]
(ext4_readdir+0x2b4/0x660) from [<c0229540>] (vfs_readdir+0x6c/0xa0)
<4>[ 4236.401922] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c0229540>]
(vfs_readdir+0x6c/0xa0) from [<c02295d8>] (sys_getdents64+0x64/0xb4)
<4>[ 4236.402013] [0: =C2=A0 =C2=A0 Thread-980:11795] [<c02295d8>]
(sys_getdents64+0x64/0xb4) from [<c0105ea0>]
(ret_fast_syscall+0x0/0x30)

If anyone know about this error, please reply back.

Regards,
Manikanta
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
