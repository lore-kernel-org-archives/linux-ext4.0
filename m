From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCHSET] e2fsprogs: Next3 patch series
Date: Wed, 05 May 2010 21:28:48 +0300
Message-ID: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0EESv7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:51:59 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:27:36 +0300 (IDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

The following patch series applies to latest e2fsprogs git tree.
Please let me know what you think about these changes in general
and more specifically, what do you think about accepting the
Next3 on-disk format and features to e2fsprogs?

Thanks,
Amir.

[PATCH 1/8] e2fsprogs: Next3 on-disk format changes.
[PATCH 2/8] e2fsprogs: Add big_journal feature for Next3.
[PATCH 3/8] e2fsprogs: Add exclude_inode feature for Next3.
[PATCH 4/8] e2fsprogs: Next3 snapshot control with chattr/lsattr -X.
[PATCH 5/8] e2fsprogs: Add has_snapshot feature for Next3.
[PATCH 6/8] e2fsprogs: Cleanup Next3 snapshot list when removing has_snapshot feature.
[PATCH 7/8] e2fsprogs: Check Next3 exclude bitmap on fsck.
[PATCH 8/8] e2fsprogs: Dump Next3 message buffer on fsck.
