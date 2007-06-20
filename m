From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Wed, 20 Jun 2007 17:26:20 +0530
Message-ID: <1182340580.3819.3.camel@dhcp7.linsyssoft.com>
References: <1181065733.5219.8.camel@mathur-dsktp>
	 <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int>
	 <467755D3.8030802@linux.vnet.ibm.com>
	 <20070619075034.GQ5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2sf4JJIW9dgW4T7Tjwfz"
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:37069 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbXFTL4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 07:56:18 -0400
In-Reply-To: <20070619075034.GQ5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-2sf4JJIW9dgW4T7Tjwfz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


> 
> I've asked Girish to send an incremental patch.
> 
Here is the incremental patch,  to be applied after the patch sent by
Avantika for 2.6.22-rc4 kernel.

Regards,
Girish.

--=-2sf4JJIW9dgW4T7Tjwfz
Content-Disposition: attachment; filename=update-uninit.patch
Content-Type: text/x-patch; name=update-uninit.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c
+++ linux-2.6.22-rc4/fs/ext4/super.c
@@ -1298,9 +1298,12 @@ __le16 ext4_group_desc_csum(struct ext4_
 		offset += sizeof(gdp->bg_checksum); /* skip checksum */
 		/*BUG_ON(offset != sizeof(*gdp)); /* XXX handle s_desc_size */
 		/* for checksum of struct ext4_group_desc do the rest...*/
-		if (offset < sbi->s_es->s_desc_size) {
+		if ((sbi->s_es->s_feature_incompat &
+		     cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT)) && 
+		    offset < le16_to_cpu(sbi->s_es->s_desc_size)) {
 			crc = crc16(crc, (__u8 *)gdp + offset,
-				    sbi->s_es->s_desc_size - offset);
+				    le16_to_cpu(sbi->s_es->s_desc_size)
+					- offset);
 		} 
 	}
 
Index: linux-2.6.22-rc4/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/ext4_fs.h
+++ linux-2.6.22-rc4/include/linux/ext4_fs.h
@@ -687,11 +687,11 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
-#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0040
 
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT4_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 

--=-2sf4JJIW9dgW4T7Tjwfz--
