From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/4] 9pfs: Fix filesystem to wait for stable page writeback
Date: Thu, 13 Dec 2012 00:08:02 -0800
Message-ID: <20121213080802.23360.4487.stgit@blackbox.djwong.org>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48300 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2LMIJd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2012 03:09:33 -0500
In-Reply-To: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

