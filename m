From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] make ext2_get_blocks() static
Date: Mon, 20 Nov 2006 03:24:13 +0100
Message-ID: <20061120022413.GN31879@stusta.de>
References: <20061114014125.dd315fff.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51729 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S933877AbWKTCZJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Nov 2006 21:25:09 -0500
To: Andrew Morton <akpm@osdl.org>,
	"Martin J. Bligh" <mbligh@mbligh.org>
Content-Disposition: inline
In-Reply-To: <20061114014125.dd315fff.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 14, 2006 at 01:41:25AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.19-rc5-mm2:
>...
> +ext2-reservations.patch
>...
>  Port the ext3 reservations code into ext2.
>...

This patch makes the needlessly global ext2_get_blocks() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.19-rc5-mm2/fs/ext2/inode.c.old	2006-11-20 01:35:58.000000000 +0100
+++ linux-2.6.19-rc5-mm2/fs/ext2/inode.c	2006-11-20 01:36:08.000000000 +0100
@@ -574,10 +574,10 @@
  * return = 0, if plain lookup failed.
  * return < 0, error case.
  */
-int ext2_get_blocks(struct inode *inode,
-		sector_t iblock, unsigned long maxblocks,
-		struct buffer_head *bh_result,
-		int create)
+static int ext2_get_blocks(struct inode *inode,
+			   sector_t iblock, unsigned long maxblocks,
+			   struct buffer_head *bh_result,
+			   int create)
 {
 	int err = -EIO;
 	int offsets[4];
