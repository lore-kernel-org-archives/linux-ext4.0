From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/6] e2fsprogs: Fix the resize inode test case
Date: Mon, 13 Aug 2007 15:56:25 +0530
Message-ID: <11870008042147-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11870007861341-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007892653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007931987-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007962358-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007992253-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:57148 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942212AbXHMLWS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 07:22:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DBOFGH3825692
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 21:24:18 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7DAULE1045730
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:30:22 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DBQmrZ007196
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 21:26:48 +1000
In-Reply-To: <11870007992253-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

With the new mke2fs changes the output of the
command differs if we run mke2fs on a device that
already have the file system. So erase the file system
before running mke2fs so that output remain as expected.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 tests/r_resize_inode/script |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tests/r_resize_inode/script b/tests/r_resize_inode/script
index 5422d3b..c54fdf9 100644
--- a/tests/r_resize_inode/script
+++ b/tests/r_resize_inode/script
@@ -39,6 +39,8 @@ $DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
 
 echo "--------------------------------" >> $OUT
 
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
 echo mke2fs -q -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 65536 >> $OUT
 $MKE2FS -q -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 65536 2>&1 \
 	| sed -e '1d' | grep -v "automatically checked" | 
-- 
1.5.3.rc4.67.gf9286-dirty
