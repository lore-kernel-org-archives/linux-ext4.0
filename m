From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: skip project quota tests if the kernel does not support them
Date: Sun,  8 Oct 2017 15:27:46 -0400
Message-ID: <20171008192746.20709-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49634 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753408AbdJHT1t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 8 Oct 2017 15:27:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In _scratch_enable_pquota, use _notrun if the file system with project
quotas enable can't be mounted, since that indicates the kernel
doesn't support that feature.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 common/quota | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/quota b/common/quota
index f49728c2..d027a8c1 100644
--- a/common/quota
+++ b/common/quota
@@ -119,6 +119,9 @@ _scratch_enable_pquota()
 	[ "$FSTYP" != "ext4" ] && return
 
 	tune2fs -O quota,project $SCRATCH_DEV >>$seqres.full 2>&1
+	_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel doesn't support project feature on $FSTYP"
+	_scratch_unmount
 }
 
 #
-- 
2.11.0.rc0.7.gbe5a750
