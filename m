From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH] vfs: fix compilation for no-MMU configurations
Date: Sun,  5 Oct 2014 10:58:36 +0200
Message-ID: <1412499516-12839-1-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: kernel@pengutronix.de,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Commit ac4dd23b76ce introduced a new function pagecache_isize_extended.
In <linux/mm.h> it was declared static inline and empty for no-MMU and
defined unconditionally in mm/truncate.c which results a compiler
error:

	  CC      mm/truncate.o
	mm/truncate.c:751:6: error: redefinition of 'pagecache_isize_extended'
	 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t =
to)
	      ^
	In file included from mm/truncate.c:13:0:
	include/linux/mm.h:1161:91: note: previous definition of 'pagecache_isiz=
e_extended' was here
	 static inline void pagecache_isize_extended(struct inode *inode, loff_t=
 from,
												   ^
	scripts/Makefile.build:257: recipe for target 'mm/truncate.o' failed

(tested with ARCH=3Darm efm32_defconfig).

Fixes: ac4dd23b76ce ("vfs: fix data corruption when blocksize < pagesize =
for mmaped data")
Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
---
Hello,

the bad commit sits in

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git#dev

and is included in next.

Best regards
Uwe

 mm/truncate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/truncate.c b/mm/truncate.c
index 261eaf6e5a19..0d9c4ebd5ecc 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -729,6 +729,7 @@ void truncate_setsize(struct inode *inode, loff_t new=
size)
 }
 EXPORT_SYMBOL(truncate_setsize);
=20
+#ifdef CONFIG_MMU
 /**
  * pagecache_isize_extended - update pagecache after extension of i_size
  * @inode:	inode for which i_size was extended
@@ -780,6 +781,7 @@ void pagecache_isize_extended(struct inode *inode, lo=
ff_t from, loff_t to)
 	page_cache_release(page);
 }
 EXPORT_SYMBOL(pagecache_isize_extended);
+#endif
=20
 /**
  * truncate_pagecache_range - unmap and remove pagecache that is hole-pu=
nched
--=20
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
