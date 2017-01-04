From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: introduce kv[mz]alloc helpers
Date: Wed, 4 Jan 2017 15:20:22 +0100
Message-ID: <20170104142022.GL25453@dhcp22.suse.cz>
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

OK, so I've checked the open coded implementations and converted most of
them. There are few which are either confused and need some special
handling or need double checking.

I can fold this into the original patch or keep it as a separate patch.
Whatever works better for others.
---
>From 72a8493c4f692fca8980b59e0a79d09041164203 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 4 Jan 2017 13:30:32 +0100
Subject: [PATCH] treewide: use kv[mz]alloc* rather than opencoded variants

There are many code paths opencoding kvmalloc. Let's use the helper
instead.

This shouldn't introduce any functional change.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 arch/s390/kvm/kvm-s390.c                   | 10 ++--------
 crypto/lzo.c                               |  4 +---
 drivers/acpi/apei/erst.c                   |  8 ++------
 drivers/char/agp/generic.c                 |  8 +-------
 drivers/gpu/drm/nouveau/nouveau_gem.c      |  4 +---
 drivers/md/bcache/util.h                   | 10 ++--------
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |  9 +++------
 drivers/nvdimm/dimm_devs.c                 |  5 +----
 drivers/xen/evtchn.c                       | 14 +-------------
 fs/btrfs/ctree.c                           |  9 +++------
 fs/btrfs/ioctl.c                           |  9 +++------
 fs/btrfs/send.c                            | 27 +++++++++------------------
 fs/ceph/file.c                             |  9 +++------
 fs/select.c                                |  5 +----
 fs/xattr.c                                 | 27 +++++++++------------------
 lib/iov_iter.c                             |  5 +----
 mm/frame_vector.c                          |  5 +----
 net/netfilter/x_tables.c                   | 11 +----------
 net/sched/sch_fq.c                         | 12 +-----------
 net/sched/sch_netem.c                      |  6 +-----
 net/sched/sch_sfq.c                        |  6 +-----
 security/keys/keyctl.c                     | 22 ++++++----------------
 22 files changed, 54 insertions(+), 171 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bec71e902be3..ca590def234b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1126,10 +1126,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kmalloc_array(args->count, sizeof(uint8_t),
-			     GFP_KERNEL | __GFP_NOWARN);
-	if (!keys)
-		keys = vmalloc(sizeof(uint8_t) * args->count);
+	keys = kvmalloc(args->count * sizeof(uint8_t), GFP_KERNEL);
 	if (!keys)
 		return -ENOMEM;
 
@@ -1171,10 +1168,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kmalloc_array(args->count, sizeof(uint8_t),
-			     GFP_KERNEL | __GFP_NOWARN);
-	if (!keys)
-		keys = vmalloc(sizeof(uint8_t) * args->count);
+	keys = kvmalloc(sizeof(uint8_t) * args->count, GFP_KERNEL);
 	if (!keys)
 		return -ENOMEM;
 
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 168df784da84..218567d717d6 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -32,9 +32,7 @@ static void *lzo_alloc_ctx(struct crypto_scomp *tfm)
 {
 	void *ctx;
 
-	ctx = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL | __GFP_NOWARN);
-	if (!ctx)
-		ctx = vmalloc(LZO1X_MEM_COMPRESS);
+	ctx = kvmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index ec4f507b524f..a2898df61744 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -513,7 +513,7 @@ static int __erst_record_id_cache_add_one(void)
 	if (i < erst_record_id_cache.len)
 		goto retry;
 	if (erst_record_id_cache.len >= erst_record_id_cache.size) {
-		int new_size, alloc_size;
+		int new_size;
 		u64 *new_entries;
 
 		new_size = erst_record_id_cache.size * 2;
@@ -524,11 +524,7 @@ static int __erst_record_id_cache_add_one(void)
 				pr_warn(FW_WARN "too many record IDs!\n");
 			return 0;
 		}
