Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2ABC46467
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Jan 2023 04:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjAJEF3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 9 Jan 2023 23:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjAJEFV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jan 2023 23:05:21 -0500
X-Greylist: delayed 91 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 Jan 2023 20:05:18 PST
Received: from omta001.cacentral1.a.cloudfilter.net (omta001.cacentral1.a.cloudfilter.net [3.97.99.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10F0178B9
        for <linux-ext4@vger.kernel.org>; Mon,  9 Jan 2023 20:05:18 -0800 (PST)
Received: from shw-obgw-4004a.ext.cloudfilter.net ([10.228.9.227])
        by cmsmtp with ESMTP
        id F1qOppuvmc9C4F5rWp0PWq; Tue, 10 Jan 2023 04:03:46 +0000
Received: from centos7.dilger.int ([70.77.221.9])
        by cmsmtp with ESMTP
        id F5rVpYzG73fOSF5rVpEx6L; Tue, 10 Jan 2023 04:03:46 +0000
X-Authority-Analysis: v=2.4 cv=J8G5USrS c=1 sm=1 tr=0 ts=63bce3a2
 a=2Y6h5+ypAxmHcsumz2f7Og==:117 a=2Y6h5+ypAxmHcsumz2f7Og==:17 a=RPJ6JBhKAAAA:8
 a=5Gn-ALmo8zlZPzAHQEsA:9 a=fa_un-3J20JGBB2Tu-mn:22
From:   Andreas Dilger <adilger@dilger.ca>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: fix r_move_itable_realloc to run on Linux
Date:   Mon,  9 Jan 2023 21:02:52 -0700
Message-Id: <1673323372-13786-1-git-send-email-adilger@dilger.ca>
X-Mailer: git-send-email 1.8.3.1
X-CMAE-Envelope: MS4xfOfBY30R9lqcF+GN456hBnTKbr3f3hN0uIxvHNoULe/EAL/wF70XrSkbpwC9XupsT8JTXSRpt5TCMiHyMit/pFZTAwfRL7SjGPIAqRdL8KwWDJ1MPgEj
 obPyL6dsxluvuDcWReAVr0ti7fDPsHZwnLz451mxD0fi6olQZkGETtoIhjPytaMPdZgchpqbR0UDo1GnySeySkvIJYXFRTj8/rO+CTOnYZwXR7EzdBj5LAKN
 MqUD91zMxx0LRATgh/58Bw==
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The check for the various unsupported OSes incorrectly checked if
the string "FreeBSD" was true, which it always was.  Fix this.

Update the expect file as commit v1.46.4-17-g4ea80d031c7e did to
adjust the total number of blocks requested during resize.

Change-Id: I272dbec67ab30bac6413eb4cba0e3ab00183b893
Fixes: 5a3ea3905f ("tests: force test file systems to be built for Linux OS")
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/r_move_itable_realloc/expect | 2 +-
 tests/r_move_itable_realloc/script | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/r_move_itable_realloc/expect b/tests/r_move_itable_realloc/expect
index 67f2fe4a8a6b..8ce56dbc07dd 100644
--- a/tests/r_move_itable_realloc/expect
+++ b/tests/r_move_itable_realloc/expect
@@ -1,6 +1,6 @@
 mke2fs -q -F -o Linux -b 1024 -i 1024 -O ^resize_inode -t ext4 test.img 1024000
 resize2fs -p test.img 100000000
-Resizing the filesystem on test.img to 100000000 (1k) blocks.
+Resizing the filesystem on test.img to 99999745 (1k) blocks.
 Begin pass 2 (max = 2061)
 Relocating blocks             ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 Begin pass 3 (max = 125)
diff --git a/tests/r_move_itable_realloc/script b/tests/r_move_itable_realloc/script
index 20c26dbd9a9c..49f8d58a2783 100644
--- a/tests/r_move_itable_realloc/script
+++ b/tests/r_move_itable_realloc/script
@@ -1,5 +1,5 @@
 os=$(uname -s)
-if [ "$os" = "Darwin" -o "$os" = "GNU" -o "FreeBSD" ]; then
+if [ "$os" = "Darwin" -o "$os" = "GNU" -o "$os" = "FreeBSD" ]; then
 	# creates a 96GB filesystem
 	echo "$test_name: $test_description: skipped: skipped for $os"
 	return 0
-- 
1.8.3.1

