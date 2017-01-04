From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH] mm: support __GFP_REPEAT in kvmalloc_node
Date: Wed, 4 Jan 2017 19:12:30 +0100
Message-ID: <20170104181229.GB10183@dhcp22.suse.cz>
References: <20170102133700.1734-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
	Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
	Joe Perches <joe@perches.com>,
	Anatoly Stepanov <astepanov@cloudlinux.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170102133700.1734-1-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

While checking opencoded users I've encountered that vhost code would
really like to use kvmalloc with __GFP_REPEAT [1] so the following patch
adds support for __GFP_REPEAT and converts both vhost users.

So currently I am sitting on 3 patches. I will wait for more feedback -
especially about potential split ups or cleanups few more days and then
repost the whole series.

[1] http://lkml.kernel.org/r/20170104150800.GO25453@dhcp22.suse.cz
---
>From 0b92e4d2e040524b878d4e7b9ee88fbad5284b33 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 4 Jan 2017 18:01:39 +0100
Subject: [PATCH] mm: support __GFP_REPEAT in kvmalloc_node

vhost code uses __GFP_REPEAT when allocating vhost_virtqueue resp.
vhost_vsock because it would really like to prefer kmalloc to the
vmalloc fallback - see 23cc5a991c7a ("vhost-net: extend device
allocation to vmalloc") for more context. Michael Tsirkin has also
noted:
"
__GFP_REPEAT overhead is during allocation time.  Using vmalloc means all
accesses are slowed down.  Allocation is not on data path, accesses are.
"

Let's teach kvmalloc_node to handle __GFP_REPEAT properly. There are two
things to be careful about. First we should prevent from the OOM killer
and so have to involve __GFP_NORETRY by default and secondly override
__GFP_REPEAT for !costly order requests as the __GFP_REPEAT is ignored
for !costly orders.

This patch shouldn't introduce any functional change.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 drivers/vhost/net.c   | 9 +++------
 drivers/vhost/vsock.c | 9 +++------
 mm/util.c             | 9 +++++++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 5dc34653274a..105cd04c7414 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -797,12 +797,9 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	struct vhost_virtqueue **vqs;
 	int i;
 
-	n = kmalloc(sizeof *n, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!n) {
-		n = vmalloc(sizeof *n);
-		if (!n)
-			return -ENOMEM;
-	}
+	n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_REPEAT);
+	if (!n)
+		return -ENOMEM;
 	vqs = kmalloc(VHOST_NET_VQ_MAX * sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
 		kvfree(n);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index bbbf588540ed..7e0159867553 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -455,12 +455,9 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
-	vsock = kzalloc(sizeof(*vsock), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!vsock) {
-		vsock = vmalloc(sizeof(*vsock));
-		if (!vsock)
-			return -ENOMEM;
-	}
+	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_REPEAT);
+	if (!vsock)
+		return -ENOMEM;
 
 	vqs = kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
diff --git a/mm/util.c b/mm/util.c
index 8e4ea6cbe379..a2bfb85e60e5 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -348,8 +348,13 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 * Make sure that larger requests are not too disruptive - no OOM
 	 * killer and no allocation failure warnings as we have a fallback
 	 */
-	if (size > PAGE_SIZE)
-		kmalloc_flags |= __GFP_NORETRY | __GFP_NOWARN;
+	if (size > PAGE_SIZE) {
+		kmalloc_flags |= __GFP_NOWARN;
+
+		if (!(kmalloc_flags & __GFP_REPEAT) ||
+				(size <= PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+			kmalloc_flags |= __GFP_NORETRY;
+	}
 
 	ret = kmalloc_node(size, kmalloc_flags, node);
 
-- 
2.11.0

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
