From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] e2fsprogs: fix tests/f_extent_oobounds
Date: Wed, 26 Jun 2013 19:09:22 -0400
Message-ID: <51CB74A2.3020807@redhat.com>
References: <51CB41AA.5040605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3FZXJX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 19:09:23 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5QN9NXe027904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 19:09:23 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r5QN9MR4010912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 19:09:23 -0400
In-Reply-To: <51CB41AA.5040605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use $DEBUGFS and $MKE2FS to get the in-tree executables
for this test.

(Build machines which run make check shouldn't need to have
e2fsprogs installed, and we should be testing just-built versions
of the tools anyway)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: need to fix mke2fs as well as debugfs

diff --git a/tests/f_extent_oobounds/script b/tests/f_extent_oobounds/script
index 31ac6c9..b00b031 100644
--- a/tests/f_extent_oobounds/script
+++ b/tests/f_extent_oobounds/script
@@ -4,8 +4,8 @@ SKIP_GUNZIP="true"
 TEST_DATA="$test_name.tmp"
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=256 > /dev/null 2>&1
-mke2fs -Ft ext4 $TMPFILE > /dev/null 2>&1
-debugfs -w $TMPFILE << EOF  > /dev/null 2>&1
+$MKE2FS -Ft ext4 $TMPFILE > /dev/null 2>&1
+$DEBUGFS -w $TMPFILE << EOF  > /dev/null 2>&1
 write /dev/null testfile
 extent_open testfile
   insert_node 0 15 100


