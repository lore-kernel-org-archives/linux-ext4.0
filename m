From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 10:29:05 -0500
Message-ID: <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
	 <45F6BDC9.8080205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Radoslaw Szkodzinski <astralstorm@gmail.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36966 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXCMP3J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2007 11:29:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2DFT7nZ017221
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 11:29:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2DFT7lt164558
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 11:29:07 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2DFT6Ii031028
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 11:29:07 -0400
In-Reply-To: <45F6BDC9.8080205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-03-13 at 10:05 -0500, Eric Sandeen wrote:
> Andrew Morton wrote:
> 
> > And broken stuff too :-)
> > The nanoseconds patch is broken on x86_64 - makes mtimes from the future:
> > e.g. year 2431. I suspect an endianness issue.
> > x86 works fine according to my sources.
> >
> > The files themselves have correct mtimes, as booting previous kernel
> > or one w/o the nanoseconds patch works fine.
> There were later patches posted to the list after this version, I think, which
> are not yet in Ted's tree... I'll find some time today to test the "take3" version
> on x86_64, unless someone beats me to it.

I didn't quite beat you to it, but I did make a diff to bring
2.6.21-rc3-mm1 in tune with the "take3" patch.  It makes the code easier
to understand, but I'm not sure if it contains anything to fix the bug.
Code inspection hasn't gotten me any closer to figuring out what's
wrong.

Shaggy

diff -Nurp linux-2.6.21-rc3-mm1/fs/ext4/inode.c linux/fs/ext4/inode.c
--- linux-2.6.21-rc3-mm1/fs/ext4/inode.c	2007-03-09 14:14:01.000000000 -0600
+++ linux/fs/ext4/inode.c	2007-03-13 09:21:13.000000000 -0500
@@ -2706,10 +2706,6 @@ void ext4_read_inode(struct inode * inod
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	EXT4_INODE_GET_XTIME(i_ctime, i_ctime_extra, ei, inode, raw_inode);
-	EXT4_INODE_GET_XTIME(i_mtime, i_mtime_extra, ei, inode, raw_inode);
-	EXT4_INODE_GET_XTIME(i_atime, i_atime_extra, ei, inode, raw_inode);
-	EXT4_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, ei, raw_inode);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2785,6 +2781,11 @@ void ext4_read_inode(struct inode * inod
 	} else
 		ei->i_extra_isize = 0;
 
+	EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_crtime, ei, raw_inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -2866,10 +2867,10 @@ static int ext4_do_update_inode(handle_t
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
 
-	EXT4_INODE_SET_XTIME(i_ctime, i_ctime_extra, ei, inode, raw_inode);
-	EXT4_INODE_SET_XTIME(i_mtime, i_mtime_extra, ei, inode, raw_inode);
-	EXT4_INODE_SET_XTIME(i_atime, i_atime_extra, ei, inode, raw_inode);
-	EXT4_INODE_SET_XTIME(i_crtime, i_crtime_extra, ei, ei, raw_inode);
+	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_crtime, ei, raw_inode);
 
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
diff -Nurp linux-2.6.21-rc3-mm1/include/linux/ext4_fs.h linux/include/linux/ext4_fs.h
--- linux-2.6.21-rc3-mm1/include/linux/ext4_fs.h	2007-03-09 14:14:08.000000000 -0600
+++ linux/include/linux/ext4_fs.h	2007-03-13 09:21:13.000000000 -0500
@@ -358,39 +358,42 @@ struct ext4_inode {
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
 
-#define EXT4_INODE_SET_XTIME(xtime, extra_xtime, ei, inode, raw_inode)	       \
+#define EXT4_FITS_IN_INODE(ext4_inode, field)		\
+	((offsetof(typeof(*ext4_inode), field) +	\
+	  sizeof((ext4_inode)->field))			\
+	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
+	    le16_to_cpu((ext4_inode)->i_extra_isize)))	\
+
+static inline __le32 ext4_encode_extra_time(struct timespec *time)
+{
+       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
+			   time->tv_sec >> 32 : 0) |
+			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
+}
+
+static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra) {
+       if (sizeof(time->tv_sec) > 4)
+	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
+			       << 32;
+       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
+}
+
+#define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)	   		       \
 do {									       \
-	if (offsetof(typeof(*raw_inode), xtime) +			       \
-	    sizeof((raw_inode)->xtime) <= 				       \
-	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
-		(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);       \
-	if (offsetof(typeof(*raw_inode), extra_xtime) +			       \
-	    sizeof((raw_inode)->extra_xtime) <=				       \
-	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
-		(raw_inode)->extra_xtime =				       \
-			cpu_to_le32((sizeof((inode)->xtime.tv_sec) > 4 ?       \
-				((__u64)(inode)->xtime.tv_sec >> 32) : 0)|     \
-				(((inode)->xtime.tv_nsec << 2) &	       \
-				EXT4_NSEC_MASK));			       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime))			       \
+        	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		(raw_inode)->xtime ## _extra =				       \
+				ext4_encode_extra_time(&(inode)->xtime);       \
 } while (0)
 
-#define EXT4_INODE_GET_XTIME(xtime, extra_xtime, ei, inode, raw_inode)	       \
+#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)		  	       \
 do {									       \
-	if (offsetof(typeof(*raw_inode), xtime) +			       \
-	    sizeof((raw_inode)->xtime) <=				       \
-	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime))                              \
 		(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);       \
-	if (offsetof(typeof(*raw_inode), extra_xtime) +			       \
-	    sizeof((raw_inode)->extra_xtime) <= 			       \
-	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize){		       \
-		if (sizeof((inode)->xtime.tv_sec) > 4)			       \
-			(inode)->xtime.tv_sec |=			       \
-				(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &\
-					EXT4_EPOCH_MASK) << 32;		       \
-			(inode)->xtime.tv_nsec =			       \
-				(le32_to_cpu((raw_inode)->extra_xtime) &       \
-					EXT4_NSEC_MASK) >> 2;		       \
-	}								       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		ext4_decode_extra_time(&(inode)->xtime,			       \
+				       raw_inode->xtime ## _extra);	       \
 } while (0)
 
 #if defined(__KERNEL__) || defined(__linux__)
@@ -589,7 +592,7 @@ static inline struct ext4_inode_info *EX
 
 static inline struct timespec ext4_current_time(struct inode *inode)
 {
-	return (inode->i_sb->s_time_gran < 1000000000) ?
+	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
 		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
 }
 

-- 
David Kleikamp
IBM Linux Technology Center
