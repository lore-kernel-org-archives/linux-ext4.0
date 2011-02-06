From: Coly Li <i@coly.li>
Subject: [PATCH 5/5] mballoc: don't change cpa if cur_distance is equal to
 new_distance
Date: Sun, 06 Feb 2011 12:54:18 +0800
Message-ID: <4D4E297A.8090801@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:52031 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752574Ab1BFE2G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:28:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_check_group_pa(), cur_distance is selected to return only
when it's smaller than new_distance, this is unreasonable. If
cur_distance is equal to new_distance, current code will return
new_distance to update cpa from ext4_mb_use_preallocated(), which doesn't
make any sense.

This patch makes new_distance to return only when it's smaller then
cur_distance, which avoids unnecessary cpa update in
ext4_mb_use_preallocated().

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 569cff6..af706f6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3181,7 +3181,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
  	cur_distance = abs(goal_block - cpa->pa_pstart);
  	new_distance = abs(goal_block - pa->pa_pstart);

-	if (cur_distance < new_distance)
+	if (cur_distance <= new_distance)
  		return cpa;

  	/* drop the previous reference */
-- 
1.7.3.4
