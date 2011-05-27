From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Subject: Re: 2.6.37, 2.6.38, 2.6.39 vfs/ext3/ext4 crash when unplugging USB
 storage
Date: Fri, 27 May 2011 08:37:24 +0200
Message-ID: <4DDF46A4.3070601@secunet.com>
References: <20110525132356.GA6296@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110525132356.GA6296@janus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am 25.05.2011 15:23, schrieb Frank van Maarseveen:
> Kernel crashes in various interesting ways using this command sequence
> with an ext3/ext4 formatted USB storage device (not write-preotected):
> 
> 	mount /dev/sdb1 /mnt
> 	cd /mnt
> 	ls
> 	# unplug device here
> 	umount -l -f /mnt
> 	cd
> 
> Reproducable on FC15 live image using the file manager.

Just to give an example of such a crash, created with ext3 on v2.6.39:

EXT3-fs (sdb3): using internal journal
EXT3-fs (sdb3): recovery complete
EXT3-fs (sdb3): mounted filesystem with writeback data mode
usb 1-5: USB disconnect, device number 6
JBD: I/O error detected when updating journal superblock for sdb3.
Aborting journal on device sdb3.
JBD: I/O error detected when updating journal superblock for sdb3.
journal commit I/O error
general protection fault: 0000 [#1] SMP
last sysfs file:
CPU 1
Modules linked in:

Pid: 520, comm: bdi-default Not tainted 2.6.39 #40 LENOVO 20077KG/20077KG
RIP: 0010:[<ffffffff811221f6>]  [<ffffffff811221f6>] redirty_tail+0x56/0xb0
RSP: 0018:ffff88007cd49c08  EFLAGS: 00010292
RAX: ffff88007d17b408 RBX: ffffffff8201d840 RCX: 6b6b6b6b6b6b6b6b
RDX: ffff88007c3a1070 RSI: ffff88007c3a11c8 RDI: ffffffff81d33f32
RBP: ffff88007cd49c10 R08: ffffffff8201d8b8 R09: ffff88007cd49c40
R10: 0000000000000000 R11: ffffffff8201d8b8 R12: ffff88007bcee218
R13: ffff88007cd49cc0 R14: ffff88007d17b408 R15: ffffffff8201d8c8
FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f713597ebeb CR3: 0000000002003000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bdi-default (pid: 520, threadinfo ffff88007cd48000, task ffff88007cc65180)
Stack:
 ffffffff8201d840 ffff88007cd49c70 ffffffff811228fb ffff88007fc11b40
 0000000000011b01 ffff88007fc11b40 ffffffff8201d8d8 ffff88007d17b470
 ffffffff8201d840 ffff88007bde3d38 0000000000000400 0000000000000000
Call Trace:
 [<ffffffff811228fb>] writeback_sb_inodes+0x8b/0x1b0
 [<ffffffff811235ff>] wb_writeback+0x18f/0x460
 [<ffffffff81123971>] wb_do_writeback+0xa1/0x280
 [<ffffffff81051b80>] ? del_timer+0xe0/0xe0
 [<ffffffff810d70a7>] bdi_forker_thread+0xc7/0x510
 [<ffffffff810d6fe0>] ? bdi_debug_stats_show+0x170/0x170
 [<ffffffff810d6fe0>] ? bdi_debug_stats_show+0x170/0x170
 [<ffffffff81063a86>] kthread+0x96/0xa0
 [<ffffffff819c79f4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810639f0>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff819c79f0>] ? gs_change+0xb/0xb
Code: 40 01 00 00 48 8b 52 68 8b 0d 27 01 ee 00 89 ce c1 fe 08 40 38 ce 74 66 48 8b 8a 58 01 00 00 48 8d b2 58 01 00 00 48 39 ce 74 15
 8b 59 e8 48 39 58 50 79 0b 48 8b 0d b9 56 ff 00 48 89 48 50
RIP  [<ffffffff811221f6>] redirty_tail+0x56/0xb0
 RSP <ffff88007cd49c08>
---[ end trace 04e2da502b7fc110 ]---

Complete logs stored at: http://paste.debian.net/118118/

Steps performed for crash:

- mount -t ext3 /dev/sdb3 /mnt
- cd /mnt
- ls
- cd ~
- remove stick
- call umount /mnt

The code points to:

static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
                struct writeback_control *wbc, bool only_this_sb)
{
        while (!list_empty(&wb->b_io)) {
                long pages_skipped;
                struct inode *inode = wb_inode(wb->b_io.prev);

                if (inode->i_sb != sb) {
                        if (only_this_sb) {
                                /*
                                 * We only want to write back data for this
                                 * superblock, move all inodes not belonging
                                 * to it back onto the dirty list.
                                 */
                                redirty_tail(inode);
                                continue;
                        }

Location write_back_sb_inodes+0x8b is 194b:

                                redirty_tail(inode);
    1940:       4c 89 f7                mov    %r14,%rdi
    1943:       88 4d b8                mov    %cl,-0x48(%rbp)
    1946:       e8 a5 f8 ff ff          callq  11f0 <redirty_tail>
                                continue;
    194b:       0f b6 4d b8             movzbl -0x48(%rbp),%ecx
    194f:       eb ab                   jmp    18fc <writeback_sb_inodes+0x3c>
    1951:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
        raw_spin_lock_init(&(_lock)->rlock);            \
} while (0)


	Torsten
