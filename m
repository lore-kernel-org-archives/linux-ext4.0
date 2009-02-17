From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 07/24] ext4: Don't overwrite allocation_context ac_status
Date: Tue, 17 Feb 2009 10:32:25 -0500
Message-ID: <1234884762-13580-8-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42127 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbZBQPeD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 10:34:03 -0500
In-Reply-To: <1234884762-13580-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We can call ext4_mb_check_limits even after successfully allocating
the requested blocks.  In that case, make sure we don't overwrite
ac_status if it already has the status AC_STATUS_FOUND.  This fixes
the lockdep warning:

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-rc6-autokern1 #1
---------------------------------------------
fsstress/11948 is trying to acquire lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278
.....

stack backtrace:
.....
 [<c04db974>] ext4_mb_regular_allocator+0xbb5/0xd44
.....

but task is already holding lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 032115fcef837a00336ddf7bda584e89789ea498)
---
 fs/ext4/mballoc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7beab71..3bf5810 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1326,6 +1326,8 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
 	struct ext4_free_extent ex;
 	int max;
 
+	if (ac->ac_status == AC_STATUS_FOUND)
+		return;
 	/*
 	 * We don't want to scan for a whole year
 	 */
-- 
1.5.6.3

