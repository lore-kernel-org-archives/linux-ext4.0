From: akpm@linux-foundation.org
Subject: - make-ext4_xattr_list-static.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:35 -0800
Message-ID: <200803062223.m26MNZBv020901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: bunk@kernel.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     make ext4_xattr_list() static
has been removed from the -mm tree.  Its filename was
     make-ext4_xattr_list-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make ext4_xattr_list() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global ext4_xattr_list() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/xattr.c |    4 +++-
 fs/ext4/xattr.h |    7 -------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/ext4/xattr.c~make-ext4_xattr_list-static fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~make-ext4_xattr_list-static
+++ a/fs/ext4/xattr.c
@@ -92,6 +92,8 @@ static struct buffer_head *ext4_xattr_ca
 						 struct mb_cache_entry **);
 static void ext4_xattr_rehash(struct ext4_xattr_header *,
 			      struct ext4_xattr_entry *);
+static int ext4_xattr_list(struct inode *inode, char *buffer,
+			   size_t buffer_size);
 
 static struct mb_cache *ext4_xattr_cache;
 
@@ -420,7 +422,7 @@ cleanup:
  * Returns a negative error number on failure, or the number of bytes
  * used / required on success.
  */
-int
+static int
 ext4_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	int i_error, b_error;
diff -puN fs/ext4/xattr.h~make-ext4_xattr_list-static fs/ext4/xattr.h
--- a/fs/ext4/xattr.h~make-ext4_xattr_list-static
+++ a/fs/ext4/xattr.h
@@ -74,7 +74,6 @@ extern struct xattr_handler ext4_xattr_s
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ext4_xattr_list(struct inode *, char *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
 
@@ -99,12 +98,6 @@ ext4_xattr_get(struct inode *inode, int 
 }
 
 static inline int
-ext4_xattr_list(struct inode *inode, void *buffer, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int
 ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	       const void *value, size_t size, int flags)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
git-parisc.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
git-watchdog.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
git-cryptodev.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

