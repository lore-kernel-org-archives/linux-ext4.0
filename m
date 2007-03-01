From: akpm@linux-foundation.org
Subject: - ext-ea-block-reference-count-racing-fix-fix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 19:24:29 -0800
Message-ID: <200703010324.l213OTV3002862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, agruen@suse.de, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext-ea-block-reference-count-racing-fix-fix
has been removed from the -mm tree.  Its filename was
     ext-ea-block-reference-count-racing-fix-fix.patch

This patch was dropped because it was folded into ext-ea-block-reference-count-racing-fix.patch

------------------------------------------------------
Subject: ext-ea-block-reference-count-racing-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix-fix fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix-fix
+++ a/fs/ext4/xattr.c
@@ -721,7 +721,7 @@ ext4_xattr_block_set(handle_t *handle, s
 			int offset = (char *)s->here - bs->bh->b_data;
 
 			unlock_buffer(bs->bh);
-			journal_release_buffer(handle, bs->bh);
+			jbd2_journal_release_buffer(handle, bs->bh);
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix.patch
ext-ea-block-reference-count-racing-fix-fix.patch
