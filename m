From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix inode cache overruns
Date: Thu, 29 Nov 2012 20:46:06 -0500
Message-ID: <20121130014606.GA24765@thunk.org>
References: <20121117183745.GA8489@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35979 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2K3Fx3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 00:53:29 -0500
Content-Disposition: inline
In-Reply-To: <20121117183745.GA8489@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 17, 2012 at 01:37:45PM -0500, Eric Whitney wrote:
> An inode cache slot will be overrun if a caller to ext2fs_read_inode_full()
> or ext2fs_write_inode_full() attempts to read or write a full sized 156
> byte inode when the target filesystem contains 128 byte inodes.  Limit the
> copied inode to the smaller of the target filesystem's or the caller's
> requested inode size.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

I investigated and discovered why running the ext4 regression tests
using valgrind didn't discover the problem.  The following commit
allowed the bug to be trivially surfaced by running the command:

	cd tests; ./test_script --valgrind

I've now verified that the with your patch and this one, plus another
fix which I've applied to the maint branch to fix various gcc -Wall
complaints in resize2fs, "./test_script --valgrind" now runs cleanly.

							- Ted

commit 603e5ebc8bb4b5e75c53ddf1461992f8861b35a1
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Nov 29 20:40:21 2012 -0500

    libext2fs: allocate separate memory regions for each inode in the cache
    
    The changes to support metadata checksum allocated a single large
    array for all of the inodes in the inode cache.  This is slightly more
    efficient, but given that the inode cache is small (only 4 inodes) it
    doesn't really have that much benefit.  The problem with doing things
    this way is that the memory overruns, such as the one fixed in commit
    43c4910371a, do not get detected by valgrind.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9148d4e..7ec189e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1328,6 +1328,7 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
 
 /* inode.c */
+extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
 extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
 					    ext2_ino_t *ino,
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 28c4132..d3e815c 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -18,8 +18,6 @@
 #include "ext2_fs.h"
 #include "ext2fsP.h"
 
-static void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
-
 void ext2fs_free(ext2_filsys fs)
 {
 	if (!fs || (fs->magic != EXT2_ET_MAGIC_EXT2FS_FILSYS))
@@ -65,21 +63,6 @@ void ext2fs_free(ext2_filsys fs)
 }
 
 /*
- * Free the inode cache structure
- */
-static void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
-{
-	if (--icache->refcount)
-		return;
-	if (icache->buffer)
-		ext2fs_free_mem(&icache->buffer);
-	if (icache->cache)
-		ext2fs_free_mem(&icache->cache);
-	icache->buffer_blk = 0;
-	ext2fs_free_mem(&icache);
-}
-
-/*
  * This procedure frees a badblocks list.
  */
 void ext2fs_u32_list_free(ext2_u32_list bb)
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index e47d664..f877146 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -72,6 +72,25 @@ errcode_t ext2fs_flush_icache(ext2_filsys fs)
 	return 0;
 }
 
+/*
+ * Free the inode cache structure
+ */
+void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
+{
+	int i;
+
+	if (--icache->refcount)
+		return;
+	if (icache->buffer)
+		ext2fs_free_mem(&icache->buffer);
+	for (i = 0; i < icache->cache_size; i++)
+		ext2fs_free_mem(&icache->cache[i].inode);
+	if (icache->cache)
+		ext2fs_free_mem(&icache->cache);
+	icache->buffer_blk = 0;
+	ext2fs_free_mem(&icache);
+}
+
 static errcode_t create_icache(ext2_filsys fs)
 {
 	int		i;
@@ -86,31 +105,32 @@ static errcode_t create_icache(ext2_filsys fs)
 
 	memset(fs->icache, 0, sizeof(struct ext2_inode_cache));
 	retval = ext2fs_get_mem(fs->blocksize, &fs->icache->buffer);
-	if (retval) {
-		ext2fs_free_mem(&fs->icache);
-		return retval;
-	}
+	if (retval)
+		goto errout;
+
 	fs->icache->buffer_blk = 0;
 	fs->icache->cache_last = -1;
 	fs->icache->cache_size = 4;
 	fs->icache->refcount = 1;
 	retval = ext2fs_get_array(fs->icache->cache_size,
-				  sizeof(struct ext2_inode_cache_ent) +
-				  EXT2_INODE_SIZE(fs->super),
+				  sizeof(struct ext2_inode_cache_ent),
 				  &fs->icache->cache);
-	if (retval) {
-		ext2fs_free_mem(&fs->icache->buffer);
-		ext2fs_free_mem(&fs->icache);
-		return retval;
-	}
+	if (retval)
+		goto errout;
 
-	for (i = 0, p = (void *)(fs->icache->cache + fs->icache->cache_size);
-	     i < fs->icache->cache_size;
-	     i++, p += EXT2_INODE_SIZE(fs->super))
-		fs->icache->cache[i].inode = p;
+	for (i = 0; i < fs->icache->cache_size; i++) {
+		retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super),
+					&fs->icache->cache[i].inode);
+		if (retval)
+			goto errout;
+	}
 
 	ext2fs_flush_icache(fs);
 	return 0;
+errout:
+	ext2fs_free_inode_cache(fs->icache);
+	fs->icache = 0;
+	return retval;
 }
 
 errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
