From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] naturally align struct ext4_allocation_request
Date: Thu, 25 Jun 2009 20:09:40 -0500
Message-ID: <4A441FD4.9020403@redhat.com>
References: <4A4254C2.8000609@redhat.com> <170fa0d20906251750u697b32e3yb92eab53b51556a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZFZBJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 21:09:40 -0400
In-Reply-To: <170fa0d20906251750u697b32e3yb92eab53b51556a3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As Ted noted, the ext4_allocation_request isn't well aligned.

Looking at it with pahole we're wasting space on 64-bit
arches:

struct ext4_allocation_request {
        struct inode *             inode;              /*     0     8 */
        ext4_lblk_t                logical;            /*     8     4 */

        /* XXX 4 bytes hole, try to pack */

        ext4_fsblk_t               goal;               /*    16     8 */
        ext4_lblk_t                lleft;              /*    24     4 */

        /* XXX 4 bytes hole, try to pack */

        ext4_fsblk_t               pleft;              /*    32     8 */
        ext4_lblk_t                lright;             /*    40     4 */

        /* XXX 4 bytes hole, try to pack */

        ext4_fsblk_t               pright;             /*    48     8 */
        unsigned int               len;                /*    56     4 */
        unsigned int               flags;              /*    60     4 */
        /* --- cacheline 1 boundary (64 bytes) --- */

        /* size: 64, cachelines: 1, members: 9 */
        /* sum members: 52, holes: 3, sum holes: 12 */
};

grouping 32-bit members together closes these holes and shrinks
the structure by 12 bytes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: fix comments, thanks to Mike Snitzer

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cc7d5ed..cefd94a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -93,20 +93,20 @@ typedef unsigned int ext4_group_t;
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
 	struct inode *inode;
+	/* how many blocks we want to allocate */
+	unsigned int len;
 	/* logical block in target inode */
 	ext4_lblk_t logical;
-	/* phys. target (a hint) */
-	ext4_fsblk_t goal;
 	/* the closest logical allocated block to the left */
 	ext4_lblk_t lleft;
-	/* phys. block for ^^^ */
-	ext4_fsblk_t pleft;
 	/* the closest logical allocated block to the right */
 	ext4_lblk_t lright;
-	/* phys. block for ^^^ */
+	/* phys. target (a hint) */
+	ext4_fsblk_t goal;
+	/* phys. block for the closest logical allocated block to the left */
+	ext4_fsblk_t pleft;
+	/* phys. block for the closest logical allocated block to the right */
 	ext4_fsblk_t pright;
-	/* how many blocks we want to allocate */
-	unsigned int len;
 	/* flags. see above EXT4_MB_HINT_* */
 	unsigned int flags;
 };

