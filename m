From: sunqiuyang <sunqiuyang@huawei.com>
Subject: [PATCH 1/1] ext4: remove redundant assignment in ext4_iomap_begin()
Date: Mon, 27 Nov 2017 17:21:27 +0800
Message-ID: <20171127092127.26193-1-sunqiuyang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <sunqiuyang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Qiuyang Sun <sunqiuyang@huawei.com>

This line will not change the value of map.m_lblk in any case.

Signed-off-by: Qiuyang Sun <sunqiuyang@huawei.com>
---
 fs/ext4/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f836e2..d4a42b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3443,7 +3443,6 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 				if (es.es_lblk < map.m_lblk)
 					offs = map.m_lblk - es.es_lblk;
-				map.m_lblk = es.es_lblk + offs;
 				map.m_len = es.es_len - offs;
 				delalloc = true;
 			}
-- 
2.5.0
