From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/39] libext2fs: don't memcpy identical pointers when
 writing a cache block
Date: Sat, 25 Oct 2014 13:56:55 -0700
Message-ID: <20141025205655.532.5784.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43721 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJYU51 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:27 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sami Liedes found a scenario where we could memcpy incorrectly:

If a block read fails during an e2fsck run, the UNIX IO manager will
call the io->read_error routine with a pointer to the internal block
cache.  The e2fsck read error handler immediately tries to write the
buffer back out to disk(!), at which point the block write code will
try to copy the buffer contents back into the block cache.  Normally
this is fine, but not when the write buffer is the cache itself!

So, plumb in a trivial check for this condition.  A more thorough
solution would pass a duplicated buffer to the IO error handlers, but
I don't know if that happens frequently enough to be worth the extra
point of failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/unix_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 189adce..c3a8ea5 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -823,7 +823,8 @@ static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 			cache = reuse;
 			reuse_cache(channel, data, cache, block);
 		}
-		memcpy(cache->buf, cp, channel->block_size);
+		if (cache->buf != cp)
+			memcpy(cache->buf, cp, channel->block_size);
 		cache->dirty = !writethrough;
 		count--;
 		block++;

