From: akpm@linux-foundation.org
Subject: - revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:50 -0700
Message-ID: <200704022303.l32N3oLx011937@shell0.pdx.osdl.net>
To: akpm@linux-foundation.org, dev@openvz.org, dmonakhov@openvz.org,
	kenneth.w.chen@intel.com, linux-ext4@vger.kernel.org,
	mingo@elte.hu, saw@sw.ru, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966082AbXDBXFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2007 19:05:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     revert "retries in ext4_prepare_write() violate ordering requirements"
has been removed from the -mm tree.  Its filename was
     revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "retries in ext4_prepare_write() violate ordering requirements"
From: Andrew Morton <akpm@linux-foundation.org>

Revert b46be05004abb419e303e66e143eed9f8a6e9f3f.  Same reasoning as for ext3.

Cc: Kirill Korotaev <dev@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Andrey Savochkin <saw@sw.ru>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   85 +++++-----------------------------------------
 1 file changed, 10 insertions(+), 75 deletions(-)

diff -puN fs/ext4/inode.c~revert-retries-in-ext4_prepare_write-violate-ordering-requirements fs/ext4/inode.c
--- a/fs/ext4/inode.c~revert-retries-in-ext4_prepare_write-violate-ordering-requirements
+++ a/fs/ext4/inode.c
@@ -1147,102 +1147,37 @@ static int do_journal_get_write_access(h
 	return ext4_journal_get_write_access(handle, bh);
 }
 
-/*
- * The idea of this helper function is following:
- * if prepare_write has allocated some blocks, but not all of them, the
- * transaction must include the content of the newly allocated blocks.
- * This content is expected to be set to zeroes by block_prepare_write().
- * 2006/10/14  SAW
- */
-static int ext4_prepare_failure(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	struct address_space *mapping;
-	struct buffer_head *bh, *head, *next;
-	unsigned block_start, block_end;
-	unsigned blocksize;
-	int ret;
-	handle_t *handle = ext4_journal_current_handle();
-
-	mapping = page->mapping;
-	if (ext4_should_writeback_data(mapping->host)) {
-		/* optimization: no constraints about data */
-skip:
-		return ext4_journal_stop(handle);
-	}
-
-	head = page_buffers(page);
-	blocksize = head->b_size;
-	for (	bh = head, block_start = 0;
-		bh != head || !block_start;
-	    	block_start = block_end, bh = next)
-	{
-		next = bh->b_this_page;
-		block_end = block_start + blocksize;
-		if (block_end <= from)
-			continue;
-		if (block_start >= to) {
-			block_start = to;
-			break;
-		}
-		if (!buffer_mapped(bh))
-		/* prepare_write failed on this bh */
-			break;
-		if (ext4_should_journal_data(mapping->host)) {
-			ret = do_journal_get_write_access(handle, bh);
-			if (ret) {
-				ext4_journal_stop(handle);
-				return ret;
-			}
-		}
-	/*
-	 * block_start here becomes the first block where the current iteration
-	 * of prepare_write failed.
-	 */
-	}
-	if (block_start <= from)
-		goto skip;
-
-	/* commit allocated and zeroed buffers */
-	return mapping->a_ops->commit_write(file, page, from, block_start);
-}
-
 static int ext4_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	int ret, ret2;
-	int needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
 
 retry:
 	handle = ext4_journal_start(inode, needed_blocks);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_prepare_write(page, from, to, ext4_get_block);
 	else
 		ret = block_prepare_write(page, from, to, ext4_get_block);
 	if (ret)
-		goto failure;
+		goto prepare_write_failed;
 
 	if (ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
-		if (ret)
-			/* fatal error, just put the handle and return */
-			ext4_journal_stop(handle);
 	}
-	return ret;
-
-failure:
-	ret2 = ext4_prepare_failure(file, page, from, to);
-	if (ret2 < 0)
-		return ret2;
+prepare_write_failed:
+	if (ret)
+		ext4_journal_stop(handle);
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-	/* retry number exceeded, or other error like -EDQUOT */
+out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-parisc.patch
rm9000-serial-driver.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
utrace-x86_64-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
