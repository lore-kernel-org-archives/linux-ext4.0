From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 1/2] e2fsprogs: fix data lost with mke2fs -S
Date: Thu, 22 Dec 2011 17:30:22 +0900
Message-ID: <4EF2EA9E.9080500@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42764 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1LVIbl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Dec 2011 03:31:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we run the mke2fs with the -S option and the uninit_bg feature
simultaneously, the mke2fs marks blockgroups as uninitialized.
The e2fsck which run immediately after the mke2fs
removes all of the files.

To avoid this, the patch prohibits user from
setting the -S option and the uninit_bg feature simultaneously.

Usage example of the mke2fsk -S is as follows:

1. mke2fs -t ext4 -S -O ^uninit_bg DEV
2. tune2fs -O uninit_bg DEV 
3. e2fsck DEV

#2 is not necessary only if the uninit_bg feature is not set
to ext4 originally. 

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/mke2fs.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..19f3684 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1676,6 +1676,16 @@ profile_error:
        if (tmp)
                free(tmp);

+       if (super_only == 1 &&
+           EXT2_HAS_RO_COMPAT_FEATURE((&fs_param),
+                                       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+               fprintf(stderr, _("The -S option and the uninit_bg feature "
+                                 "are not compatible.\n"
+                                 "They can not be set both "
+                                 "simultaneously.\n"));
+               exit(1);
+       }
+
        /*
         * We now need to do a sanity check of fs_blocks_count for
         * 32-bit vs 64-bit block number support.
