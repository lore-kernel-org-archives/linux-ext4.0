From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] test-appliance: add new test configuration: ext4/lustre_mds
Date: Thu,  8 Jun 2017 23:59:43 -0400
Message-ID: <20170609035943.26447-1-tytso@mit.edu>
Cc: adilger@dilger.ca, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34910 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdFID7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Jun 2017 23:59:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This thests the file system features which are used by the Lustre MDS
that are upstream.  (The dirdata feature is not currently in the
upsteam kernel.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/lustre_mds | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/lustre_mds

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/lustre_mds b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/lustre_mds
new file mode 100644
index 0000000..39bb382
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/lustre_mds
@@ -0,0 +1,4 @@
+SIZE=small
+export EXT_MKFS_OPTIONS="-I 2048 -O ^64bit,mmp,uninit_bg,^extents,dir_nlink,quota,huge_file,flex_bg -E lazy_journal_init"
+export EXT_MOUNT_OPTIONS=""
+TESTNAME="Lustre MDS"
-- 
2.11.0.rc0.7.gbe5a750
