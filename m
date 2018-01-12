From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 5/8] ext4: decrypt the block that needs to be partially zeroed
Date: Fri, 12 Jan 2018 19:41:26 +0530
Message-ID: <20180112141129.27507-6-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

__ext4_block_zero_page_range decrypts the entire page. This commit
decrypts the block to be partially zeroed instead of the whole page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d3baa15..db47f6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4030,9 +4030,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		    ext4_encrypted_inode(inode)) {
 			/* We expect the key to be set. */
 			BUG_ON(!fscrypt_has_encryption_key(inode));
-			BUG_ON(blocksize != PAGE_SIZE);
 			WARN_ON_ONCE(fscrypt_decrypt_page(page->mapping->host,
-						page, PAGE_SIZE, 0, page->index));
+						page, blocksize, round_down(offset, blocksize), iblock));
 		}
 	}
 	if (ext4_should_journal_data(inode)) {
-- 
2.9.5
