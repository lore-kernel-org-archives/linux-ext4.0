From: Andiry Xu <andiry@gmail.com>
Subject: [BUG][ext2] XIP does not work on ext2
Date: Mon, 4 Nov 2013 14:31:34 -0800
Message-ID: <CAOvWMLZ-ezykR6TkFAoZ1UW20QF6XMOKeZH8R-FdFJkXjAP9nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andiry Xu <andiry.xu@gmail.com>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

When I'm trying XIP on ext2, I find that xip does not work on ext2
with latest kernel.

Reproduce steps:
Compile kernel with following configs:
CONFIG_BLK_DEV_XIP=y
CONFIG_EXT2_FS_XIP=y

And run following commands:
# mke2fs -b 4096 /dev/ram0
# mount -t ext2 -o xip /dev/ram0 /mnt/ramdisk/
# dd if=/dev/zero of=/mnt/ramdisk/test1 bs=1M count=16

And it shows:
dd: writing `/mnt/ramdisk/test1': No space left on device

df also shows /mnt/ramdisk is 100% full. Its default size is 64MB so a
16MB write should only occupy 1/4 capacity.

Criminal commit:
After git bisect, it points to the following commit:
8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b
Ext2: mark inode dirty after the function dquot_free_block_nodirty is called

Particularly, the following code:
@@ -1412,9 +1415,11 @@ allocated:
*errp = 0;
brelse(bitmap_bh);
-    dquot_free_block_nodirty(inode, *count-num);
-    mark_inode_dirty(inode);
-    *count = num;
+    if (num < *count) {
+        dquot_free_block_nodirty(inode, *count-num);
+        mark_inode_dirty(inode);
+        *count = num;
+    }
      return ret_block;

Not mark_inode_dirty() is called only when num is less than *count.
However, I've seen
with the dd command, there is case where num >= *count.

Fix:
I've verified that the following patch fixes the issue:
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9f9992b..5446a52 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1406,11 +1406,10 @@ allocated:

        *errp = 0;
        brelse(bitmap_bh);
-       if (num < *count) {
+       if (num <= *count)
                dquot_free_block_nodirty(inode, *count-num);
-               mark_inode_dirty(inode);
-               *count = num;
-       }
+       mark_inode_dirty(inode);
+       *count = num;
        return ret_block;

 io_error:

However, I'm not familiar with ext2 source code and cannot tell if
this is the correct fix. At least it fixes my issue.

Thanks,
Andiry
