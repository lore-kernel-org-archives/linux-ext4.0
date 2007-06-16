From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: [PATCH] deny partial write for loop dev fd
Date: Sat, 16 Jun 2007 19:39:17 +0400
Message-ID: <20070616153917.GC14349@localhost.sw.ru>
References: <20070613134631.GB13815@localhost.sw.ru> <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com> <20070613172939.GE13815@localhost.sw.ru> <Pine.LNX.4.64.0706131543380.10580@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:40842 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbXFPPjE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2007 11:39:04 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706131543380.10580@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Partial write can be easily supported by LO_CRYPT_NONE mode, but
it is not easy in LO_CRYPT_CRYPTOAPI case, because of its block nature.
I don't know who still used cryptoapi, but theoretically it is possible.
So let's leave things as they are. Loop device doesn't support partial
write before Nick's "write_begin/write_end" patch set, and let's it 
behave the same way after.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
---
 drivers/block/loop.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4bab9b1..de122f3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -244,10 +244,8 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 
 		ret = pagecache_write_end(file, mapping, pos, size, copied,
 							page, fsdata);
-		if (ret < 0)
+		if (ret < 0 || ret != copied)
 			goto fail;
-		if (ret < copied)
-			copied = ret;
 
 		if (unlikely(transfer_result))
 			goto fail;
-- 
1.5.2
