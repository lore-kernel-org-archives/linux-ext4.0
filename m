From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] ext4: fix racy use-after-free in ext4_end_io_dio()
Date: Thu, 24 Nov 2011 11:46:26 -0800
Message-ID: <20111124194626.GA5260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kent Overstreet <koverstreet@google.com>, rickyb@google.com,
	aberkan@google.com
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_end_io_dio() queues io_end->work and then clears iocb->private;
however, io_end->work completes the iocb by calling aio_complete(),
which may happen before io_end->work clearing thus leading to
use-after-free.

Detected and tested with slab poisoning.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kent Overstreet <koverstreet@google.com>
Tested-by: Kent Overstreet <koverstreet@google.com>
Cc: stable@kernel.org
---
I *think* this is the corret fix but am not too familiar with code
path, so please proceed with caution.

Thank you.

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 240f6e2..0f5583b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2806,8 +2806,8 @@ out:
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	/* queue the work to convert unwritten extents to written */
-	queue_work(wq, &io_end->work);
 	iocb->private = NULL;
+	queue_work(wq, &io_end->work);
 
 	/* XXX: probably should move into the real I/O completion handler */
 	inode_dio_done(inode);
