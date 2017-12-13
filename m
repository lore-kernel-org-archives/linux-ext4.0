From: "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] mm: save current->journal_info before calling fault/page_mkwrite
Date: Wed, 13 Dec 2017 11:58:36 +0800
Message-ID: <20171213035836.916-1-zyan@redhat.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        jlayton@redhat.com, "Yan, Zheng" <zyan@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We recently got an Oops report:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: jbd2__journal_start+0x38/0x1a2
[...]
Call Trace:
  ext4_page_mkwrite+0x307/0x52b
  _ext4_get_block+0xd8/0xd8
  do_page_mkwrite+0x6e/0xd8
  handle_mm_fault+0x686/0xf9b
  mntput_no_expire+0x1f/0x21e
  __do_page_fault+0x21d/0x465
  dput+0x4a/0x2f7
  page_fault+0x22/0x30
  copy_user_generic_string+0x2c/0x40
  copy_page_to_iter+0x8c/0x2b8
  generic_file_read_iter+0x26e/0x845
  timerqueue_del+0x31/0x90
  ceph_read_iter+0x697/0xa33 [ceph]
  hrtimer_cancel+0x23/0x41
  futex_wait+0x1c8/0x24d
  get_futex_key+0x32c/0x39a
  __vfs_read+0xe0/0x130
  vfs_read.part.1+0x6c/0x123
  handle_mm_fault+0x831/0xf9b
  __fget+0x7e/0xbf
  SyS_read+0x4d/0xb5

The reason is that page fault can happen when one filesystem copies
data from/to userspace, the filesystem may set current->journal_info.
If the userspace memory is mapped to a file on another filesystem,
the later filesystem may also want to use current->journal_info.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 mm/memory.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5eb3d2524bdc..e51383cd49bf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2347,12 +2347,22 @@ static int do_page_mkwrite(struct vm_fault *vmf)
 {
 	int ret;
 	struct page *page = vmf->page;
+	void *old_journal_info = current->journal_info;
 	unsigned int old_flags = vmf->flags;
 
+	/*
+	 * If the fault happens during read_iter() copies data to
+	 * userspace, filesystem may have set current->journal_info.
+	 * If the userspace memory is mapped to a file on another
+	 * filesystem, page_mkwrite() of the later filesystem may
+	 * want to access/modify current->journal_info.
+	 */
+	current->journal_info = NULL;
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
-	/* Restore original flags so that caller is not surprised */
+	/* Restore original journal_info and flags */
+	current->journal_info = old_journal_info;
 	vmf->flags = old_flags;
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
@@ -3191,9 +3201,20 @@ static int do_anonymous_page(struct vm_fault *vmf)
 static int __do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	void *old_journal_info = current->journal_info;
 	int ret;
 
+	/*
+	 * If the fault happens during write_iter() copies data from
+	 * userspace, filesystem may have set current->journal_info.
+	 * If the userspace memory is mapped to a file on another
+	 * filesystem, fault handler of the later filesystem may want
+	 * to access/modify current->journal_info.
+	 */
+	current->journal_info = NULL;
 	ret = vma->vm_ops->fault(vmf);
+	/* Restore original journal_info */
+	current->journal_info = old_journal_info;
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
 		return ret;
-- 
2.13.6
