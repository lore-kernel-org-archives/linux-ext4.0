From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] full first bg mkfs test
Date: Fri, 20 Jul 2007 17:03:52 -0500
Message-ID: <46A13148.8030700@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050408090008050901050500"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbXGTWJg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 18:09:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6KM9Z2R003769
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:09:35 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6KM9ZRG016749
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:09:35 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l6KM9Y0v020205
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:09:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------050408090008050901050500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Testcase for inode table extending to last block of first bg

(test image attached, not sure how to make a binary diff here!)

(image is *not* corrupt and should check cleanly twice)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/tests/f_full_bg/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/tests/f_full_bg/expect.1
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/3744 files (9.1% non-contiguous), 685/769 blocks
+Exit status is 0
Index: e2fsprogs-1.40.2/tests/f_full_bg/expect.2
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/tests/f_full_bg/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/3744 files (9.1% non-contiguous), 685/769 blocks
+Exit status is 0
Index: e2fsprogs-1.40.2/tests/f_full_bg/name
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/tests/f_full_bg/name
@@ -0,0 +1 @@
+inode table in last block of first bg
Index: e2fsprogs-1.40.2/tests/f_full_bg/image.gz
===================================================================
Binary files /dev/null and e2fsprogs-1.40.2/tests/f_full_bg/image.gz differ



--------------050408090008050901050500
Content-Type: application/x-gzip;
 name="image.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="image.gz"

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
AAQMAA==
--------------050408090008050901050500--
