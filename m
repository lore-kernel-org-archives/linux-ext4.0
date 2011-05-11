From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
Date: Wed, 11 May 2011 10:10:41 +0300
Message-ID: <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
References: <4DCA3583.7010904@canonical.com>
Cc: jack@suse.cz, marco.stornelli@gmail.com, adilger.kernel@dilger.ca,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33647 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1EKTRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 15:17:35 -0400
In-Reply-To: <4DCA3583.7010904@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While the fsstress background writes are busy dirtying the page cache, if a
fsfreeze happens then the background writes should stall. A sync should then
not have any data to sync to the FS. If it does have any data to sync then
sync will cause a deadlock by holding the s_umount write semaphore and waiting
in the wait queue for the FS to thaw, whereas the F.S can never thaw without
getting the s_umount write semaphore.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 068 |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/068 b/068
index 82c1a4e..b9ac58d 100755
--- a/068
+++ b/068
@@ -101,6 +101,11 @@ do
 	    tee -a $seq.full
 	sleep 2
 
+	# there should be nothing to sync at this point. This may hang in case
+	# of fsstress background writes dirtying the page cache while the F.S is frozen
+	sync &
+	sleep 2
+
 	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seq.full
 	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seq.full
 	[ $? != 0 ] && echo xfs_freeze -u "$SCRATCH_MNT" failed | \
-- 
1.7.1

