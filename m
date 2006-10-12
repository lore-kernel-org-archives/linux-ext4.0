From: akpm@osdl.org
Subject: - ext4-whitespace-cleanups.patch removed from -mm tree
Date: Wed, 11 Oct 2006 17:04:40 -0700
Message-ID: <200610120004.k9C04em3008082@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1963 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030535AbWJLAUk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 20:20:40 -0400
To: akpm@osdl.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4 whitespace cleanups

has been removed from the -mm tree.  Its filename is

     ext4-whitespace-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4 whitespace cleanups
From: Andrew Morton <akpm@osdl.org>

Someone's tab key is emitting spaces.  Attempt to repair some of the damage.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/acl.c     |    4 +--
 fs/ext4/dir.c     |    7 +++--
 fs/ext4/extents.c |   14 +++++------
 fs/ext4/namei.c   |   52 +++++++++++++++++++++-----------------------
 fs/ext4/super.c   |   14 ++++++-----
 5 files changed, 46 insertions(+), 45 deletions(-)

diff -puN fs/ext4/acl.c~ext4-whitespace-cleanups fs/ext4/acl.c
--- a/fs/ext4/acl.c~ext4-whitespace-cleanups
+++ a/fs/ext4/acl.c
@@ -141,7 +141,7 @@ ext4_iget_acl(struct inode *inode, struc
 
 static inline void
 ext4_iset_acl(struct inode *inode, struct posix_acl **i_acl,
-                  struct posix_acl *acl)
+		struct posix_acl *acl)
 {
 	spin_lock(&inode->i_lock);
 	if (*i_acl != EXT4_ACL_NOT_CACHED)
@@ -375,7 +375,7 @@ int
 ext4_acl_chmod(struct inode *inode)
 {
 	struct posix_acl *acl, *clone;
-        int error;
+	int error;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
diff -puN fs/ext4/dir.c~ext4-whitespace-cleanups fs/ext4/dir.c
--- a/fs/ext4/dir.c~ext4-whitespace-cleanups
+++ a/fs/ext4/dir.c
@@ -188,8 +188,9 @@ revalidate:
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
 			if (!ext4_check_dir_entry ("ext4_readdir", inode, de,
 						   bh, offset)) {
-				/* On error, skip the f_pos to the
-                                   next block. */
+				/*
+				 * On error, skip the f_pos to the next block
+				 */
 				filp->f_pos = (filp->f_pos |
 						(sb->s_blocksize - 1)) + 1;
 				brelse (bh);
@@ -508,7 +509,7 @@ finished:
 
 static int ext4_release_dir (struct inode * inode, struct file * filp)
 {
-       if (filp->private_data)
+	if (filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
 
 	return 0;
diff -puN fs/ext4/extents.c~ext4-whitespace-cleanups fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-whitespace-cleanups
+++ a/fs/ext4/extents.c
@@ -1014,7 +1014,7 @@ ext4_ext_next_allocated_block(struct ext
  * returns first allocated block from next leaf or EXT_MAX_BLOCK
  */
 static unsigned ext4_ext_next_leaf_block(struct inode *inode,
-                                               struct ext4_ext_path *path)
+					struct ext4_ext_path *path)
 {
 	int depth;
 
@@ -1097,8 +1097,8 @@ static int inline
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-        if (le32_to_cpu(ex1->ee_block) + le16_to_cpu(ex1->ee_len)
-	    != le32_to_cpu(ex2->ee_block))
+	if (le32_to_cpu(ex1->ee_block) + le16_to_cpu(ex1->ee_len) !=
+			le32_to_cpu(ex2->ee_block))
 		return 0;
 
 	/*
@@ -1113,7 +1113,7 @@ ext4_can_extents_be_merged(struct inode 
 		return 0;
 #endif
 
-        if (ext_pblock(ex1) + le16_to_cpu(ex1->ee_len) == ext_pblock(ex2))
+	if (ext_pblock(ex1) + le16_to_cpu(ex1->ee_len) == ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -2008,9 +2008,9 @@ int ext4_ext_get_blocks(handle_t *handle
 		goto out2;
 	}
 	/*
-         * Okay, we need to do block allocation.  Lazily initialize the block
-         * allocation info here if necessary.
-        */
+	 * Okay, we need to do block allocation.  Lazily initialize the block
+	 * allocation info here if necessary.
+	 */
 	if (S_ISREG(inode->i_mode) && (!EXT4_I(inode)->i_block_alloc_info))
 		ext4_init_block_alloc_info(inode);
 
diff -puN fs/ext4/namei.c~ext4-whitespace-cleanups fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-whitespace-cleanups
+++ a/fs/ext4/namei.c
@@ -241,13 +241,13 @@ static inline unsigned dx_node_limit (st
 #ifdef DX_DEBUG
 static void dx_show_index (char * label, struct dx_entry *entries)
 {
-        int i, n = dx_get_count (entries);
+	int i, n = dx_get_count (entries);
         printk("%s index ", label);
-        for (i = 0; i < n; i++)
-        {
-                printk("%x->%u ", i? dx_get_hash(entries + i): 0, dx_get_block(entries + i));
-        }
-        printk("\n");
+	for (i = 0; i < n; i++) {
+		printk("%x->%u ", i? dx_get_hash(entries + i) :
+				0, dx_get_block(entries + i));
+	}
+	printk("\n");
 }
 
 struct stats
@@ -688,28 +688,26 @@ static int dx_make_map (struct ext4_dir_
 
 static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 {
-        struct dx_map_entry *p, *q, *top = map + count - 1;
-        int more;
-        /* Combsort until bubble sort doesn't suck */
-        while (count > 2)
-	{
-                count = count*10/13;
-                if (count - 9 < 2) /* 9, 10 -> 11 */
-                        count = 11;
-                for (p = top, q = p - count; q >= map; p--, q--)
-                        if (p->hash < q->hash)
-                                swap(*p, *q);
-        }
-        /* Garden variety bubble sort */
-        do {
-                more = 0;
-                q = top;
-                while (q-- > map)
-		{
-                        if (q[1].hash >= q[0].hash)
+	struct dx_map_entry *p, *q, *top = map + count - 1;
+	int more;
+	/* Combsort until bubble sort doesn't suck */
+	while (count > 2) {
+		count = count*10/13;
+		if (count - 9 < 2) /* 9, 10 -> 11 */
+			count = 11;
+		for (p = top, q = p - count; q >= map; p--, q--)
+			if (p->hash < q->hash)
+				swap(*p, *q);
+	}
+	/* Garden variety bubble sort */
+	do {
+		more = 0;
+		q = top;
+		while (q-- > map) {
+			if (q[1].hash >= q[0].hash)
 				continue;
-                        swap(*(q+1), *q);
-                        more = 1;
+			swap(*(q+1), *q);
+			more = 1;
 		}
 	} while(more);
 }
diff -puN fs/ext4/super.c~ext4-whitespace-cleanups fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-whitespace-cleanups
+++ a/fs/ext4/super.c
@@ -1191,9 +1191,10 @@ static int ext4_setup_super(struct super
 			"running e2fsck is recommended\n");
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
-                   inconsistencies, to force a fsck at reboot.  But for
-                   a plain journaled filesystem we can keep it set as
-                   valid forever! :) */
+		 * inconsistencies, to force a fsck at reboot.  But for
+		 * a plain journaled filesystem we can keep it set as
+		 * valid forever! :)
+		 */
 	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT4_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
@@ -1791,8 +1792,9 @@ static int ext4_fill_super (struct super
 	switch (test_opt(sb, DATA_FLAGS)) {
 	case 0:
 		/* No mode set, assume a default based on the journal
-                   capabilities: ORDERED_DATA if the journal can
-                   cope, else JOURNAL_DATA */
+		 * capabilities: ORDERED_DATA if the journal can
+		 * cope, else JOURNAL_DATA
+		 */
 		if (jbd2_journal_check_available_features
 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE))
 			set_opt(sbi->s_mount_opt, ORDERED_DATA);
@@ -2802,7 +2804,7 @@ static int __init init_ext4_fs(void)
 	err = init_inodecache();
 	if (err)
 		goto out1;
-        err = register_filesystem(&ext4dev_fs_type);
+	err = register_filesystem(&ext4dev_fs_type);
 	if (err)
 		goto out;
 	return 0;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
git-acpi.patch
i386-acpi-build-fix.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
git-cifs-fixup.patch
cifs-kconfig-dont-select-connector.patch
git-dvb-build-fix.patch
w1-kconfig-fix.patch
git-geode-fixup.patch
git-gfs2.patch
git-infiniband.patch
git-input-fixup.patch
git-libata-all.patch
mtd-maps-support-for-bios-flash-chips-on-intel-esb2-southbridge.patch
git-netdev-all.patch
libphy-dont-do-that.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-pcmcia-fixup.patch
git-serial-fixup.patch
git-scsi-target-fixup.patch
git-scsi-target-vs-git-block.patch
fix-gregkh-usb-usbatm-fix-tiny-race.patch
xpad-dance-pad-support.patch
git-watchdog.patch
x86_64-dump_trace-atomicity-fix.patch
spinlock-debug-all-cpu-backtrace.patch
spinlock-debug-all-cpu-backtrace-fix.patch
spinlock-debug-all-cpu-backtrace-fix-2.patch
spinlock-debug-all-cpu-backtrace-fix-3.patch
xfs-rename-uio_read.patch
touchkit-ps-2-touchscreen-driver-regs-fix.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
add-address_space_operationsbatch_write.patch
add-config_headers_check-option-to-automatically-run-make-headers_check-nobble.patch
kbuild-dont-put-temp-files-in-the-source-tree.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
bug-test-1.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
fs-cache-provide-a-filesystem-specific-syncable-page-bit-ext4.patch
fs-cache-make-kafs-use-fs-cache-fix.patch
fs-cache-make-kafs-use-fs-cache-vs-streamline-generic_file_-interfaces-and-filemap.patch
nfs-use-local-caching-12-fix.patch
fs-cache-cachefiles-a-cache-that-backs-onto-a-mounted-filesystem-log2-fix.patch
swap_prefetch-vs-zoned-counters.patch
readahead-sysctl-parameters.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-rename-generic_sounding_globalspatch-fix.patch
hpt3xx-rework-rate-filtering-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-state-tracking.patch
clockevents-drivers-for-i386.patch
gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
kevent-core-files-fix.patch
kevent-core-files-s390-hack.patch
kevent-socket-notifications-fix-2.patch
kevent-socket-notifications-fix-4.patch
kevent-timer-notifications-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
jmicron-warning-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

