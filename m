From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] jbd2,rcu: simpify jbd2_dev_to_name()
Date: Thu, 16 Jun 2011 09:47:06 +0800
Message-ID: <2aafd695ef8e4c263e98bdd123a9117dc4ef4a85.1308131437.git.laijs@cn.fujitsu.com>
References: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Tso" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-k
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Simpify jbd2_dev_to_name() and use xchg() to make the update side
wait-free and remove the spinlock.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/jbd2/journal.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c37597a..7d5b6ac 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2437,7 +2437,6 @@ struct devname_cache {
 };
 #define CACHE_SIZE_BITS 6
 static struct devname_cache __rcu *devcache[1 << CACHE_SIZE_BITS];
-static DEFINE_SPINLOCK(devname_cache_lock);
 
 void jbd2_dev_to_name(dev_t device, char *devname)
 {
@@ -2445,6 +2444,7 @@ void jbd2_dev_to_name(dev_t device, char *devname)
 	struct block_device *bd;
 	static struct devname_cache *cache;
 
+	/* get the name from the cache */
 	rcu_read_lock();
 	cache = rcu_dereference(devcache[i]);
 	if (cache && cache->device == device) {
@@ -2454,32 +2454,28 @@ void jbd2_dev_to_name(dev_t device, char *devname)
 	}
 	rcu_read_unlock();
 
-	cache = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
-	if (!cache) {
+	/* slowly get the name */
+	bd = bdget(device);
+	if (bd) {
+		bdevname(bd, devname);
+		bdput(bd);
+	} else {
 		__bdevname(device, devname);
 		return;
 	}
-	bd = bdget(device);
-	spin_lock(&devname_cache_lock);
-	if (devcache[i]) {
-		if (devcache[i]->device == device) {
-			kfree(cache);
-			bdput(bd);
-			memcpy(devname, devcache[i]->devname, BDEVNAME_SIZE);
-			spin_unlock(&devname_cache_lock);
-			return;
-		}
-		kfree_rcu(devcache[i], rcu);
-	}
+
+	/* put the name to the cache */
+	cache = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
+	if (!cache)
+		return;
+
+	memcpy(cache->devname, devname, BDEVNAME_SIZE);
 	cache->device = device;
-	if (bd) {
-		bdevname(bd, cache->devname);
-		bdput(bd);
-	} else
-		__bdevname(device, cache->devname);
-	rcu_assign_pointer(devcache[i], cache);
-	memcpy(devname, cache->devname, BDEVNAME_SIZE);
-	spin_unlock(&devname_cache_lock);
+	cache = xchg(&devcache[i], cache);
+
+	/* free old cache by RCU */
+	if (cache)
+		kfree_rcu(cache, rcu);
 }
 EXPORT_SYMBOL(jbd2_dev_to_name);
 
-- 
1.7.4.4
