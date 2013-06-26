From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix tests/f_extent_oobounds
Date: Wed, 26 Jun 2013 15:31:54 -0400
Message-ID: <51CB41AA.5040605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3FZTb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 15:31:56 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5QJVtVS015034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 15:31:55 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r5QJVsdF015800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 15:31:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tests/f_extent_oobounds runs debugfs from the system, not
from the source tree, and if the system's debugfs doesn't
have the extent_open command it fails silently.

Use $DEBUGFS to get the right executable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/f_extent_oobounds/script b/tests/f_extent_oobounds/script
index 31ac6c9..b1f0e1a 100644
--- a/tests/f_extent_oobounds/script
+++ b/tests/f_extent_oobounds/script
@@ -5,7 +5,7 @@ TEST_DATA="$test_name.tmp"
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=256 > /dev/null 2>&1
 mke2fs -Ft ext4 $TMPFILE > /dev/null 2>&1
-debugfs -w $TMPFILE << EOF  > /dev/null 2>&1
+$DEBUGFS -w $TMPFILE << EOF  > /dev/null 2>&1
 write /dev/null testfile
 extent_open testfile
   insert_node 0 15 100

