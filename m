From: "Joel (Xi Zhou) Zhou" <joel.zhou@broadcom.com>
Subject: ext4: jbd2_journal_add_journal_head() failed
Date: Sun, 6 Jul 2014 16:09:04 +0000
Message-ID: <9F136EE5FB53D64397ED1089A0E760E016294F04@SJEXCHMB12.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62957 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaGFQJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jul 2014 12:09:05 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I'm trying to use ext4 on USB stick. It is a big endian kernel on ARM C=
ortex-A9 with busybox.
The system command( cp /cat / ls ...) failed randomly in jbd2_journal_a=
dd_journal_head() on the following instruction.
The full log in the end.
/*
 * Give a buffer_head a journal_head.
 *
 * May sleep.
 */
struct journal_head *jbd2_journal_add_journal_head(struct buffer_head *=
bh)
{
=2E.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 J_ASSERT_BH(bh,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (=
atomic_read(&bh->b_count) > 0) ||
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (=
bh->b_page && bh->b_page->mapping));


Thanks,

Joel

//---------------------------------------------------------------------=
------------------------------------------
Logs:
# mount /dev/sda1 /mnt/usb
EXT3-fs (sda1): error: couldn't mount because of unsupported optional f=
eatures (240)
EXT2-fs (sda1): error: couldn't mount because of unsupported optional f=
eatures (240)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
# cd /mnt/usb
# ls -lh
total 16
drwx------    2 root     root       16.0K Jul  4  2014 lost+found
#=20
INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D6000 jiffies)
Backtrace:=20
[<c000c59c>] (dump_backtrace+0x0/0x110) from [<c044fcd8>] (dump_stack+0=
x18/0x1c)
[<c044fcc0>] (dump_stack+0x0/0x1c) from [<c0084bb0>] (rcu_check_callbac=
ks+0x2c8/0x6fc)
[<c00848e8>] (rcu_check_callbacks+0x0/0x6fc) from [<c0042534>] (update_=
process_times+0x48/0x5c)
[<c00424ec>] (update_process_times+0x0/0x5c) from [<c0071074>] (tick_no=
hz_handler+0xb0/0x110)
[<c0070fc4>] (tick_nohz_handler+0x0/0x110) from [<c000ea18>] (twd_handl=
er+0x40/0x50)
[<c000e9d8>] (twd_handler+0x0/0x50) from [<c008001c>] (handle_percpu_de=
vid_irq+0x90/0xa8)
[<c007ff8c>] (handle_percpu_devid_irq+0x0/0xa8) from [<c007c48c>] (gene=
ric_handle_irq+0x2c/0x3c)
[<c007c460>] (generic_handle_irq+0x0/0x3c) from [<c0009af4>] (handle_IR=
Q+0x60/0xb8)
[<c0009a94>] (handle_IRQ+0x0/0xb8) from [<c0008608>] (gic_handle_irq+0x=
30/0x6c)
[<c00085d8>] (gic_handle_irq+0x0/0x6c) from [<c0008f20>] (__irq_svc+0x4=
0/0x50)
Exception stack(0xdd881d98 to 0xdd881de0)
1d80:                                                       00000027 60=
000293
1da0: 00000000 2b2f2b2f 00000000 00000000 dd41c440 c1b1e670 c1ad7dd1 dd=
561004
1dc0: ffffffff dd881e14 dd881cf8 dd881de0 c003537c c016cfb0 60000213 ff=
ffffff
[<c016ce70>] (jbd2_journal_add_journal_head+0x0/0x320) from [<c016d210>=
] (jbd2_journal_get_descriptor_buffer+0x80/0xa8)
[<c016d190>] (jbd2_journal_get_descriptor_buffer+0x0/0xa8) from [<c0165=
5cc>] (journal_submit_commit_record.isra.14+0x4c/0x1f0)
[<c0165580>] (journal_submit_commit_record.isra.14+0x0/0x1f0) from [<c0=
166af0>] (jbd2_journal_commit_transaction+0x1380/0x1c10)
[<c0165770>] (jbd2_journal_commit_transaction+0x0/0x1c10) from [<c016ad=
5c>] (kjournald2+0xe0/0x3ec)
[<c016ac7c>] (kjournald2+0x0/0x3ec) from [<c005289c>] (kthread+0x98/0x9=
c)
[<c0052804>] (kthread+0x0/0x9c) from [<c0038f30>] (do_exit+0x0/0x778)
//---------------------------------------------------------------
# cp busybox b1.3G
------------[ cut here ]------------
kernel BUG at fs/jbd2/journal.c:2387!
Internal error: Oops - BUG: 0 [#1] SMP ARM
Modules linked in:
CPU: 1    Not tainted  (3.6.5-Broadcom Linux #241)
PC is at jbd2_journal_add_journal_head+0x28c/0x30c
LR is at down_trylock+0x2c/0x34
pc : [<c016b7a0>]    lr : [<c005817c>]    psr: 60000213
sp : dc2f9b08  ip : dc2f9a40  fp : dc2f9b3c
r10: 00001000  r9 : dd57aba0  r8 : dd695080
r7 : c1b1c64c  r6 : dd576000  r5 : 00000000  r4 : 00000001
r3 : 00000000  r2 : 00000000  r1 : 20000293  r0 : 00000000
=46lags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 12c53c7d  Table: 77b1404a  DAC: 00000015
Process cp (pid: 501, stack limit =3D 0xdc2f8270)
Stack: (0xdc2f9b08 to 0xdc2fa000)
9b00:                   00000001 00000000 00000001 dc2f9b20 c0128188 00=
000000
9b20: dd56b0a8 dd576000 c0463834 000011d0 dc2f9b54 dc2f9b40 c0163a90 c0=
16b520
9b40: 00000000 dd56b0a8 dc2f9b84 dc2f9b58 c0146f54 c0163a84 00000010 dd=
56b0a8
9b60: dd57aba0 00000000 dd57aba0 dc2f9bb4 dd56b0a8 c1d573e0 dc2f9ba4 dc=
2f9b88
9b80: c012c380 c0146f28 dd56b0a8 dd57aba0 dd56b0a8 dc206400 dc2f9be4 dc=
2f9ba8
9ba0: c012c3d0 c012c324 0224d000 c1d573e0 dc2f9bcc dd576000 00000d00 00=
000000
=2E..
Backtrace:=20
[<c016b514>] (jbd2_journal_add_journal_head+0x0/0x30c) from [<c0163a90>=
] (jbd2_journal_get_write_access+0x18/0x40)
[<c0163a78>] (jbd2_journal_get_write_access+0x0/0x40) from [<c0146f54>]=
 (__ext4_journal_get_write_access+0x38/0x78)
[<c0146f1c>] (__ext4_journal_get_write_access+0x0/0x78) from [<c012c380=
>] (ext4_reserve_inode_write+0x68/0x90)
[<c012c318>] (ext4_reserve_inode_write+0x0/0x90) from [<c012c3d0>] (ext=
4_mark_inode_dirty+0x28/0x184)
[<c012c3a8>] (ext4_mark_inode_dirty+0x0/0x184) from [<c012e418>] (ext4_=
dirty_inode+0x30/0x48)
[<c012e3e8>] (ext4_dirty_inode+0x0/0x48) from [<c00d7fac>] (__mark_inod=
e_dirty+0x34/0x22c)
[<c00d7f78>] (__mark_inode_dirty+0x0/0x22c) from [<c00dfca8>] (generic_=
write_end+0x98/0xc0)
[<c00dfc10>] (generic_write_end+0x0/0xc0) from [<c012cf30>] (ext4_da_wr=
ite_end+0x90/0x328)
[<c012cea0>] (ext4_da_write_end+0x0/0x328) from [<c008676c>] (generic_f=
ile_buffered_write+0xf0/0x278)
[<c008667c>] (generic_file_buffered_write+0x0/0x278) from [<c008810c>] =
(__generic_file_aio_write+0x224/0x4bc)
[<c0087ee8>] (__generic_file_aio_write+0x0/0x4bc) from [<c0088418>] (ge=
neric_file_aio_write+0x74/0xec)
[<c00883a4>] (generic_file_aio_write+0x0/0xec) from [<c0124270>] (ext4_=
file_write+0xbc/0x588)
[<c01241b4>] (ext4_file_write+0x0/0x588) from [<c00b32c4>] (do_sync_wri=
te+0xb0/0xe0)
[<c00b3214>] (do_sync_write+0x0/0xe0) from [<c00b396c>] (vfs_write+0x9c=
/0xd4)
[<c00b38d0>] (vfs_write+0x0/0xd4) from [<c00b3c0c>] (sys_write+0x40/0x8=
0)
[<c00b3bcc>] (sys_write+0x0/0x80) from [<c0009260>] (ret_fast_syscall+0=
x0/0x30)
Code: 0200000a 043093e5 000053e3 c6ffff1a (e7f001f2)=20
---[ end trace 4a20dcd0e2eede81 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
