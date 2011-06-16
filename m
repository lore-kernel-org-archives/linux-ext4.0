From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3] jbd2,rcu: correctly use RCU
Date: Thu, 16 Jun 2011 09:47:04 +0800
Message-ID: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Tso" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-k
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In read site, we need to use local_ptr = rcu_dereference(),
and then use this local_ptr to read the content.

In update site, we should assign/publish the new object/pointer after
the content of the new object/pointer is fully initialized,
and we can't not touch the object after the pointer assignment.
rcu_assign_pointer() is need for the assignement.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/jbd2/journal.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9267291..1c45b6a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2439,7 +2439,7 @@ struct devname_cache {
 	char		devname[BDEVNAME_SIZE];
 };
 #define CACHE_SIZE_BITS 6
-static struct devname_cache *devcache[1 << CACHE_SIZE_BITS];
+static struct devname_cache __rcu *devcache[1 << CACHE_SIZE_BITS];
 static DEFINE_SPINLOCK(devname_cache_lock);
 
 const char *jbd2_dev_to_name(dev_t device)
@@ -2447,24 +2447,25 @@ const char *jbd2_dev_to_name(dev_t device)
 	int	i = hash_32(device, CACHE_SIZE_BITS);
 	char	*ret;
 	struct block_device *bd;
-	static struct devname_cache *new_dev;
+	static struct devname_cache *cache;
 
 	rcu_read_lock();
-	if (devcache[i] && devcache[i]->device == device) {
-		ret = devcache[i]->devname;
+	cache = rcu_dereference(devcache[i]);
+	if (cache && cache->device == device) {
+		ret = cache->devname;
 		rcu_read_unlock();
 		return ret;
 	}
 	rcu_read_unlock();
 
-	new_dev = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
-	if (!new_dev)
+	cache = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
+	if (!cache)
 		return "NODEV-ALLOCFAILURE"; /* Something non-NULL */
 	bd = bdget(device);
 	spin_lock(&devname_cache_lock);
 	if (devcache[i]) {
 		if (devcache[i]->device == device) {
-			kfree(new_dev);
+			kfree(cache);
 			bdput(bd);
 			ret = devcache[i]->devname;
 			spin_unlock(&devname_cache_lock);
@@ -2472,14 +2473,14 @@ const char *jbd2_dev_to_name(dev_t device)
 		}
 		kfree_rcu(devcache[i], rcu);
 	}
-	devcache[i] = new_dev;
-	devcache[i]->device = device;
+	cache->device = device;
 	if (bd) {
-		bdevname(bd, devcache[i]->devname);
+		bdevname(bd, cache->devname);
 		bdput(bd);
 	} else
-		__bdevname(device, devcache[i]->devname);
-	ret = devcache[i]->devname;
+		__bdevname(device, cache->devname);
+	rcu_assign_pointer(devcache[i], cache);
+	ret = cache->devname;
 	spin_unlock(&devname_cache_lock);
 	return ret;
 }
-- 
1.7.4.4
