From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 2/2] ext4: Fix up the .write callback to use new_sync_write
Date: Wed, 23 Apr 2014 16:46:46 +0300
Message-ID: <1398260806-19340-3-git-send-email-peter.ujfalusi@ti.com>
References: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Other filesystems has been updated but ext4 has been left out and since
ext4 does not provide aio_write callback we have kernel crash in
do_sync_write()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f48a1c2838b6..708aad768199 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -587,7 +587,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read		= new_sync_read,
-	.write		= do_sync_write,
+	.write		= new_sync_write,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
-- 
1.9.2
