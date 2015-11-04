From: Jan Kara <jack@suse.com>
Subject: [PATCH 2/4] ext4/001: Update output
Date: Wed,  4 Nov 2015 17:31:36 +0100
Message-ID: <1446654698-23577-3-git-send-email-jack@suse.com>
References: <1446654698-23577-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1446654698-23577-1-git-send-email-jack@suse.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

After patch "ext4: Fix races of writeback with punch hole and zero
range" we don't flush range that's going to be zeroed out which results
in different final extent layout because some extents will be zeroed-out
instead of being split. Update the output file accordingly.

Signed-off-by: Jan Kara <jack@suse.com>
---
 tests/ext4/001.out | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tests/ext4/001.out b/tests/ext4/001.out
index 212c24783387..c2f728483b23 100644
--- a/tests/ext4/001.out
+++ b/tests/ext4/001.out
@@ -131,14 +131,10 @@ cc63069677939f69a6e8f68cae6a6dac
 2: [32..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
+0: [0..39]: data
 f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
+0: [0..39]: unwritten
 daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
 0: [0..7]: data
-- 
2.1.4
