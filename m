From: Steve French <smfrench@gmail.com>
Subject: [PATCH] common: update README to list build dependencies
Date: Mon, 17 Nov 2014 21:49:07 -0600
Message-ID: <1416282547-7464-1-git-send-email-smfrench@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Steve French <smfrench@gmail.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39389 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRDtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2014 22:49:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add sample list of packages (dependencies) required to build XFSTESTS
and add a step to the instructions to mention creating the test
user needed for some of the ACL tests.

Signed-off-by: Steve French <smfrench@gmail.com>
---
 README | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/README b/README
index 8a362bd..0c9449a 100644
--- a/README
+++ b/README
@@ -4,8 +4,14 @@ _______________________
 
 Building Linux:
 	- cd into the xfstests directory
+	- install prerequisite packages
+	  For example, for Ubuntu:
+		"sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs
+		 automake gcc libuuid1 quota attr libattr1-dev
+		 libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench"
 	- run make
 	- run make install
+	- create fsgqa test user ("sudo useradd fsgqa")
 	
 Building IRIX:
 	- cd into the xfstests directory 
-- 
1.9.1