-		alloc_size = new_size * sizeof(entries[0]);
-		if (alloc_size < PAGE_SIZE)
-			new_entries = kmalloc(alloc_size, GFP_KERNEL);
-		else
-			new_entries = vmalloc(alloc_size);
+		new_entries = kvmalloc(new_size * sizeof(entries[0]), GFP_KERNEL);
 		if (!new_entries)
 			return -ENOMEM;
 		memcpy(new_entries, entries,
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index f002fa5d1887..bdf418cac8ef 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -88,13 +88,7 @@ static int agp_get_key(void)
 
 void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 {
-	mem->pages = NULL;
-
-	if (size <= 2*PAGE_SIZE)
-		mem->pages = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (mem->pages == NULL) {
-		mem->pages = vmalloc(size);
-	}
+	mem->pages = kvmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(agp_alloc_page_array);
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 201b52b750dd..77dd73ff126f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -568,9 +568,7 @@ u_memcpya(uint64_t user, unsigned nmemb, unsigned size)
 
 	size *= nmemb;
 
-	mem = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!mem)
-		mem = vmalloc(size);
+	mem = kvmalloc(size, GFP_KERNEL);
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index cf2cbc211d83..9dc0f0ff0321 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -44,10 +44,7 @@ struct closure;
 	(heap)->size = (_size);						\
 	_bytes = (heap)->size * sizeof(*(heap)->data);			\
 	(heap)->data = NULL;						\
-	if (_bytes < KMALLOC_MAX_SIZE)					\
-		(heap)->data = kmalloc(_bytes, (gfp));			\
-	if ((!(heap)->data) && ((gfp) & GFP_KERNEL))			\
-		(heap)->data = vmalloc(_bytes);				\
+	(heap)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
 	(heap)->data;							\
 })
 
@@ -138,10 +135,7 @@ do {									\
 	(fifo)->front = (fifo)->back = 0;				\
 	(fifo)->data = NULL;						\
 									\
-	if (_bytes < KMALLOC_MAX_SIZE)					\
-		(fifo)->data = kmalloc(_bytes, (gfp));			\
-	if ((!(fifo)->data) && ((gfp) & GFP_KERNEL))			\
-		(fifo)->data = vmalloc(_bytes);				\
+	(fifo)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
 	(fifo)->data;							\
 })
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 5886ad78058f..a5c1b815145e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -70,13 +70,10 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	ring->full_size = ring->size - HEADROOM - MAX_DESC_TXBBS;
 
 	tmp = size * sizeof(struct mlx4_en_tx_info);
-	ring->tx_info = kmalloc_node(tmp, GFP_KERNEL | __GFP_NOWARN, node);
+	ring->tx_info = kvmalloc_node(tmp, GFP_KERNEL, node);
 	if (!ring->tx_info) {
-		ring->tx_info = vmalloc(tmp);
-		if (!ring->tx_info) {
-			err = -ENOMEM;
-			goto err_ring;
-		}
+		err = -ENOMEM;
+		goto err_ring;
 	}
 
 	en_dbg(DRV, priv, "Allocated tx_info ring at addr:%p size:%d\n",
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d614493ad5ac..a4e2af846d28 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -102,10 +102,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 		return -ENXIO;
 	}
 
-	ndd->data = kmalloc(ndd->nsarea.config_size, GFP_KERNEL);
-	if (!ndd->data)
-		ndd->data = vmalloc(ndd->nsarea.config_size);
-
+	ndd->data = kvmalloc(ndd->nsarea.config_size, GFP_KERNEL);
 	if (!ndd->data)
 		return -ENOMEM;
 
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index e8c7f09d01be..9c97d0a24819 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -87,18 +87,6 @@ struct user_evtchn {
 	bool enabled;
 };
 
-static evtchn_port_t *evtchn_alloc_ring(unsigned int size)
-{
-	evtchn_port_t *ring;
-	size_t s = size * sizeof(*ring);
-
-	ring = kmalloc(s, GFP_KERNEL);
-	if (!ring)
-		ring = vmalloc(s);
-
-	return ring;
-}
-
 static void evtchn_free_ring(evtchn_port_t *ring)
 {
 	kvfree(ring);
@@ -334,7 +322,7 @@ static int evtchn_resize_ring(struct per_user_data *u)
 	else
 		new_size = 2 * u->ring_size;
 
-	new_ring = evtchn_alloc_ring(new_size);
+	new_ring = kvmalloc(new_size * sizeof(*new_ring), GFP_KERNEL);
 	if (!new_ring)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 25286a5912fc..bebf4691a430 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5369,13 +5369,10 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		goto out;
 	}
 
