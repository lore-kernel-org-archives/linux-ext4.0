From: Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 3/3] ext4: mballoc: Fix spectre gadget in ext4_mb_simple_scan_group
Date: Fri, 27 Jul 2018 16:23:57 +0000
Message-ID: <20180727162357.30801-4-jcline@redhat.com>
References: <20180727162357.30801-1-jcline@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727162357.30801-1-jcline@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

'ac->ac_2order' is a user-controlled value used to index into
'grp->bb_counters' and based on the value at that index, 'ac->ac_found'
is written to. Clamp the value right after the bounds check to avoid a
speculative out-of-bounds read of 'grp->bb_counters'.

This also protects the access of the s_mb_offsets and s_mb_maxs arrays
inside mb_find_buddy().

These gadgets were discovered with the help of smatch:

* fs/ext4/mballoc.c:1896 ext4_mb_simple_scan_group() warn: potential
  spectre issue 'grp->bb_counters' [w] (local cap)

* fs/ext4/mballoc.c:445 mb_find_buddy() warn: potential spectre issue
  'EXT4_SB(e4b->bd_sb)->s_mb_offsets' [r] (local cap)

* fs/ext4/mballoc.c:446 mb_find_buddy() warn: potential spectre issue
  'EXT4_SB(e4b->bd_sb)->s_mb_maxs' [r] (local cap)

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f7ab34088162..c0866007a949 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -14,6 +14,7 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 #include <linux/backing-dev.h>
 #include <trace/events/ext4.h>
 
@@ -1893,6 +1894,7 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 
 	BUG_ON(ac->ac_2order <= 0);
 	for (i = ac->ac_2order; i <= sb->s_blocksize_bits + 1; i++) {
+		i = array_index_nospec(i, sb->s_blocksize_bits + 2);
 		if (grp->bb_counters[i] == 0)
 			continue;
 
-- 
2.17.1
