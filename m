From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Thu, 12 Jul 2007 18:28:46 +0530
Message-ID: <1184245126.4299.20.camel@garfield>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Yj6/pte0b0iSbPhUdoJA"
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:51274 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbXGLM5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 08:57:51 -0400
In-Reply-To: <20070710163027.1bf7e94e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-Yj6/pte0b0iSbPhUdoJA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:36:56 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > This patch is a spinoff of the old nanosecond patches.
> 
> I don't know what the "old nanosecond patches" are.  A link to a suitable
> changlog for those patches would do in a pinch.  Preferable would be to
> write a proper changelog for this patch.

The incremental patch contains a proper changelog describing the patch.

> > +static inline __le32 ext4_encode_extra_time(struct timespec *time)
> > +{
> > +       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> > +			   time->tv_sec >> 32 : 0) |
> > +			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
> > +}
> > +
> > +static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> > +{
> > +       if (sizeof(time->tv_sec) > 4)
> > +	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> > +			       << 32;
> > +       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
> > +}
> 
> Consider uninlining these functions.

Done.

This patch adds comments, few small corrections and an appropriate
changelog entry.

Thanks,
Kalpak.

--=-Yj6/pte0b0iSbPhUdoJA
Content-Disposition: attachment; filename=ext4_nanosecond_correction.patch
Content-Type: text/x-patch; name=ext4_nanosecond_correction.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch adds nanosecond timestamps for ext4. This involves adding
*time_extra fields to the ext4_inode to extend the timestamps to 64-bits.
Creation time is also added by this patch.

These extended fields will fit into an inode if the filesystem was formatted
with large inodes (-I 256 or larger) and there are currently no EAs
consuming all of the available space. For new inodes we always reserve
enough space for the kernel's known extended fields, but for inodes
created with an old kernel this might not have been the case. So this patch
also adds the EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE feature flag(ro-compat so that
older kernels can't create inodes with a smaller extra_isize). which indicates
if the fields fitting inside s_min_extra_isize are available or not.
If the expansion of inodes if unsuccessful then this feature will be disabled.
This feature is only enabled if requested by the sysadmin.

None of the extended inode fields is critical for correct filesystem operation.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22.orig/include/linux/ext4_fs.h
+++ linux-2.6.22/include/linux/ext4_fs.h
@@ -350,20 +350,30 @@ struct ext4_inode {
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
 
+/*
+ * Extended fields will fit into an inode if the filesystem was formatted
+ * with large inodes (-I 256 or larger) and there are not currently any EAs
+ * consuming all of the available space. For new inodes we always reserve
+ * enough space for the kernel's known extended fields, but for inodes
+ * created with an old kernel this might not have been the case. None of
+ * the extended inode fields is critical for correct filesystem operation.
+ * This macro checks if a certain field fits in the inode. Note that
+ * inode-size = GOOD_OLD_INODE_SIZE + i_extra_isize
+ */
 #define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
 	((offsetof(typeof(*ext4_inode), field) +	\
 	  sizeof((ext4_inode)->field))			\
 	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
 	    (einode)->i_extra_isize))			\
 
-static inline __le32 ext4_encode_extra_time(struct timespec *time)
+static __le32 ext4_encode_extra_time(struct timespec *time)
 {
        return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
 			   time->tv_sec >> 32 : 0) |
 			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
 }
 
-static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
+static void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
        if (sizeof(time->tv_sec) > 4)
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
Index: linux-2.6.22/include/linux/ext4_fs_i.h
===================================================================
--- linux-2.6.22.orig/include/linux/ext4_fs_i.h
+++ linux-2.6.22/include/linux/ext4_fs_i.h
@@ -153,6 +153,10 @@ struct ext4_inode_info {
 
 	unsigned long i_ext_generation;
 	struct ext4_ext_cache i_cached_extent;
+	/*
+	 * File creation time. Its function is same as that of
+	 * struct timespec i_{a,c,m}time in the generic inode.
+	 */
 	struct timespec i_crtime;
 };
 

--=-Yj6/pte0b0iSbPhUdoJA--
