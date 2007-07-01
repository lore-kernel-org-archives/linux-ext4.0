From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version on
	ext4 on-disk inode
Date: Sun, 01 Jul 2007 03:37:16 -0400
Message-ID: <1183275436.4010.127.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -342,6 +342,7 @@ struct ext4_inode {
 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
+	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
 };

 #define i_size_high	i_dir_acl
