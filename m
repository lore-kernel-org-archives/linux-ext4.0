From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Mon, 26 Feb 2007 17:20:18 -0600
Message-ID: <1172532018.16469.5.camel@kleikamp.austin.ibm.com>
References: <1170427180.6086.17.camel@garfield>
	 <20070225023651.8c89f8fc.akpm@linux-foundation.org>
	 <20070226214215.GE10715@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sct@redhat.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37705 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161397AbXBZXUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Feb 2007 18:20:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1QNKJ0k024052
	for <linux-ext4@vger.kernel.org>; Mon, 26 Feb 2007 18:20:19 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1QNKJYm292558
	for <linux-ext4@vger.kernel.org>; Mon, 26 Feb 2007 18:20:19 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1QNKILp013533
	for <linux-ext4@vger.kernel.org>; Mon, 26 Feb 2007 18:20:19 -0500
In-Reply-To: <20070226214215.GE10715@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-02-26 at 14:42 -0700, Andreas Dilger wrote:
> On Feb 25, 2007  02:36 -0800, Andrew Morton wrote:
> > > On Fri, 02 Feb 2007 20:09:40 +0530 Kalpak Shah <kalpak@clusterfs.com> wrote:
> > > +#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode)
> > > \
> > > +do {
> > > \
> > > +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);
> > > \
> > > +									      \
> > > +	if (offsetof(typeof(*raw_inode), extra_xtime) -
> > > \
> > > +	    offsetof(typeof(*raw_inode), i_extra_isize) +
> > > \
> > > +   	    sizeof((raw_inode)->extra_xtime) <=
> > > \
> > > +	    le16_to_cpu((raw_inode)->i_extra_isize)) {
> > > \
> > > +		if (sizeof((inode)->xtime.tv_sec) > 4)                        \
> > > +			(inode)->xtime.tv_sec |=                              \
> > > +			(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &       \
> > > +				EXT3_EPOCH_MASK) << 32;                       \
> > > +			(inode)->xtime.tv_nsec =                              \
> > > +				(le32_to_cpu((raw_inode)->extra_xtime) &      \
> > > +				EXT3_NSEC_MASK) >> 2;                         \
> > > +	}
> > > \
> > > +} while (0)
> > 
> > ow, my eyes.  Can we find a way to do this in C rather than in cpp?
> 
> The macro is working on the field names of the inode in most places
> (e.g. i_mtime, i_ctime, etc) rather than the values.  You _could_ do it
> in C, but it would mean moving all of the "offsetof()" into the caller
> (basically putting the whole macro in-line at the caller) or doing math
> on the pointer addresses at runtime instead of compile time.
> 
> It boils down to a check whether the particular nanosecond field is
> inside the reserved space in the inode or not, so it ends up a comparison
> against a constant.  For ctime:
> 
> 	if (4 <= le32_to_cpu((raw_inode)->i_extra_isize) {
> 
> And the second "if" decides whether to save bits > 32 in the seconds
> field for 64-bit architectures, so it is also evaluated at compile time.
> 
> Better to have this in a macro than in the code itself.

I wanted to see if I could clean this up, and this is what I came up
with.  I also did some macro magic to make these macros take one less
argument.  I ended up breaking two macros up into three smaller macros
and two inline functions.  Does this look any better?  (This is
incremental against Kalpak's patch.)

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux.orig/fs/ext3/inode.c linux/fs/ext3/inode.c
--- linux.orig/fs/ext3/inode.c	2007-02-26 17:10:22.000000000 -0600
+++ linux/fs/ext3/inode.c	2007-02-26 17:02:28.000000000 -0600
@@ -2674,10 +2674,10 @@ void ext3_read_inode(struct inode * inod
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 
-	EXT3_INODE_GET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
-	EXT3_INODE_GET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
-	EXT3_INODE_GET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
-	EXT3_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
+	EXT3_INODE_GET_XTIME(i_ctime, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_mtime, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_atime, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_crtime, ei, raw_inode);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2829,10 +2829,10 @@ static int ext3_do_update_inode(handle_t
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
-	EXT3_INODE_SET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
-	EXT3_INODE_SET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
-	EXT3_INODE_SET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
-	EXT3_INODE_SET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
+	EXT3_INODE_SET_XTIME(i_ctime, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_mtime, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_atime, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_crtime, ei, raw_inode);
 
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
diff -Nurp linux.orig/include/linux/ext3_fs.h linux/include/linux/ext3_fs.h
--- linux.orig/include/linux/ext3_fs.h	2007-02-26 17:10:22.000000000 -0600
+++ linux/include/linux/ext3_fs.h	2007-02-26 17:07:20.000000000 -0600
@@ -331,37 +331,42 @@ struct ext3_inode {
 #define EXT3_EPOCH_MASK ((1 << EXT3_EPOCH_BITS) - 1)
 #define EXT3_NSEC_MASK  (~0UL << EXT3_EPOCH_BITS)
 
-#define EXT3_INODE_SET_XTIME(xtime, extra_xtime, inode, raw_inode) \
-do { \
+#define EXT3_FITS_IN_INODE(ext3_inode, field)		 \
+	((offsetof(typeof(*ext3_inode), field) -	 \
+	  offsetof(typeof(*ext3_inode), i_extra_isize) + \
+	  sizeof((ext3_inode)->field))			 \
+	 <= le16_to_cpu((ext3_inode)->i_extra_isize))
+
+static inline __le32 ext3_encode_extra_time(struct timespec *time)
+{
+	return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
+				time->tv_sec >> 32 : 0) |
+			   ((time->tv_nsec << 2) & EXT3_NSEC_MASK));
+}
+
+static inline void ext3_decode_extra_time(struct timespec *time, __le32 extra) {
+	if (sizeof(time->tv_sec) > 4)
+		time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT3_EPOCH_MASK)
+				<< 32;
+	time->tv_nsec = (le32_to_cpu(extra) & EXT3_NSEC_MASK) >> 2;
+}
+
+#define EXT3_INODE_SET_XTIME(xtime, inode, raw_inode)		 \
+do {								 \
 	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec); \
-									      \
-	if (offsetof(typeof(*raw_inode), extra_xtime) - \
-	    offsetof(typeof(*raw_inode), i_extra_isize) + \
-	    sizeof((raw_inode)->extra_xtime) <= \
-		le16_to_cpu((raw_inode)->i_extra_isize))                      \
-		(raw_inode)->extra_xtime =                                    \
-			cpu_to_le32((sizeof((inode)->xtime.tv_sec) > 4 ?      \
-				((__u64)(inode)->xtime.tv_sec >> 32) : 0)|    \
-				(((inode)->xtime.tv_nsec << 2) &              \
-				EXT3_NSEC_MASK));                             \
+								 \
+	if (EXT3_FITS_IN_INODE(raw_inode, xtime ## _extra))	 \
+		(raw_inode)->xtime ## _extra =			 \
+			ext3_encode_extra_time(&(inode)->xtime); \
 } while (0)
 
-#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode) \
-do { \
-	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime); \
-									      \
-	if (offsetof(typeof(*raw_inode), extra_xtime) - \
-	    offsetof(typeof(*raw_inode), i_extra_isize) + \
-   	    sizeof((raw_inode)->extra_xtime) <= \
-	    le16_to_cpu((raw_inode)->i_extra_isize)) { \
-		if (sizeof((inode)->xtime.tv_sec) > 4)                        \
-			(inode)->xtime.tv_sec |=                              \
-			(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &       \
-				EXT3_EPOCH_MASK) << 32;                       \
-			(inode)->xtime.tv_nsec =                              \
-				(le32_to_cpu((raw_inode)->extra_xtime) &      \
-				EXT3_NSEC_MASK) >> 2;                         \
-	} \
+#define EXT3_INODE_GET_XTIME(xtime, inode, raw_inode)			\
+do {									\
+	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	\
+									\
+	if (EXT3_FITS_IN_INODE(raw_inode, xtime ## _extra))		\
+		ext3_decode_extra_time(&(inode)->xtime,			\
+				       raw_inode->xtime ## _extra);	\
 } while (0)
 
 

-- 
David Kleikamp
IBM Linux Technology Center
