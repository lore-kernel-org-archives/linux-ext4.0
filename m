From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/12] xfs/073: fix output
Date: Fri, 04 Mar 2016 16:38:03 -0800
Message-ID: <20160305003803.28738.34407.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234AbcCEAiL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2016 19:38:11 -0500
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/073.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/073.out b/tests/xfs/073.out
index 3f27467..fb035cb 100644
--- a/tests/xfs/073.out
+++ b/tests/xfs/073.out
@@ -1,4 +1,7 @@
 QA output created by 073
+warning: finobt not supported without CRC support, disabled.
+warning: rmapbt not supported without CRC support, disabled.
+warning: reflink not supported without CRC support, disabled.
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
          = sunit=XXX swidth=XXX, unwritten=X

