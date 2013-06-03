From: Ruslan Bilovol <ruslan.bilovol@ti.com>
Subject: [PATCH 2/2] ext4: add sanity checks in __ext4_check_dir_entry
Date: Mon,  3 Jun 2013 13:00:16 +0300
Message-ID: <1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45505 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3FCKA0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 06:00:26 -0400
In-Reply-To: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added checks for NULL before dereferencing some pointers

This fixes next issue:

[ 1531.530609] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[ 1531.543151] pgd = d6068000
[ 1531.546112] [00000004] *pgd=00000000
[ 1531.550109] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[ 1531.555816] Modules linked in: rproc_drm(O) tf_driver(O) gps_drv wl18xx(O) wl12xx(O) wlcore(O) mac80211(O) cfg80211(O) pvrsrvkm_sgx540_120(O) compat(O)
[ 1531.571105] CPU: 0    Tainted: G        W  O  (3.4.34 #1)
[ 1531.576934] PC is at __ext4_check_dir_entry+0x24/0x1a4
[ 1531.582550] LR is at ext4_readdir+0x270/0x7fc
[ 1531.587249] pc : [<c017a788>]    lr : [<c017ab78>]    psr: 80000113
[ 1531.587249] sp : d6051e50  ip : 00000000  fp : d6051eb4
[ 1531.599700] r10: d4f0fdb0  r9 : c06a5c54  r8 : 000000d5
[ 1531.605377] r7 : d4c54540  r6 : d4634948  r5 : 00000000  r4 : 00000000
[ 1531.612396] r3 : d4634948  r2 : d4f0fdb0  r1 : 000000d5  r0 : c06a5c54
[ 1531.619476] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[ 1531.627166] Control: 10c5387d  Table: 9606804a  DAC: 00000015
[...]
[ 1532.654876] Backtrace:
[ 1532.657653] [<c017a764>] (__ext4_check_dir_entry+0x0/0x1a4) from [<c017ab78>] (ext4_readdir+0x270/0x7fc)
[ 1532.667968] [<c017a908>] (ext4_readdir+0x0/0x7fc) from [<c0124860>] (vfs_readdir+0x9c/0xc0)
[ 1532.677062] [<c01247c4>] (vfs_readdir+0x0/0xc0) from [<c0124a0c>] (sys_getdents64+0x68/0xc0)
[ 1532.686248] [<c01249a4>] (sys_getdents64+0x0/0xc0) from [<c0013680>] (ret_fast_syscall+0x0/0x30)
[ 1532.695800]  r7:000000d9 r6:00000000 r5:416d4168 r4:416d4158
[ 1532.702270] Code: e1a07003 e1a09000 e1a08001 e59b3008 (e1dc40b4)

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 fs/ext4/dir.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f8d56e4..cf0875b 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -68,8 +68,12 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 			   unsigned int offset)
 {
 	const char *error_msg = NULL;
-	const int rlen = ext4_rec_len_from_disk(de->rec_len,
-						dir->i_sb->s_blocksize);
+	int rlen;
+
+	if (!de || !bh || !dir)
+		return 1;
+
+	rlen = ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize);
 
 	if (unlikely(rlen < EXT4_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-- 
1.7.9.5

