From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] ext4: fix balloc.c printk format warning
Date: Mon, 30 Jan 2012 19:09:24 -0800
Message-ID: <4F275B64.8060904@xenotime.net>
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for a sector_t value:

fs/ext4/balloc.c:405:3: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'sector_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	"Theodore Ts'o" <tytso@mit.edu>
Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
Cc:	linux-ext4@vger.kernel.org
---
 fs/ext4/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120130.orig/fs/ext4/balloc.c
+++ linux-next-20120130/fs/ext4/balloc.c
@@ -404,7 +404,7 @@ int ext4_wait_block_bitmap(struct super_
 	if (!buffer_uptodate(bh)) {
 		ext4_error(sb, "Cannot read block bitmap - "
 			   "block_group = %u, block_bitmap = %llu",
-			   block_group, bh->b_blocknr);
+			   block_group, (unsigned long long)bh->b_blocknr);
 		return 1;
 	}
 	/* Panic or remount fs read-only if block bitmap is invalid */
