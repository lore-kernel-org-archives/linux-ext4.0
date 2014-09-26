From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests-bld: specify inode size in inline test scenario conf
Date: Fri, 26 Sep 2014 18:16:46 -0400
Message-ID: <20140926221646.GA20955@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:61677 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaIZWQ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2014 18:16:59 -0400
Received: by mail-qg0-f50.google.com with SMTP id q107so9512703qgd.23
        for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2014 15:16:58 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some xfstests use test file systems that are smaller than 512 MB, and
per the mke2fs.conf default, contain 128 byte inodes.  These tests
include xfstests generic/015, generic/077, generic/083, and shared/298.
All of them fail at mkfs time when run in xfstest-bld's inline test
scenario because the inline data feature requires a minimum inode size
of 256 bytes.

Fix this problem by specifying an inode size of 256 bytes in the inline
conf file.  This allows the tester more flexibility than modifying the
xfstests themselves.

This change also makes it possible to run generic/027 successfully and
in a reasonable amount of time (less than 20 minutes on one x86-64 VM).
It also fails silently when mkfs'ing its test file system, but then
proceeds to run and reports success erroneously.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/conf/inline | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-xfstests/test-appliance/files/root/conf/inline b/kvm-xfstests/test-appliance/files/root/conf/inline
index 52b0609..9ba088f 100644
--- a/kvm-xfstests/test-appliance/files/root/conf/inline
+++ b/kvm-xfstests/test-appliance/files/root/conf/inline
@@ -1,7 +1,7 @@
 export FS=ext4
 export TEST_DEV=$VDD
 export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -O inline_data,metadata_csum,64bit"
+export MKFS_OPTIONS="-q -I 256 -O inline_data,metadata_csum,64bit"
 export EXT_MOUNT_OPTIONS="-o block_validity"
 TESTNAME="Ext4 4k block w/inline"
 
-- 
1.9.1

