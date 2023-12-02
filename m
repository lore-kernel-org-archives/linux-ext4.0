Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7D613D;
	Sat,  2 Dec 2023 01:10:48 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Sj3tm01XNzMnZj;
	Sat,  2 Dec 2023 17:05:52 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sat, 2 Dec
 2023 17:10:45 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <linux-mm@kvack.org>, <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <ritesh.list@gmail.com>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <yukuai3@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH -RFC 2/2] ext4: avoid data corruption when extending DIO write race with buffered read
Date: Sat, 2 Dec 2023 17:14:32 +0800
Message-ID: <20231202091432.8349-3-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231202091432.8349-1-libaokun1@huawei.com>
References: <20231202091432.8349-1-libaokun1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected

The following race between extending DIO write and buffered read may
result in reading a stale page cache:

          cpu1                             cpu2
------------------------------|-----------------------------
// Direct write 1024 from 4096
                              // Buffer read 8192 from 0
...                           ...
 ext4_file_write_iter
  ext4_dio_write_iter
   iomap_dio_rw
   ...
                               ext4_file_read_iter
                                generic_file_read_iter
                                 filemap_read
                                  i_size_read(inode) // 4096
                                  filemap_get_pages
                                   ...
                                    ext4_mpage_readpages
                                     ext4_readpage_limit(inode)
                                      i_size_read(inode) // 4096
                                     // read 4096, zero-filled 4096
    ext4_dio_write_end_io
     i_size_write(inode, 5120)
                                   i_size_read(inode) // 5120
                                   copyout 4096

                              // new read 4096 from 4096
                              ext4_file_read_iter
                               generic_file_read_iter
                                filemap_read
                                 i_size_read(inode) // 5120
                                 filemap_get_pages
                                  // stale page is uptodata
                                 i_size_read(inode) // 5120
                                 copyout 5120
    dio invalidate stale page cache

In the above race, after DIO write updates the inode size, but before
invalidate stale page cache, buffered read sees that the last read page
chche is still uptodata, and does not re-read it from the disk to copy
it directly to the user space, which results in the data in the tail of
1024 bytes is not the same as the data on the disk.

To get around this, we wait for the existing DIO write to invalidate the
stale page cache before each new buffered read.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0166bb9ca160..99e92ddef97d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -144,6 +144,9 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (iocb->ki_flags & IOCB_DIRECT)
 		return ext4_dio_read_iter(iocb, to);
 
+	/* wait for stale page cache to be invalidated */
+	inode_dio_wait(inode);
+
 	return generic_file_read_iter(iocb, to);
 }
 
-- 
2.31.1

