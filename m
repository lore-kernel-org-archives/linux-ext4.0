From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 15:07:01 -0500
Message-ID: <45F70465.4020406@redhat.com>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>	 <45F6BDC9.8080205@redhat.com> <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Radoslaw Szkodzinski <astralstorm@gmail.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbXCMUPO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2007 16:15:14 -0400
In-Reply-To: <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:

> I didn't quite beat you to it, but I did make a diff to bring
> 2.6.21-rc3-mm1 in tune with the "take3" patch.  It makes the code easier
> to understand, but I'm not sure if it contains anything to fix the bug.
> Code inspection hasn't gotten me any closer to figuring out what's
> wrong.
>
> Shaggy
>   
And here's one on top of that, after discussing w/ Dave, Kalpak, and Badari 
on #linuxfs.

The problem in the -mm tree is that it was looking at i_extra_isize
before it got set; that was fixed in Kalpak's patch, which Dave sent
the interdiff for.  Then, we were looking at the raw_inode's extra_isize,
not the in-core one.  This fixes that, and along the way, gets rid
of the cleverness of passing different types into the 2nd arg of the
same GET/SET macros... 

============

Differentiate xtime macros which use the vfs inode vs. ext4_inode_info
Use in-core ext4 inode rather than raw_inode to get extra_isize
in EXT4_FITS_IN_INODE

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6-ext4/fs/ext4/inode.c
===================================================================
--- linux-2.6-ext4.orig/fs/ext4/inode.c
+++ linux-2.6-ext4/fs/ext4/inode.c
@@ -2784,7 +2784,7 @@ void ext4_read_inode(struct inode * inod
 	EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
 	EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
 	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
-	EXT4_INODE_GET_XTIME(i_crtime, ei, raw_inode);
+	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -2870,7 +2870,7 @@ static int ext4_do_update_inode(handle_t
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
 	EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
 	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
-	EXT4_INODE_SET_XTIME(i_crtime, ei, raw_inode);
+	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
 
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
Index: linux-2.6-ext4/include/linux/ext4_fs.h
===================================================================
--- linux-2.6-ext4.orig/include/linux/ext4_fs.h
+++ linux-2.6-ext4/include/linux/ext4_fs.h
@@ -358,11 +358,11 @@ struct ext4_inode {
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
 
-#define EXT4_FITS_IN_INODE(ext4_inode, field)		\
+#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
 	((offsetof(typeof(*ext4_inode), field) +	\
 	  sizeof((ext4_inode)->field))			\
 	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
-	    le16_to_cpu((ext4_inode)->i_extra_isize)))	\
+	    (einode)->i_extra_isize))			\
 
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
@@ -378,24 +378,40 @@ static inline void ext4_decode_extra_tim
        time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
 }
 
-#define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)	   		       \
+#define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
 do {									       \
-	if (EXT4_FITS_IN_INODE(raw_inode, xtime))			       \
-        	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);       \
-	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+       	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);	       \
+	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
 		(raw_inode)->xtime ## _extra =				       \
 				ext4_encode_extra_time(&(inode)->xtime);       \
 } while (0)
 
-#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)		  	       \
+#define EXT4_EINODE_SET_XTIME(xtime, einode, raw_inode)	   		       \
 do {									       \
-	if (EXT4_FITS_IN_INODE(raw_inode, xtime))                              \
-		(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);       \
-	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
+        	(raw_inode)->xtime = cpu_to_le32((einode)->xtime.tv_sec);      \
+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
+		(raw_inode)->xtime ## _extra =				       \
+				ext4_encode_extra_time(&(einode)->xtime);      \
+} while (0)
+
+#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
+do {									       \
+	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
+	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
 		ext4_decode_extra_time(&(inode)->xtime,			       \
 				       raw_inode->xtime ## _extra);	       \
 } while (0)
 
+#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
+do {									       \
+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
+		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
+		ext4_decode_extra_time(&(einode)->xtime,		       \
+				       raw_inode->xtime ## _extra);	       \
+} while (0)
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
