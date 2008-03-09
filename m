From: Joe Perches <joe@perches.com>
Subject: [PATCH] include/linux/ext4_fs.h - remove duplicate include
Date: Sun, 09 Mar 2008 16:55:04 -0700
Message-ID: <1205106904.656.98.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4379 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYCIX73 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Mar 2008 19:59:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/ext4_fs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 2500325..5c1677a 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/magic.h>
