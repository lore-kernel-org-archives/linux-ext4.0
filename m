From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/4] 9pfs: Fix filesystem to wait for stable page writeback
Date: Tue, 20 Nov 2012 18:00:48 -0800
Message-ID: <20121121020048.10225.34434.stgit@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix up the ->page_mkwrite handler to provide stable page writes if necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/9p/vfs_file.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c2483e9..a2d3e2f 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
+	wait_if_stable_page_write(page);
 
 	return VM_FAULT_LOCKED;
 out_unlock:
