From: Volodymyr Mieshkov <volodymyr.mieshkov@ti.com>
Subject: [PATCH] ext4: prevent kernel panic in case of uninitialized jinode
Date: Wed, 17 Oct 2012 18:54:29 +0300
Message-ID: <1350489269-30579-1-git-send-email-volodymyr.mieshkov@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Volodymyr Mieshkov <volodymyr.mieshkov@ti.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In some cases the kernel crash occurs during system suspend/resume.
Here is an example of a crash dump:

[ 4095.041351] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[ 4095.050689] pgd = c0004000
[ 4095.053985] [00000000] *pgd=00000000
[ 4095.058807] Internal error: Oops: 5 [#1] PREEMPT SMP
[ 4095.064483] Modules linked in: wl12xx mac80211 pvrsrvkm_sgx540_120 cfg80211 compat [last unloaded: wl12xx_sdio]
[ 4095.064575] CPU: 1    Tainted: G    B        (3.0.31-01807-gfac16a0 #1)
[ 4095.064605] PC is at jbd2_journal_file_inode+0x38/0x118
[ 4095.064666] LR is at mpage_da_map_and_submit+0x48c/0x618
[ 4095.064697] pc : [<c01da5a8>]    lr : [<c01aeac0>]    psr: 60000013
[ 4095.064697] sp : c6e07c80  ip : c6e07ca0  fp : c6e07c9c
[ 4095.064727] r10: 00000001  r9 : c6e06000  r8 : 00000179
[ 4095.064758] r7 : c6e07ca0  r6 : c73b8400  r5 : 00000000  r4 : c59a7d80
[ 4095.064758] r3 : 00000038  r2 : 00000800  r1 : 00000000  r0 : c7754fc0
[ 4095.064788] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 4095.064819] Control: 10c5387d  Table: 86cc804a  DAC: 00000015
[ 4095.064849]
[ 4095.064849] PC: 0xc01da528:
[ 4095.064880] a528  0a000003 e3a05000 e1a00005 e24bd020 e89da9f0 e5951010 e3e06000 e14b22dc
.....
[ 4095.070373] 7fe0: c00a48ac 00000013 00000000 c6e07ff8 c00a48ac c00c0a94 84752f09 60772177
[ 4095.070404] Backtrace:
[ 4095.070465] [<c01da570>] (jbd2_journal_file_inode+0x0/0x118) from [<c01aeac0>] (mpage_da_map_and_submit+0x48c/0x618)
[ 4095.070495]  r7:c6e07ca0 r6:c6e07d00 r5:c6e07d90 r4:c7754fc0
[ 4095.070556] [<c01ae634>] (mpage_da_map_and_submit+0x0/0x618) from [<c01af40c>] (ext4_da_writepages+0x2a4/0x5c8)
[ 4095.070617] [<c01af168>] (ext4_da_writepages+0x0/0x5c8) from [<c0112af4>] (do_writepages+0x34/0x40)
[ 4095.070678] [<c0112ac0>] (do_writepages+0x0/0x40) from [<c01645a4>] (writeback_single_inode+0xd4/0x288)
[ 4095.070709] [<c01644d0>] (writeback_single_inode+0x0/0x288) from [<c0164ed4>] (writeback_sb_inodes+0xb4/0x184)
[ 4095.070770] [<c0164e20>] (writeback_sb_inodes+0x0/0x184) from [<c01655a0>] (writeback_inodes_wb+0xc4/0x13c)
[ 4095.070831] [<c01654dc>] (writeback_inodes_wb+0x0/0x13c) from [<c01658f0>] (wb_writeback+0x2d8/0x464)
[ 4095.070861] [<c0165618>] (wb_writeback+0x0/0x464) from [<c0165cb8>] (wb_do_writeback+0x23c/0x2c4)
[ 4095.070922] [<c0165a7c>] (wb_do_writeback+0x0/0x2c4) from [<c0165df4>] (bdi_writeback_thread+0xb4/0x2dc)
[ 4095.070953] [<c0165d40>] (bdi_writeback_thread+0x0/0x2dc) from [<c00c0b18>] (kthread+0x90/0x98)
[ 4095.071014] [<c00c0a88>] (kthread+0x0/0x98) from [<c00a48ac>] (do_exit+0x0/0x72c)
[ 4095.071044]  r7:00000013 r6:c00a48ac r5:c00c0a88 r4:c78c7ec4
[ 4095.071105] Code: e89da8f0 e5963000 e3130002 1afffffa (e5913000)
[ 4095.071166] ---[ end trace 7fe9f9b727e5cf78 ]---
[ 4095.071197] Kernel panic - not syncing: Fatal exception

The probably reason of such behaviour is an inode opened in READ mode
has been marked as 'dirty' somehow and written back by ext4_da_writepages.
Cause jinode == NULL it could lead to the kernel panic.

The patch prevents kernel panic and helps to investigate the problem
providing an inode number.

The patch applies to the kernel version 3.0.46.

Signed-off-by: Volodymyr Mieshkov <volodymyr.mieshkov@ti.com>
---
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 95af6f8..f1f9dd5 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -240,8 +240,15 @@ static inline int ext4_journal_force_commit(journal_t *journal)
 
 static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
-	if (ext4_handle_valid(handle))
+	if (ext4_handle_valid(handle)) {
+		if (unlikely(EXT4_I(inode)->jinode == NULL)) {
+			/* Should never happen */
+			WARN(true, "inode #%lu has NULL jinode\n",
+				inode->i_ino);
+			return 0;
+		}
 		return jbd2_journal_file_inode(handle, EXT4_I(inode)->jinode);
+	}
 	return 0;
 }
 
-- 
1.7.0.4
