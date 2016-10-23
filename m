From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: fix block_validity definition
Date: Sun, 23 Oct 2016 21:43:34 +0200
Message-ID: <1477251814-9938-1-git-send-email-fabf@skynet.be>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix ext4 documentation according to commit 45f1a9c3f63d
("ext4: enable block_validity by default")

Also fix some typos.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/filesystems/ext4.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 6c0108e..024c6db 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -351,14 +351,13 @@ nouid32			Disables 32-bit UIDs and GIDs.  This is for
 			interoperability  with  older kernels which only
 			store and expect 16-bit values.
 
-block_validity		This options allows to enables/disables the in-kernel
+block_validity(*)	This option allows to enable/disable the in-kernel
 noblock_validity	facility for tracking filesystem metadata blocks
 			within internal data structures. This allows multi-
 			block allocator and other routines to quickly locate
 			extents which might overlap with filesystem metadata
-			blocks. This option is intended for debugging
-			purposes and since it negatively affects the
-			performance, it is off by default.
+			blocks. Initially intended for debugging, it's now
+			enabled by default.
 
 dioread_lock		Controls whether or not ext4 should use the DIO read
 dioread_nolock		locking. If the dioread_nolock option is specified
-- 
2.7.4
