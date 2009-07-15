From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Subject: [BUG] NULL pointer dereference with corrupted image
Date: Wed, 15 Jul 2009 11:54:09 +0200
Message-ID: <1247651649.4097.23.camel@queen>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.pawisda.de ([213.157.4.156]:47835 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZGOK2d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 06:28:33 -0400
Received: from [192.168.0.2] (193.195.116.85.dsl.manitu.net [85.116.195.193])
	by mailrelay.pawisda.de (Postfix) with ESMTP id 03DF8B8B82
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 11:54:10 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

mounting the image at http://www.cccmz.de/~snakebyte/ext4.56.img.bz2
listing the directories and touching a files produces a null pointer
dereference with -rc3 (verified with -rc2 and current -git). I tested
this on different boxes with the same result

root@whiterabbit:~/testing/fsfuzzer-0.6-lmh# mount -o loop
cfs/ext4.56.img -t ext4dev /media/test/
root@whiterabbit:~/testing/fsfuzzer-0.6-lmh# ls /media/test 
lost+found
root@whiterabbit:~/testing/fsfuzzer-0.6-lmh# touch /media/test/file
Killed

If the ls is 

[29436.010601] EXT4-fs (/dev/loop0): Update your userspace programs to
mount using ext4
[29436.010803] EXT4-fs (/dev/loop0): ext4dev backwards compatibility
will go away by 2.6.31
[29436.028613] EXT4-fs (loop0): no journal
[29436.028833] EXT4-fs (loop0): delayed allocation enabled
[29436.056982] EXT4-fs: mballoc enabled
[29436.061698] EXT4-fs (loop0): mounted filesystem without journal
[29436.189556] EXT4-fs error (device loop0): ext4_claim_inode: reserved
inode or inode > inodes count - block_group = 0, inode=10
[29436.189835] EXT4-fs (loop0): Remounting filesystem read-only
[29436.202154] BUG: unable to handle kernel NULL pointer dereference at
(null)
[29436.202335] IP: [<c025977d>] ext4_decode_error+0x6d/0x90
[29436.202540] *pde = 00000000 
[29436.202643] Oops: 0000 [#1] PREEMPT 
[29436.202835] last sysfs file: /sys/block/hdc/size
[29436.202920] Modules linked in:
[29436.203057] 
[29436.203057] Pid: 5197, comm: touch Not tainted
(2.6.31-rc3-23244-g6847e15 #29) System Name
[29436.203057] EIP: 0060:[<c025977d>] EFLAGS: 00010282 CPU: 0
[29436.203057] EIP is at ext4_decode_error+0x6d/0x90
[29436.203057] EAX: 00000000 EBX: c6555d58 ECX: c0a70886 EDX: ffffffe2
[29436.203057] ESI: c08fd80e EDI: c282cce4 EBP: c6555d40 ESP: c6555d2c
[29436.203057]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[29436.203057] Process touch (pid: 5197, ti=c6555000 task=c44d41a0
task.ti=c6555000)
[29436.203057] Stack:
[29436.203057]  00000001 00000000 c0154fa2 c44d41a0 c9826e10 c6555d74
c025a948 00000001
[29436.203057] <0> 0000045b c44d41a0 0000045b c282cd98 c0252430 c282cce4
c6555d74 bede78d2
[29436.203057] <0> c282cd98 ffffffe2 c6555d94 c0252563 c0caefe0 c08fdba0
c0caefe0 c6555d94
[29436.203057] Call Trace:
[29436.203057]  [<c0154fa2>] ? mark_held_locks+0x52/0x70
[29436.203057]  [<c025a948>] ? __ext4_std_error+0x28/0x90
[29436.203057]  [<c0252430>] ? ext4_delete_inode+0x0/0x230
[29436.203057]  [<c0252563>] ? ext4_delete_inode+0x133/0x230
[29436.203057]  [<c0252430>] ? ext4_delete_inode+0x0/0x230
[29436.203057]  [<c01d2976>] ? generic_delete_inode+0x96/0x140
[29436.203057]  [<c01d2b57>] ? generic_drop_inode+0x137/0x1b0
[29436.203057]  [<c01d2197>] ? iput+0x47/0x50
[29436.203057]  [<c024a904>] ? ext4_new_inode+0xa64/0xe70
[29436.203057]  [<c01cfc0b>] ? d_rehash+0x3b/0x50
[29436.203057]  [<c0255881>] ? ext4_create+0xb1/0x120
[29436.203057]  [<c01c9096>] ? vfs_create+0xb6/0x170
[29436.203057]  [<c01cbf18>] ? do_filp_open+0x5d8/0x820
[29436.203057]  [<c08e2377>] ? _spin_unlock+0x27/0x50
[29436.203057]  [<c01be6bf>] ? do_sys_open+0x4f/0x100
[29436.203057]  [<c0102d9a>] ? sysenter_exit+0xf/0x1a
[29436.203057]  [<c01be7d9>] ? sys_open+0x29/0x40
[29436.203057]  [<c0102d6b>] ? sysenter_do_call+0x12/0x32
[29436.203057] Code: 6a 82 35 00 89 d9 85 c0 78 33 8d 74 26 00 83 c4 10
89 c8 5b 5d c3 85 c0 74 16 8b 80 d0 02 00 00 b9 86 08 a7 c0 8b 80 30 01
00 00 <f6> 00 02 74 de 83 c4 10 b9 a3 08 a7 c0 5b 89 c8 5d c3 31 c9 eb 
[29436.203057] EIP: [<c025977d>] ext4_decode_error+0x6d/0x90 SS:ESP
0068:c6555d2c
[29436.203057] CR2: 0000000000000000
[29436.284374] ---[ end trace a3b07131cd2de900 ]---


0xc025977d is in ext4_decode_error (fs/ext4/super.c:347).
342			break;
343		case -ENOMEM:
344			errstr = "Out of memory";
345			break;
346		case -EROFS:
347			if (!sb || EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT)
348				errstr = "Journal has aborted";
349			else
350				errstr = "Readonly filesystem";
351			break;

0xc0252563 is in ext4_delete_inode (fs/ext4/inode.c:225).
220			/*
221			 * If we're going to skip the normal cleanup, we still need to
222			 * make sure that the in-core orphan linked list is properly
223			 * cleaned up.
224			 */
225			ext4_orphan_del(NULL, inode);
226			goto no_delete;
227		}
228	
229		if (IS_SYNC(inode))

Regards, Eric

