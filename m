From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 19:41:34 -0400
Message-ID: <20140613234134.GC5036@thunk.org>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38450 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbaFMXlm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 19:41:42 -0400
Content-Disposition: inline
In-Reply-To: <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 12:44:34PM -0700, JP Abgrall wrote:
> The per-file secure discard seems to be the way to go, as there are
> only a few places in Android where this needs to be turned on.
> The  current idletime-fstrim would  switch from FITRIM to SFITRIM to
> reduce the leftovers.

OK, how about this?  The following patch is in the Google data center
kernel, but I never got around to get it upstream (oops, was on my
todo list, but it never happened).

If you want to adopt this for usptream, and add support for
BLKSECDISCARD as well as BLKDISCARD, then you could for each file that
you want to do the per-file secure discard, you would just have to
open the file, call the BLKSECDISCARD ioctl, and then delete the file.

Cheers,

					- Ted

commit 16ff6352b123aa134417793d636f05cd4e240eaa
Author: Theodore Ts'o <tytso@google.com>
Date:   Fri Dec 20 12:48:26 2013 -0500

    ext4: add support for the BLKDISCARD ioctl
    
    The blkdicard ioctl previously only worked on block devices.  Allow
    this ioctl to work on ext4 files.
    
    This commit is intended to be sent upstream.
    
    Google-Bug-Id: 11517631
    Tested: fs smoke test; manual check of the blkdiscard ioctl
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Effort: fs/ext4
    Origin-3.3-SHA1: 85ef322daf0da0000759b1fe3a1e1bd3da3b906a
    Change-Id: If031d1b8e796ebcb0afcb8a5259c760441bc6b2e

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b3a0f21..0203d9c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2695,6 +2695,8 @@ extern int ext4_check_blockref(const char *, unsigned int,
 /* extents.c */
 struct ext4_ext_path;
 struct ext4_extent;
+typedef int (*extent_iterator_t)(struct inode *inode, struct extent_status *es,
+				 unsigned int flags, void *private);
 
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
@@ -2733,6 +2735,9 @@ extern int ext4_find_delalloc_range(struct inode *inode,
 				    ext4_lblk_t lblk_start,
 				    ext4_lblk_t lblk_end);
 extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
+extern int ext4_extent_iterator(struct inode *inode,
+				ext4_lblk_t block, ext4_lblk_t num,
+				extent_iterator_t callback, void *private);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_precache(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2c84bc0..6118a1d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2118,9 +2118,13 @@ cleanup:
 	return err;
 }
 
-static int ext4_fill_fiemap_extents(struct inode *inode,
-				    ext4_lblk_t block, ext4_lblk_t num,
-				    struct fiemap_extent_info *fieinfo)
+
+typedef int (*extent_iterator_t)(struct inode *inode, struct extent_status *es,
+				 unsigned int flags, void *private);
+
+int ext4_extent_iterator(struct inode *inode,
+			 ext4_lblk_t block, ext4_lblk_t num,
+			 extent_iterator_t callback, void *private)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent *ex;
@@ -2129,7 +2133,6 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 	ext4_lblk_t last = block + num;
 	int exists, depth = 0, err = 0;
 	unsigned int flags = 0;
-	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 
 	while (block < last && block != EXT_MAX_BLOCKS) {
 		num = last - block;
@@ -2253,11 +2256,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 		}
 
 		if (exists) {
-			err = fiemap_fill_next_extent(fieinfo,
-				(__u64)es.es_lblk << blksize_bits,
-				(__u64)es.es_pblk << blksize_bits,
-				(__u64)es.es_len << blksize_bits,
-				flags);
+			err = callback(inode, &es, flags, private);
 			if (err < 0)
 				break;
 			if (err == 1) {
@@ -2277,6 +2276,27 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 	return err;
 }
 
+static int call_fill_fiemap(struct inode *inode, struct extent_status *es,
+			    unsigned int flags, void *private)
+{
+	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
+
+	return fiemap_fill_next_extent(private,
+				       (__u64)es->es_lblk << blksize_bits,
+				       (__u64)es->es_pblk << blksize_bits,
+				       (__u64)es->es_len << blksize_bits,
+				       flags);
+}
+
+static int ext4_fill_fiemap_extents(struct inode *inode,
+				    ext4_lblk_t block, ext4_lblk_t num,
+				    struct fiemap_extent_info *fieinfo)
+{
+	return ext4_extent_iterator(inode, block, num,
+				    call_fill_fiemap, fieinfo);
+}
+
+
 /*
  * ext4_ext_put_gap_in_cache:
  * calculate boundaries of the gap that the requested block fits into
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 5498f75..da6eac0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -214,6 +214,132 @@ swap_boot_out:
 	return err;
 }
 
+static int discard_callback(struct inode *inode, struct extent_status *es,
+			    unsigned int flags, void *private)
+{
+	struct ext4_map_blocks *map = private;
+	ext4_lblk_t es_lblk = es->es_lblk;
+	ext4_lblk_t es_len = es->es_len;
+	ext4_fsblk_t es_pblk = es->es_pblk;
+
+	if (flags & (FIEMAP_EXTENT_UNKNOWN |
+		     FIEMAP_EXTENT_ENCODED |
+		     FIEMAP_EXTENT_DATA_ENCRYPTED |
+		     FIEMAP_EXTENT_DELALLOC |
+		     FIEMAP_EXTENT_DATA_TAIL |
+		     FIEMAP_EXTENT_DATA_INLINE |
+		     FIEMAP_EXTENT_NOT_ALIGNED |
+		     FIEMAP_EXTENT_SHARED))
+		return 0;
+
+	if (es_lblk < map->m_lblk) {
+		ext4_lblk_t d = map->m_lblk - es_lblk;
+		if (d > es_len)
+			return 0;
+		es_lblk += d;
+		es_pblk += d;
+		es_len -= d;
+	}
+
+	if (es_lblk + es_len > map->m_lblk + map->m_len)
+		es_len -= es_lblk + es_len - (map->m_lblk + map->m_len);
+#ifdef BLKDISCARD_DEBUG
+	ext4_msg(inode->i_sb, KERN_NOTICE, "discard: %llu len %lu",
+		 (unsigned long long) es_pblk, (unsigned long) es_len);
+	return 0;
+#else
+	return sb_issue_discard(inode->i_sb, es_pblk, es_len, GFP_KERNEL, 0);
+#endif
+}
+
+static int blkdiscard_inode(struct inode *inode, u64 start_offset, u64 len)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_map_blocks map;
+	unsigned int num;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	if (!blk_queue_discard(bdev_get_queue(sb->s_bdev)))
+		return -EOPNOTSUPP;
+
+	if (!bdev_discard_zeroes_data(sb->s_bdev) && !capable(CAP_SYS_ADMIN))
+		return -EOPNOTSUPP;
+
+	num = start_offset & (sb->s_blocksize - 1);
+	if (num) {
+		num = sb->s_blocksize - num;
+		start_offset += num;
+		len = (len > num) ? len - num : 0;
+	}
+	if (len == 0)
+		return 0;
+	if (start_offset > sb->s_maxbytes)
+		return -EFBIG;
+	if (len > sb->s_maxbytes || (sb->s_maxbytes - len) < start_offset)
+		len = sb->s_maxbytes - start_offset;
+
+	map.m_lblk = start_offset >> sb->s_blocksize_bits;
+	map.m_len = len >> sb->s_blocksize_bits;
+
+#ifdef BLKDISCARD_DEBUG
+	ext4_msg(sb, KERN_NOTICE, "blkdiscard range: %lu len %lu",
+		 (unsigned long) map.m_lblk, (unsigned long) map.m_len);
+#endif
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return ext4_extent_iterator(inode, map.m_lblk, map.m_len,
+					    discard_callback, &map);
+
+	num = map.m_len;
+	while (num) {
+		int ret = ext4_map_blocks(NULL, inode, &map, 0);
+
+		if (ret < 0)
+			return ret;
+
+		if (ret == 0) {
+#ifdef BLKDISCARD_DEBUG
+			ext4_msg(sb, KERN_NOTICE,
+				 "skip: lblk %lu len %lu ret %lu num %lu",
+				 (unsigned long) map.m_lblk,
+				 (unsigned long) map.m_len,
+				 (unsigned long) ret,
+				 (unsigned long) num);
+#endif
+			map.m_lblk++;
+			num--;
+			continue;
+		}
+#ifdef BLKDISCARD_DEBUG
+		ext4_msg(sb, KERN_NOTICE,
+			 "walk: lblk %lu pblk %llu len %lu ret %lu num %lu",
+			 (unsigned long) map.m_lblk,
+			 (unsigned long long) map.m_pblk,
+			 (unsigned long) map.m_len,
+			 (unsigned long) ret,
+			 (unsigned long) num);
+#endif
+		if (ret > num)
+			ret = num;
+		map.m_lblk += ret;
+		num -= ret;
+		map.m_len = num;
+
+#ifdef BLKDISCARD_DEBUG
+		ext4_msg(sb, KERN_NOTICE, "discard: %llu len %lu",
+			 (unsigned long long) map.m_pblk, (unsigned long) ret);
+#else
+		ret = sb_issue_discard(sb, map.m_pblk, ret,
+				       GFP_KERNEL, 0);
+		if (ret)
+			return ret;
+#endif
+	}
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -627,6 +753,18 @@ resizefs_out:
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
 
+	case BLKDISCARD: {
+		uint64_t range[2];
+
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+			return -EFAULT;
+
+		return blkdiscard_inode(file_inode(filp), range[0], range[1]);
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -691,6 +829,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FITRIM:
 	case EXT4_IOC_RESIZE_FS:
 	case EXT4_IOC_PRECACHE_EXTENTS:
+	case BLKDISCARD:
 		break;
 	default:
 		return -ENOIOCTLCMD;
