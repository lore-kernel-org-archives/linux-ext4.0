From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 12/36] jbd2,rcu: convert call_rcu(free_devcache) to kfree_rcu()
Date: Fri, 18 Mar 2011 11:58:08 +0800
Message-ID: <4D82D850.6090702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54560 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab1CRD4W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2011 23:56:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



The rcu callback free_devcache() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_devcache).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/jbd2/journal.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 97e7346..2f2e40f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2390,11 +2390,6 @@ struct devname_cache {
 static struct devname_cache *devcache[1 << CACHE_SIZE_BITS];
 static DEFINE_SPINLOCK(devname_cache_lock);
 
-static void free_devcache(struct rcu_head *rcu)
-{
-	kfree(rcu);
-}
