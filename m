From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] vfs: Add BUG_ON for delayed and unwritten flags in submit_bh()
Date: Tue, 12 May 2009 18:45:26 -0400
Message-ID: <1242168327-31127-6-git-send-email-tytso@mit.edu>
References: <1242168327-31127-1-git-send-email-tytso@mit.edu>
 <1242168327-31127-2-git-send-email-tytso@mit.edu>
 <1242168327-31127-3-git-send-email-tytso@mit.edu>
 <1242168327-31127-4-git-send-email-tytso@mit.edu>
 <1242168327-31127-5-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1242168327-31127-5-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The BH_Delay and BH_Unwritten flags should never leak out to
submit_bh().  So add some BUG_ON() checks to submit_bh so we can get a
stack trace and determine how and why this might have happened.

(Note that only XFS and ext4 use these buffer head flags, and XFS does
not use submit_bh().  So this patch should only modify behavior for
ext4.)

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aed2977..ad01129 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2933,6 +2933,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
+	BUG_ON(buffer_delay(bh));
+	BUG_ON(buffer_unwritten(bh));
 
 	/*
 	 * Mask in barrier bit for a write (could be either a WRITE or a
-- 
1.6.3.rc4.1.g3e14.dirty

