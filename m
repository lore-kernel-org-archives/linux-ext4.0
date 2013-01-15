From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/6] 9pfs: Fix filesystem to wait for stable page writeback
Date: Mon, 14 Jan 2013 21:42:58 -0800
Message-ID: <20130115054258.1563.77616.stgit@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz,
	darrick.wong@oracle.com, ericvh@gmail.com, tytso@mit.edu,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix up the ->page_mkwrite handler to provide stable page writes if necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/9p/vfs_file.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c2483e9..357260b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
+	wait_for_stable_page(page);
 
 	return VM_FAULT_LOCKED;
 out_unlock:
