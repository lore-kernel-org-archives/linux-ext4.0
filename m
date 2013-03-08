From: Shuge <shugelinux@gmail.com>
Subject: [PATCH] bounce:fix bug, avoid to flush dcache on slab page from jbd2.
Date: Fri, 08 Mar 2013 20:37:36 +0800
Message-ID: <5139DB90.5090302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kevin <kevin@allwinneretch.com>, Jan Kara <jack@suse.cz>,
 Theodore Ts'o <tytso@mit.edu>,
 Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

The bounce accept slab pages from jbd2, and flush dcache on them.
When enabling VM_DEBUG, it will tigger VM_BUG_ON in page_mapping().
So, check PageSlab to avoid it in __blk_queue_bounce().

Bug URL: http://lkml.org/lkml/2013/3/7/56

Signed-off-by: shuge <shuge@allwinnertech.com>
---
  mm/bounce.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 4e9ae72..f352c03 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -214,7 +214,8 @@ static void __blk_queue_bounce(struct request_queue 
*q, struct bio **bio_orig,
  		if (rw == WRITE) {
  			char *vto, *vfrom;
  -			flush_dcache_page(from->bv_page);
+			if (unlikely(!PageSlab(from->bv_page)))
+				flush_dcache_page(from->bv_page);
  			vto = page_address(to->bv_page) + to->bv_offset;
  			vfrom = kmap(from->bv_page) + from->bv_offset;
  			memcpy(vto, vfrom, to->bv_len);
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
