From: akpm@osdl.org
Subject: + ext4_ext_split-remove-dead-code.patch added to -mm tree
Date: Tue, 07 Nov 2006 12:50:07 -0800
Message-ID: <200611072050.kA7Ko7JY016000@shell0.pdx.osdl.net>
Cc: bunk@stusta.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:65215 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1753333AbWKGUxU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2006 15:53:20 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4_ext_split(): remove dead code
has been added to the -mm tree.  Its filename is
     ext4_ext_split-remove-dead-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4_ext_split(): remove dead code
From: Adrian Bunk <bunk@stusta.de>

The Coverity checker noted that this was dead code, since in all places
above in this function, "err" is immediately checked.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN fs/ext4/extents.c~ext4_ext_split-remove-dead-code fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4_ext_split-remove-dead-code
+++ a/fs/ext4/extents.c
@@ -800,9 +800,6 @@ static int ext4_ext_split(handle_t *hand
 	}
 
 	/* insert new index */
-	if (err)
-		goto cleanup;
-
 	err = ext4_ext_insert_index(handle, inode, path + at,
 				    le32_to_cpu(border), newblock);
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-telephony-ixj-fix-an-array-overrun.patch
git-alsa.patch
git-mtd.patch
git-pcmcia.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-qla2xxx-make-some-functions-static.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
acx1xx-wireless-driver.patch
drivers-edac-make-code-static.patch
ext4_ext_split-remove-dead-code.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
