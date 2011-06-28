From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 3/3 v2] XFS TESTS: Fix 252 Failure: Update 242 Golden Output
Date: Mon, 27 Jun 2011 21:27:27 -0700
Message-ID: <1309235247-32650-4-git-send-email-achender@linux.vnet.ibm.com>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52373 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab1F1EZK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 00:25:10 -0400
In-Reply-To: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New filtered golden output for test 242. Another patch
has been sumbitted that also modifies the 242 output, and
this set has been adjusted to apply on top of it.

This patch requires Christoph's
"[PATCH] xfstests: update test 042 golden output" (06/20/2011)

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 e69382c... 649ac04... M	242.out
 242.out |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/242.out b/242.out
index e69382c..649ac04 100644
--- a/242.out
+++ b/242.out
@@ -3,58 +3,75 @@ QA output created by 242
 0: [0..7]: hole
 1: [8..23]: unwritten
 2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: unwritten
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..7]: hole
 1: [8..23]: unwritten
 2: [24..31]: data
 3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
 0: [0..7]: hole
 1: [8..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: data
 1: [8..23]: unwritten
 2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
 0: [0..23]: unwritten
 1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
 0: [0..23]: unwritten
 1: [24..31]: data
 2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
 0: [0..7]: hole
 1: [8..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: unwritten
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: unwritten
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: unwritten
+56819989ef2d9f40785adce8c06b64d0
-- 
1.7.1

