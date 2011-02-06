From: Coly Li <i@coly.li>
Subject: [PATCH 3/5] mballoc: add comments to ext4_mb_mark_free_simple()
Date: Sun, 06 Feb 2011 12:54:00 +0800
Message-ID: <4D4E2968.5010308@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60875 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377Ab1BFE1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:27:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch tries to add comments to make ext4_mb_mark_free_simple more
readable.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.c |    7 ++++++-
  1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 458dce0..c5534f4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -630,7 +630,12 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
  #define mb_check_buddy(e4b)
  #endif

-/* FIXME!! need more doc */
+/*
+ * Devide blocks started from @first with length @len into
+ * smaller chunks with power of 2 blocks.
+ * Clear the bits in bitmap which the blocks of the chunk(s) covered,
+ * then increase bb_counters[] for corresponded chunk size.
+ */
  static void ext4_mb_mark_free_simple(struct super_block *sb,
  				void *buddy, ext4_grpblk_t first, ext4_grpblk_t len,
  					struct ext4_group_info *grp)
-- 
1.7.3.4
