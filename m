From: Ruslan Bilovol <ruslan.bilovol@ti.com>
Subject: [PATCH 1/2] jbd2: check bh->b_data for NULL in jbd2_journal_get_descriptor_buffer before memset()
Date: Mon,  3 Jun 2013 13:00:15 +0300
Message-ID: <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43529 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3FCKAX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 06:00:23 -0400
In-Reply-To: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The memset() doesn't perform any NULL-pointer checking
before dereferencing passed pointer so this should be
checked before calling it.

This fixes next issue:

[38200.069122] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[38200.078002] pgd = c0004000
[38200.080963] [00000000] *pgd=00000000
[38200.084991] Internal error: Oops: 805 [#1] PREEMPT SMP ARM
[38200.091003] Modules linked in: rproc_drm(O) tf_driver(O) gps_drv wl18xx(O) wl12xx(O) wlcore(O) mac80211(O) cfg80211(O) pvrsrvkm_sgx540_120(O) compat(O)
[38200.106719] CPU: 1    Tainted: G        W  O  (3.4.34 #1)
[38200.112579] PC is at __memzero+0x24/0x80
[38200.116882] LR is at 0x0
[38200.119689] pc : [<c023b004>]    lr : [<00000000>]    psr: 28000113
[38200.119689] sp : d66b1e2c  ip : 00000000  fp : d66b1e54
[38200.132171] r10: 00000000  r9 : d6ad48c0  r8 : c01bd414
[38200.137847] r7 : 00000000  r6 : ffffffff  r5 : cb19fe48  r4 : d678bc00
[38200.144958] r3 : 00000000  r2 : 00000000  r1 : 00000fc0  r0 : 00000000
[38200.152008] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[38200.160034] Control: 10c5387d  Table: 967b004a  DAC: 00000015
[...]
[38200.888031] Backtrace:
[38200.890869] [<c01c509c>] (jbd2_journal_get_descriptor_buffer+0x0/0xa4) from [<c01bddf0>] (jbd2_journal_commit_transaction+0x994/0x18f4)
[38200.903930]  r5:d6ad5348 r4:d678bc00
[38200.907989] [<c01bd45c>] (jbd2_journal_commit_transaction+0x0/0x18f4) from [<c01c2e70>] (kjournald2+0xb4/0x24c)
[38200.918884] [<c01c2dbc>] (kjournald2+0x0/0x24c) from [<c0066990>] (kthread+0x90/0x9c)
[38200.927429] [<c0066900>] (kthread+0x0/0x9c) from [<c004a968>] (do_exit+0x0/0x804)
[38200.935577]  r6:c004a968 r5:c0066900 r4:d6749c8c
[38200.940887] Code: e52de004 e1a0c002 e1a0e002 e2511040 (a8a0500c)

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9545757..48f3da5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -810,7 +810,7 @@ struct journal_head *jbd2_journal_get_descriptor_buffer(journal_t *journal)
 		return NULL;
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
-	if (!bh)
+	if (!bh || !bh->b_data)
 		return NULL;
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
-- 
1.7.9.5

