From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: [PATCH] [e2fsprogs] Add ZFS test image.
Date: Fri, 04 Jul 2008 19:13:40 +0100
Message-ID: <1215195220.32651.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:40910 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYGDSNr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2008 14:13:47 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m64IDhpf006565
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jul 2008 18:13:46 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3H00401UMN5Y00@fe-emea-10.sun.com>
 (original mail from Ricardo.M.Correia@Sun.COM) for linux-ext4@vger.kernel.org;
 Fri, 04 Jul 2008 19:13:43 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Ricardo M. Correia <Ricardo.M.Correia@Sun.COM>
---
 lib/blkid/tests/zfs.img.bz2 |  Bin 0 -> 10869 bytes
 lib/blkid/tests/zfs.results |    1 +
 2 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 lib/blkid/tests/zfs.img.bz2
 create mode 100644 lib/blkid/tests/zfs.results

diff --git a/lib/blkid/tests/zfs.img.bz2 b/lib/blkid/tests/zfs.img.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..92f445a3b097ad11298b9dfbfd8c9242ee690572
GIT binary patch
literal 10869
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
LML1B9R@T4I*xD3b

literal 0
HcmV?d00001

diff --git a/lib/blkid/tests/zfs.results b/lib/blkid/tests/zfs.results
new file mode 100644
index 0000000..c0f8fb9
--- /dev/null
+++ b/lib/blkid/tests/zfs.results
@@ -0,0 +1 @@
+TYPE='zfs'
-- 
1.5.4.3

