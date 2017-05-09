From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 01/27] fs: remove unneeded forward definition of mm_struct from fs.h
Date: Tue,  9 May 2017 11:49:04 -0400
Message-ID: <20170509154930.29524-2-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Cc: dhowells@redhat.com,
	akpm@linux-foundation.org,
	hch@infradead.org,
	ross.zwisler@linux.intel.com,
	mawilcox@microsoft.com,
	jack@suse.com,
	viro@zeniv.linux.org.uk,
	corbet@lwn.net,
	neilb@suse.de,
	clm@fb.com,
	tytso@mit.edu,
	axboe@kernel.dk,
	josef@toxicpanda.com,
	hubcap@omnibond.com,
	rpeterso@redhat.com,
	bo.li.liu@oracle.com
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-mm@kvack.org,
	jfs-discussion@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	cluster-devel@redhat.com,
	linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org,
	linux-block@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7bb45e8..38adefd8e2a0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1252,8 +1252,6 @@ extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
 
-struct mm_struct;
-
 /*
  *	Umount options
  */
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
