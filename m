From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/19] libext2fs: Don't cache inodes that fail checksum
 verification
Date: Fri, 01 Aug 2014 11:12:47 -0700
Message-ID: <20140801181247.12496.53055.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33338 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaHASMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:52 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If an inode fails checksum verification, don't stuff a copy of it in
the inode cache, because this can cause the library to fail to return
the "corrupt inode" error code.

In general, this happens if ext2fs_read_inode_full() is called twice
on an inode with an incorrect checksum.  If fs->flags has
EXT2_FLAG_IGNORE_CSUM_ERRORS set during the first call and *unset*
during the second call, the cache hit during the second call fails to
return EXT2_ET_INODE_CSUM_INVALID as you'd expect.  This happens
during fsck because the first read_inode call happens as part of
check_blocks and the second call happens during inode checksum
revalidation.  A file system with a slightly corrupt non-extent inode
will trigger this.

While we're at it, make the inode read function consistent with the
rest of libext2fs -- copy the metadata object into the caller's buffer
even if it fails checksum verification.  This will help e2fsck avoid a
double re-read later on down the line.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inode.c                      |   15 +++++++++------
 tests/f_no_cache_corrupt_inode/expect.1 |   11 +++++++++++
 tests/f_no_cache_corrupt_inode/expect.2 |    7 +++++++
 tests/f_no_cache_corrupt_inode/image.gz |  Bin
 tests/f_no_cache_corrupt_inode/name     |    1 +
 5 files changed, 28 insertions(+), 6 deletions(-)
 create mode 100644 tests/f_no_cache_corrupt_inode/expect.1
 create mode 100644 tests/f_no_cache_corrupt_inode/expect.2
 create mode 100644 tests/f_no_cache_corrupt_inode/image.gz
 create mode 100644 tests/f_no_cache_corrupt_inode/name

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index a6213ae..6c766af 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -709,7 +709,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	io_channel	io;
 	int		length = EXT2_INODE_SIZE(fs->super);
 	struct ext2_inode_large	*iptr;
-	int		cache_slot;
+	int		cache_slot, fail_csum;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -787,9 +787,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	length = EXT2_INODE_SIZE(fs->super);
 
 	/* Verify the inode checksum. */
-	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
-	    !ext2fs_inode_csum_verify(fs, ino, iptr))
-		return EXT2_ET_INODE_CSUM_INVALID;
+	fail_csum = !ext2fs_inode_csum_verify(fs, ino, iptr);
 
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) iptr,
@@ -798,10 +796,15 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 #endif
 
 	/* Update the inode cache bookkeeping */
-	fs->icache->cache_last = cache_slot;
-	fs->icache->cache[cache_slot].ino = ino;
+	if (!fail_csum) {
+		fs->icache->cache_last = cache_slot;
+		fs->icache->cache[cache_slot].ino = ino;
+	}
 	memcpy(inode, iptr, (bufsize > length) ? length : bufsize);
 
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) && fail_csum)
+		return EXT2_ET_INODE_CSUM_INVALID;
+
 	return 0;
 }
 
diff --git a/tests/f_no_cache_corrupt_inode/expect.1 b/tests/f_no_cache_corrupt_inode/expect.1
new file mode 100644
index 0000000..4f82f75
--- /dev/null
+++ b/tests/f_no_cache_corrupt_inode/expect.1
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 passes checks, but checksum does not match inode.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 1
diff --git a/tests/f_no_cache_corrupt_inode/expect.2 b/tests/f_no_cache_corrupt_inode/expect.2
new file mode 100644
index 0000000..1b43315
--- /dev/null
+++ b/tests/f_no_cache_corrupt_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
diff --git a/tests/f_no_cache_corrupt_inode/image.gz b/tests/f_no_cache_corrupt_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e17e9216deac289cf5c13a33be87b1810640a66d
GIT binary patch
literal 2606
zcmb2|=3wyobSapL`Ry(14B<o>h7a#A{ZQZy>*8x|QnKm@V3(D-?OG_n)#_yJ!7jME
zccFxPCX1kBt6$TLWsAF;`vY|rJyPTFYwCAAxQJ1dedE2Sil)~bqkGT(t$SEM{r$V5
z^84lefA)JjF<e?ThsQ|q%aO%5HClpdtCq=KWj(d^V#U*s0h)apXU_8O?RMHzA<=uf
zx777(Vfx+;+L7*iCMn+(*tTZBLGiB(^L{U9TlbZ}?oIvWJ@U7?-M#B~ud{9gI$`~{
zxf=I(#nr{Fdot<o+4QW>&#ou0{Bmr4M&rwy6_4VU%juSV`?OqhEd#^L$xHU%EzDW<
z?ElgobJqIRTYdVPt0{6lLy>`jA>!Y&Pd7g-O%|Nb4&?o-KKcItPl425PH*=!{G4#|
z%h#*_4)4}`VkCStd1)?t_wjx?k7unP7OYm*66uzk1JrTANZ|X^`FE>t1i#FA^?(1n
zRbT%zGB7lJd+|SCBD&hV^8Z5bYM?TQ-QWIe?>@c^EbH)J9w?O2|IZ#sfxw16qFqPl
zgh4nsNrku1cFj5kly<oNk%a}PGJ+Bf_YI>eZLW0GZ$0}^eC_)0ZyanQqF4V<vCS&B
zI`rz7QQ+1sU*vpSFG$bhS${9;gxW<5zD&#Ke)-<tP0b7S?tZ;rVtn^&{r{a`e+Sq}
z^1u6{U+}+w-~IppLehgRv$V?J`@E}{SDUrJ{Zi2%^ZQ=kf7bt~+4Z`<dfC_C1?ng3
ze~F*^Z<P3W&(ldyQe0)UA4hC;xm~x@e&@gZIhjwt)_+Y2S$q45|Ihd@&i|%IA2HLr
zyU*zF>dL)|HA^P`SDl!%e<C*%K_8AP7!85Z5Eu=C(GVC7fzc2kF9bgP-p6Po@Th@-
HL4g4PrH?{0

literal 0
HcmV?d00001

diff --git a/tests/f_no_cache_corrupt_inode/name b/tests/f_no_cache_corrupt_inode/name
new file mode 100644
index 0000000..fb213e2
--- /dev/null
+++ b/tests/f_no_cache_corrupt_inode/name
@@ -0,0 +1 @@
+don't cache inodes that fail checksum verification

