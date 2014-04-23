From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 0/2] fs/ext4: fix for aio_write related kernel crash in linux-next
Date: Wed, 23 Apr 2014 16:46:44 +0300
Message-ID: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This might be already fixed.
I have noticed that with linux-next the kernel crashes when trying to use ext4
as rootfs.

Regards,
Peter
---
Peter Ujfalusi (2):
  fs: read_write: Check ->aio_write in __kernel_write() and vfs_write()
  ext4: Fix up the .write callback to use new_sync_write

 fs/ext4/file.c  | 2 +-
 fs/read_write.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.9.2
