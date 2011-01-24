From: Coly Li <i@coly.li>
Subject: [PATCH] mballoc: don't change cpa if cur_distance is equal to new_distance
Date: Tue, 25 Jan 2011 01:09:12 +0800
Message-ID: <4D3DB238.80804@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:43054 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753397Ab1AXQnW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Jan 2011 11:43:22 -0500
Received: from [123.122.97.153] (helo=[192.168.1.6])
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <i@coly.li>)
	id 1PhPVg-00058K-6s
	for linux-ext4@vger.kernel.org; Mon, 24 Jan 2011 09:43:20 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_check_group_pa(), cur_distance is selected to return only when it's smaller than new_distance, this is 
unreasonable. If cur_distance is equal to new_distance, current code will return new_distance to update cpa from 
ext4_mb_use_preallocated(), which is unnecessary and a wast of CPU cycles.

This patch makes new_distance to return only when it's smaller then cur_distance, which avoids unnecessary cpa update in 
ext4_mb_use_preallocated().

Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
  fs/ext4/mballoc.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..5f564d7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3188,7 +3188,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
  	cur_distance = abs(goal_block - cpa->pa_pstart);
  	new_distance = abs(goal_block - pa->pa_pstart);

-	if (cur_distance < new_distance)
+	if (cur_distance <= new_distance)
  		return cpa;

  	/* drop the previous reference */
-- 
Coly Li
