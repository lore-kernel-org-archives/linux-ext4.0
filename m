From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 48/48] ext2: enable cgroup writeback support
Date: Mon, 23 Mar 2015 00:54:59 -0400
Message-ID: <1427086499-15657-49-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com,
	fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org
To: axboe@kernel.dk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Writeback now supports cgroup writeback and the generic writeback,
buffer, libfs, and mpage helpers that ext2 uses are all updated to
work with cgroup writeback.

This patch enables cgroup writeback for ext2 by adding
FS_CGROUP_WRITEBACK to its ->fs_flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d0e746e..549219d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1543,7 +1543,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
 };
 MODULE_ALIAS_FS("ext2");
 
-- 
2.1.0
