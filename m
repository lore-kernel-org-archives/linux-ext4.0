From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Thu, 13 Dec 2012 00:08:11 -0800
Message-ID: <20121213080811.23360.98131.stgit@blackbox.djwong.org>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz,
	"Darrick J. Wong" <darrick.wong@oracle.com>, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Several complaints have been received regarding long file write latencies when
memory pages must be held stable during writeback.  Since it might not be
acceptable to stall programs for the entire duration of a page write (which may
take many milliseconds even on good hardware), enable a second strategy wherein
pages are snapshotted as part of submit_bio; the snapshot can be held stable
while writes continue.

This provides a band-aid to provide stable page writes on jbd without needing
to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
to allow administrators to enable it there.

For those wondering about the ext3 bandage -- fixing the jbd locking (which was
done as part of ext4dev years ago) is a lot of surgery, and setting
PG_writeback on data pages when we actually hold the page lock dropped ext3
performance by nearly an order of magnitude.  If we're going to migrate iscsi
and raid to use stable page writes, the complaints about high latency will
likely return.  We might as well centralize their page snapshotting thing to
one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 arch/tile/Kconfig       |    6 ------
 block/blk-core.c        |    8 +++++---
 fs/ext3/super.c         |    1 +
 fs/ext4/super.c         |    7 ++++++-
 include/uapi/linux/fs.h |    1 +
 mm/Kconfig              |   10 ++++++++++
 mm/bounce.c             |   38 ++++++++++++++++++++++++++++++++++++--
 mm/page-writeback.c     |    4 ++++
 8 files changed, 63 insertions(+), 12 deletions(-)


diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 875d008..c671fda 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -410,12 +410,6 @@ config TILE_USB
 	  Provides USB host adapter support for the built-in EHCI and OHCI
 	  interfaces on TILE-Gx chips.
 
-# USB OHCI needs the bounce pool since tilegx will often have more
-# than 4GB of memory, but we don't currently use the IOTLB to present
-# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
-config NEED_BOUNCE_POOL
-	def_bool USB_OHCI_HCD
-
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu
diff --git a/block/blk-core.c b/block/blk-core.c
index 3c95c4d..85e7705 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1433,6 +1433,11 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
 
+	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
@@ -1673,9 +1678,6 @@ generic_make_request_checks(struct bio *bio)
 	 */
 	blk_partition_remap(bio);
 
-	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
-		goto end_io;
-
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5366393..d251793 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2068,6 +2068,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
+	sb->s_flags |= MS_SNAP_STABLE;
 
 	return 0;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..64d7bc8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1222,7 +1222,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_snap_stable,
 };
 
 static const match_table_t tokens = {
@@ -1297,6 +1297,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
+	{Opt_snap_stable, "snapshot_stable"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1478,6 +1479,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
+	{Opt_snap_stable, 0, 0},
 	{Opt_err, 0, 0}
 };
 
@@ -1549,6 +1551,9 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			return -1;
 		*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
 		return 1;
+	case Opt_snap_stable:
+		sb->s_flags |= MS_SNAP_STABLE;
+		return 1;
 	}
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 780d4c6..0144fbb 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -69,6 +69,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..78db0e1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -224,6 +224,16 @@ config BOUNCE
 	def_bool y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
 
+# On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
+# have more than 4GB of memory, but we don't currently use the IOTLB to present
+# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
+#
+# We also use the bounce pool to provide stable page writes for users that
+# don't (or can't) afford the wait latency.
+config NEED_BOUNCE_POOL
+	bool
+	default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && (EXT3_FS || EXT4_FS))
+
 config NR_QUICK
 	int
 	depends on QUICKLIST
diff --git a/mm/bounce.c b/mm/bounce.c
index 0420867..fa11935 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -178,6 +178,38 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
 	__bounce_end_io_read(bio, isa_page_pool, err);
 }
 
+#ifdef CONFIG_NEED_BOUNCE_POOL
+static int might_snapshot_stable_page_write(struct bio **bio_orig)
+{
+	return bio_data_dir(*bio_orig) == WRITE;
+}
+
+static int should_snapshot_stable_pages(struct page *page, int rw)
+{
+	struct backing_dev_info *bdi;
+	struct address_space *mapping = page_mapping(page);
+
+	if (!mapping)
+		return 0;
+	bdi = mapping->backing_dev_info;
+	if (!bdi_cap_stable_pages_required(bdi))
+		return 0;
+
+	return mapping->host->i_sb->s_flags & MS_SNAP_STABLE &&
+	       rw == WRITE;
+}
+#else
+static int might_snapshot_stable_page_write(struct bio **bio_orig)
+{
+	return 0;
+}
+
+static int should_snapshot_static_pages(struct page *page, int rw)
+{
+	return 0;
+}
+#endif /* CONFIG_NEED_BOUNCE_POOL */
+
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool)
 {
@@ -192,7 +224,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		/*
 		 * is destination page below bounce pfn?
 		 */
-		if (page_to_pfn(page) <= queue_bounce_pfn(q))
+		if (page_to_pfn(page) <= queue_bounce_pfn(q) &&
+		    !should_snapshot_stable_pages(page, rw))
 			continue;
 
 		/*
@@ -284,7 +317,8 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	 * don't waste time iterating over bio segments
 	 */
 	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (queue_bounce_pfn(q) >= blk_max_pfn)
+		if (queue_bounce_pfn(q) >= blk_max_pfn &&
+		    !might_snapshot_stable_page_write(bio_orig))
 			return;
 		pool = page_pool;
 	} else {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3e4a8cc..fbd8efb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2291,6 +2291,10 @@ void wait_for_stable_page(struct page *page)
 
 	if (!bdi_cap_stable_pages_required(bdi))
 		return;
+#ifdef CONFIG_NEED_BOUNCE_POOL
+	if (mapping->host->i_sb->s_flags & MS_SNAP_STABLE)
+		return;
+#endif /* CONFIG_NEED_BOUNCE_POOL */
 
 	wait_on_page_writeback(page);
 }