-	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL | __GFP_NOWARN);
+	tmp_buf = kvmalloc(left_root->nodesize, GFP_KERNEL);
 	if (!tmp_buf) {
-		tmp_buf = vmalloc(left_root->nodesize);
-		if (!tmp_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	left_path->search_commit_root = 1;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 92b09a51742c..86e681db3cab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3541,12 +3541,9 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	u64 last_dest_end = destoff;
 
 	ret = -ENOMEM;
-	buf = kmalloc(root->nodesize, GFP_KERNEL | __GFP_NOWARN);
-	if (!buf) {
-		buf = vmalloc(root->nodesize);
-		if (!buf)
-			return ret;
-	}
+	buf = kvmalloc(root->nodesize, GFP_KERNEL);
+	if (!buf)
+		return ret;
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 71261b459863..64f09f32b0d5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6243,22 +6243,16 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	sctx->clone_roots_cnt = arg->clone_sources_count;
 
 	sctx->send_max_size = BTRFS_SEND_BUF_SIZE;
-	sctx->send_buf = kmalloc(sctx->send_max_size, GFP_KERNEL | __GFP_NOWARN);
+	sctx->send_buf = kvmalloc(sctx->send_max_size, GFP_KERNEL);
 	if (!sctx->send_buf) {
-		sctx->send_buf = vmalloc(sctx->send_max_size);
-		if (!sctx->send_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	sctx->read_buf = kmalloc(BTRFS_SEND_READ_SIZE, GFP_KERNEL | __GFP_NOWARN);
+	sctx->read_buf = kvmalloc(BTRFS_SEND_READ_SIZE, GFP_KERNEL);
 	if (!sctx->read_buf) {
-		sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
-		if (!sctx->read_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	sctx->pending_dir_moves = RB_ROOT;
@@ -6279,13 +6273,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
 
 	if (arg->clone_sources_count) {
-		clone_sources_tmp = kmalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
+		clone_sources_tmp = kvmalloc(alloc_size, GFP_KERNEL);
 		if (!clone_sources_tmp) {
-			clone_sources_tmp = vmalloc(alloc_size);
-			if (!clone_sources_tmp) {
-				ret = -ENOMEM;
-				goto out;
-			}
+			ret = -ENOMEM;
+			goto out;
 		}
 
 		ret = copy_from_user(clone_sources_tmp, arg->clone_sources,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 921596eec664..74106e5f912a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -74,12 +74,9 @@ dio_get_pages_alloc(const struct iov_iter *it, size_t nbytes,
 	align = (unsigned long)(it->iov->iov_base + it->iov_offset) &
 		(PAGE_SIZE - 1);
 	npages = calc_pages_for(align, nbytes);
-	pages = kmalloc(sizeof(*pages) * npages, GFP_KERNEL);
-	if (!pages) {
-		pages = vmalloc(sizeof(*pages) * npages);
-		if (!pages)
-			return ERR_PTR(-ENOMEM);
-	}
+	pages = kvmalloc(sizeof(*pages) * npages, GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
 
 	for (idx = 0; idx < npages; ) {
 		size_t start;
diff --git a/fs/select.c b/fs/select.c
index 3d4f85defeab..175dd1b9b324 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -586,10 +586,7 @@ int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			goto out_nofds;
 
 		alloc_size = 6 * size;
-		bits = kmalloc(alloc_size, GFP_KERNEL|__GFP_NOWARN);
-		if (!bits && alloc_size > PAGE_SIZE)
-			bits = vmalloc(alloc_size);
-
+		bits = kvmalloc(alloc_size, GFP_KERNEL);
 		if (!bits)
 			goto out_nofds;
 	}
diff --git a/fs/xattr.c b/fs/xattr.c
index 2d13b4e62fae..f3fb03a5b9b7 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -431,12 +431,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-		if (!kvalue) {
-			kvalue = vmalloc(size);
-			if (!kvalue)
-				return -ENOMEM;
-		}
+		kvalue = kvmalloc(size, GFP_KERNEL);
+		if (!kvalue)
+			return -ENOMEM;
 		if (copy_from_user(kvalue, value, size)) {
 			error = -EFAULT;
 			goto out;
@@ -528,12 +525,9 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			size = XATTR_SIZE_MAX;
-		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-		if (!kvalue) {
-			kvalue = vmalloc(size);
-			if (!kvalue)
-				return -ENOMEM;
-		}
+		kvalue = kvmalloc(size, GFP_KERNEL);
+		if (!kvalue)
+			return -ENOMEM;
 	}
 
 	error = vfs_getxattr(d, kname, kvalue, size);
@@ -611,12 +605,9 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
-		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
-		if (!klist) {
-			klist = vmalloc(size);
-			if (!klist)
-				return -ENOMEM;
-		}
+		klist = kvmalloc(size, GFP_KERNEL);
+		if (!klist)
+			return -ENOMEM;
 	}
 
 	error = vfs_listxattr(d, klist, size);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 228892dabba6..710d9783a549 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -960,10 +960,7 @@ EXPORT_SYMBOL(iov_iter_get_pages);
 
 static struct page **get_pages_array(size_t n)
 {
-	struct page **p = kmalloc(n * sizeof(struct page *), GFP_KERNEL);
-	if (!p)
-		p = vmalloc(n * sizeof(struct page *));
-	return p;
+	return kvmalloc(n * sizeof(struct page *), GFP_KERNEL);
 }
 
 static ssize_t pipe_get_pages_alloc(struct iov_iter *i,
diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index db77dcb38afd..72ebec18629c 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -200,10 +200,7 @@ struct frame_vector *frame_vector_create(unsigned int nr_frames)
 	 * Avoid higher order allocations, use vmalloc instead. It should
 	 * be rare anyway.
 	 */
-	if (size <= PAGE_SIZE)
-		vec = kmalloc(size, GFP_KERNEL);
-	else
-		vec = vmalloc(size);
+	vec = kvmalloc(size, GFP_KERNEL);
 	if (!vec)
 		return NULL;
 	vec->nr_allocated = nr_frames;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2ff499680cc6..0a5cc1237afe 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -712,17 +712,8 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
  */
 unsigned int *xt_alloc_entry_offsets(unsigned int size)
 {
-	unsigned int *off;
+	return kvmalloc(size * sizeof(unsigned int), GFP_KERNEL);;
 
-	off = kcalloc(size, sizeof(unsigned int), GFP_KERNEL | __GFP_NOWARN);
-
-	if (off)
-		return off;
-
-	if (size < (SIZE_MAX / sizeof(unsigned int)))
-		off = vmalloc(size * sizeof(unsigned int));
-
-	return off;
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 86309a3156a5..5678eff40f61 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -624,16 +624,6 @@ static void fq_rehash(struct fq_sched_data *q,
 	q->stat_gc_flows += fcnt;
 }
 
-static void *fq_alloc_node(size_t sz, int node)
-{
-	void *ptr;
-
-	ptr = kmalloc_node(sz, GFP_KERNEL | __GFP_REPEAT | __GFP_NOWARN, node);
-	if (!ptr)
-		ptr = vmalloc_node(sz, node);
-	return ptr;
-}
-
 static void fq_free(void *addr)
 {
 	kvfree(addr);
@@ -650,7 +640,7 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 		return 0;
 
 	/* If XPS was setup, we can allocate memory on right NUMA node */
-	array = fq_alloc_node(sizeof(struct rb_root) << log,
+	array = kvmalloc_node(sizeof(struct rb_root) << log, GFP_KERNEL,
 			      netdev_queue_numa_node_read(sch->dev_queue));
 	if (!array)
 		return -ENOMEM;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 9f7b380cf0a3..ded4d4238ea2 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -692,15 +692,11 @@ static int get_dist_table(struct Qdisc *sch, const struct nlattr *attr)
 	spinlock_t *root_lock;
 	struct disttable *d;
 	int i;
-	size_t s;
 
 	if (n > NETEM_DIST_MAX)
 		return -EINVAL;
 
-	s = sizeof(struct disttable) + n * sizeof(s16);
-	d = kmalloc(s, GFP_KERNEL | __GFP_NOWARN);
-	if (!d)
-		d = vmalloc(s);
+	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 7f195ed4d568..5d70cd6a032d 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -684,11 +684,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 
 static void *sfq_alloc(size_t sz)
 {
-	void *ptr = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN);
-
-	if (!ptr)
-		ptr = vmalloc(sz);
-	return ptr;
+	return  kvmalloc(sz, GFP_KERNEL);
 }
 
 static void sfq_free(void *addr)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e215e6d0c47c..186c975dba0c 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -99,14 +99,9 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 
 	if (_payload) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL | __GFP_NOWARN);
-		if (!payload) {
-			if (plen <= PAGE_SIZE)
-				goto error2;
-			payload = vmalloc(plen);
-			if (!payload)
-				goto error2;
-		}
+		payload = kvmalloc(plen, GFP_KERNEL);
+		if (!payload)
+			goto error2;
 
 		ret = -EFAULT;
 		if (copy_from_user(payload, _payload, plen) != 0)
@@ -1064,14 +1059,9 @@ long keyctl_instantiate_key_common(key_serial_t id,
 
 	if (from) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
-		if (!payload) {
-			if (plen <= PAGE_SIZE)
-				goto error;
-			payload = vmalloc(plen);
-			if (!payload)
-				goto error;
-		}
+		payload = kvmalloc(plen, GFP_KERNEL);
+		if (!payload)
+			goto error;
 
 		ret = -EFAULT;
 		if (!copy_from_iter_full(payload, plen, from))
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
