From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v2] fs: ext4: Adding new return type vm_fault_t
Date: Thu, 10 May 2018 20:11:36 +0530
Message-ID: <20180510144136.GA26160@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        willy@infradead.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use new return type vm_fault_t for fault handler. For now,
this is just documenting that the function returns a
VM_FAULT value rather than an errno. Once all instances are
converted, vm_fault_t will become a distinct type.

commit 1c8f422059ae ("mm: change return type to vm_fault_t")

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
---
v2: Updated the change log

 fs/ext4/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fb6f023..655d1c7 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -277,10 +277,11 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 }
 
 #ifdef CONFIG_FS_DAX
-static int ext4_dax_huge_fault(struct vm_fault *vmf,
+static vm_fault_t ext4_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
-	int result, error = 0;
+	int error = 0;
+	vm_fault_t result;
 	int retries = 0;
 	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -335,7 +336,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	return result;
 }
 
-static int ext4_dax_fault(struct vm_fault *vmf)
+static vm_fault_t ext4_dax_fault(struct vm_fault *vmf)
 {
 	return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
 }
-- 
1.9.1
