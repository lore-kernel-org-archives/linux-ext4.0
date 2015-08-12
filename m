From: Roy Yang <bsdnet@outlook.com>
Subject: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Wed, 12 Aug 2015 09:57:51 -0700
Message-ID: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from col004-omc1s13.hotmail.com ([65.55.34.23]:62038 "EHLO
	COL004-OMC1S13.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195AbbHLQ5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 12:57:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi EXT4 Experts,=A0

We came cross an ext4 journaling problem, and I did some googling on hi=
gh I/O wait,=A0
found a lot of links, but none of them is the same.

The backtrace when system is hung is :

Aug 7 11:31:33 2f4526ab kernel: "echo 0> /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
=2E..
Aug 7 11:31:33 2f4526ab kernel: Call Trace:
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffff816096a9>]=A0schedule+0x29/=
0x70
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffffa031d785>]=A0jbd2_log_wait_=
commit+0xc5/0x140=A0[jbd2]
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffff81098230>]=A0? wake_up_bit+=
0x30/0x30
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffffa031fe32>]=A0jbd2_complete_=
transaction+0x52/0xa0=A0[jbd2]
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffffa03339f2>]=A0ext4_sync_file=
+0x292/0x320=A0[ext4]
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffff811f6ba5>]=A0do_fsync+0x65/=
0xa0
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffff811f6e70>]=A0SyS_fsync+0x10=
/0x20
Aug 7 11:31:33 2f4526ab kernel:=A0[<ffffffff81614209>]=A0system_call_fa=
stpath+0x16/0x1b

At application layer, we use a lot of fsync APIs. When I/O load is heav=
y, we saw a lot of I/Os can't finish within 120 seconds
because JBD2 can't finish the journaling. We also see when this happens=
, the JBD2 info shows very high on the following two items:

$ cat /proc/fs/jbd2/nvme0n1/info
85162438 transactions (85162436 requested), each up to 8192 blocks
average:=A0
=A0 0ms waiting for transaction
=A0 0ms request delay
=A0 1ms running transaction =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 <=3D=3D=3D=3D=
 this will be very high, 3 to 6 seconds=A0
=A0 0ms transaction was being locked
=A0 0ms flushing data (in ordered mode)
=A0 0ms logging transaction
=A0 153us average transaction commit time =A0 =A0 <=3D=3D=3D this will =
be very high, half to one second
=A0 35 handles per transaction
=A0 2 blocks per transaction
=A0 3 logged blocks per transaction

Our environment :
$ mount=A0
/dev/nvme0n1 on /logs type ext4 (rw,noatime,data=3Dordered)

$ uname -a
Linux a69ac961 3.10.0-229.7.2.el7.x86_64 #1 SMP Tue Jun 23 22:06:11 UTC=
 2015 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/redhat-release=A0
CentOS Linux release 7.1.1503 (Core)=A0


$ sudo tune2fs=A0 -l /dev/nvme0n1
tune2fs 1.42.9 (28-Dec-2013)
=46ilesystem volume name: =A0 cty-data
Last mounted on:=A0 =A0 =A0 =A0 =A0 <not available>
=46ilesystem UUID:=A0 =A0 =A0 =A0 =A0 227fde0d-a3ae-4236-9d32-46ef0091b=
3b3
=46ilesystem magic number:=A0 0xEF53
=46ilesystem revision #:=A0 =A0 1 (dynamic)
=46ilesystem features:=A0 =A0 =A0 has_journal ext_attr resize_inode dir=
_index filetype needs_recovery extent 64bit flex_bg sparse_super large_=
file huge_file uninit_bg dir_nlink extra_isize
=46ilesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash=A0
Default mount options:=A0 =A0 user_xattr acl
=46ilesystem state: =A0 =A0 =A0 =A0 clean
Errors behavior:=A0 =A0 =A0 =A0 =A0 Continue
=46ilesystem OS type: =A0 =A0 =A0 Linux
Inode count:=A0 =A0 =A0 =A0 =A0 =A0 =A0 91062272
Block count:=A0 =A0 =A0 =A0 =A0 =A0 =A0 364226560
Reserved block count: =A0 =A0 3642265
=46ree blocks:=A0 =A0 =A0 =A0 =A0 =A0 =A0 126192987
=46ree inodes:=A0 =A0 =A0 =A0 =A0 =A0 =A0 90916973
=46irst block:=A0 =A0 =A0 =A0 =A0 =A0 =A0 0
Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
=46ragment size:=A0 =A0 =A0 =A0 =A0 =A0 4096
Group descriptor size:=A0 =A0 64
Reserved GDT blocks:=A0 =A0 =A0 1024
Blocks per group: =A0 =A0 =A0 =A0 32768
=46ragments per group:=A0 =A0 =A0 32768
Inodes per group: =A0 =A0 =A0 =A0 8192
Inode blocks per group: =A0 512
=46lex block group size:=A0 =A0 16
=46ilesystem created: =A0 =A0 =A0 Wed Aug=A0 5 13:00:41 2015
Last mount time:=A0 =A0 =A0 =A0 =A0 Mon Aug 10 18:32:59 2015
Last write time:=A0 =A0 =A0 =A0 =A0 Mon Aug 10 18:32:59 2015
Mount count:=A0 =A0 =A0 =A0 =A0 =A0 =A0 6
Maximum mount count:=A0 =A0 =A0 -1
Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Wed Aug=A0 5 13:00:41 2015
Check interval: =A0 =A0 =A0 =A0 =A0 0 (<none>)
Lifetime writes:=A0 =A0 =A0 =A0 =A0 135 MB
Reserved blocks uid:=A0 =A0 =A0 0 (user root)
Reserved blocks gid:=A0 =A0 =A0 0 (group root)
=46irst inode:=A0 =A0 =A0 =A0 =A0 =A0 =A0 11
Inode size:	=A0 =A0 =A0 =A0 =A0 256
Required extra isize: =A0 =A0 28
Desired extra isize:=A0 =A0 =A0 28
Journal inode:=A0 =A0 =A0 =A0 =A0 =A0 8
Default directory hash: =A0 half_md4
Directory Hash Seed:=A0 =A0 =A0 c8f8aa7c-583b-4251

Any suggestions =A0or hints how to debug this problem will be appreciat=
ed!

Thank you very much,=A0

Roy
=A9 2015 Microsoft=A0Terms=A0Privacy & cookies=A0Developers=A0English (=
United States)=A0

=A0=A0 =A0=A0=A0=A0 =A0 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
