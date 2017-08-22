From: Randy Dodgen <dodgen@google.com>
Subject: [PATCH] Fix ext4 fault handling when mounted with -o dax,ro
Date: Tue, 22 Aug 2017 15:24:34 -0700
Message-ID: <20170822222434.146233-1-dodgen@google.com>
Cc: Randy Dodgen <dodgen@google.com>
To: tytso@google.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35042 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbdHVWY5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Aug 2017 18:24:57 -0400
Received: by mail-pf0-f175.google.com with SMTP id x137so230623pfd.2
        for <linux-ext4@vger.kernel.org>; Tue, 22 Aug 2017 15:24:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an ext4 filesystem is mounted with both the DAX and read-only
options, executables on that filesystem will fail to start (claiming
'Segmentation fault') due to the fault handler returning
VM_FAULT_SIGBUS.

This is due to the DAX fault handler (see ext4_dax_huge_fault)
attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
the wrong behavior for write faults which will lead to a COW page; in
particular, this fails for readonly mounts.

This changes replicates some check from dax_iomap_fault to more
precisely reason about when a journal-write is needed.

It might be the case that this could be better handled in
ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
dax_iomap_fault). These is some overlap already (e.g. grabbing journal
handles).
---
 fs/ext4/file.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d7cf0cc9b87..d512fb85a3e3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -279,7 +279,31 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
-	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	bool write;
+
+	/*
+	 * We have to distinguish real writes from writes which will result in a
+	 * COW page
+	 * - COW writes need to fall-back to installing PTEs. See
+	 *   dax_iomap_pmd_fault.
+	 * - COW writes should *not* poke the journal (the file will not be
+	 *   changed). Doing so would cause unintended failures when mounted
+	 *   read-only.
+	 */
+	if (pe_size == PE_SIZE_PTE) {
+		/* See dax_iomap_pte_fault. */
+		write = (vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page;
+	} else if (pe_size == PE_SIZE_PMD) {
+		/* See dax_iomap_pmd_fault. */
+		write = vmf->flags & FAULT_FLAG_WRITE;
+		if (write && !(vmf->vma->vm_flags & VM_SHARED)) {
+			split_huge_pmd(vmf->vma, vmf->pmd, vmf->address);
+			count_vm_event(THP_FAULT_FALLBACK);
+			return VM_FAULT_FALLBACK;
+		}
+	} else {
+		return VM_FAULT_FALLBACK;
+	}
 
 	if (write) {
 		sb_start_pagefault(sb);
-- 
2.14.1.480.gb18f417b89-goog
