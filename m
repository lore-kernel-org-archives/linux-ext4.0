From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] annotate superblock field offsets
Date: Mon, 29 Nov 2010 16:45:38 -0700
Message-ID: <7258D44F-8334-4604-90EE-019F1B33B1FC@dilger.ca>
References: <bug-23772-13602@https.bugzilla.kernel.org/> <201011292155.oATLt4vX027018@demeter2.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-10--765473649
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24703 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0K2Xpk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 18:45:40 -0500
In-Reply-To: <201011292155.oATLt4vX027018@demeter2.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-10--765473649
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

The s_mount_options field has the unfortunate distinction of being the =
first field beyond 0x200 in the superblock (i.e. second sector of 1kB =
superblock area). =20

Annotate the superblock fields with offsets so that it is easier to see
these boundaries, and decode the superblock in the future.

Cheers, Andreas


--Apple-Mail-10--765473649
Content-Disposition: attachment;
	filename=ext4-super-offsets.diff
Content-Type: application/octet-stream;
	name="ext4-super-offsets.diff"
Content-Transfer-Encoding: 7bit

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..2f7cc60 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -997,37 +997,37 @@ struct ext4_super_block {
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
 	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
-	__le32	s_flags;		/* Miscellaneous flags */
+	__le16	s_want_extra_isize;	/* New inodes should reserve # bytes */
+/*160*/	__le32	s_flags;		/* Miscellaneous flags */
 	__le16  s_raid_stride;		/* RAID stride */
 	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__le64  s_mmp_block;            /* Block for multi-mount protection */
-	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
+/*170*/	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
 	__u8	s_reserved_char_pad;
 	__le16  s_reserved_pad;
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
-	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
+/*180*/	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
 	__le32	s_snapshot_id;		/* sequential ID of active snapshot */
 	__le64	s_snapshot_r_blocks_count; /* reserved blocks for active
 					      snapshot's future use */
-	__le32	s_snapshot_list;	/* inode number of the head of the
+/*190*/	__le32	s_snapshot_list;	/* inode number of the head of the
 					   on-disk snapshot list */
 #define EXT4_S_ERR_START offsetof(struct ext4_super_block, s_error_count)
 	__le32	s_error_count;		/* number of fs errors */
 	__le32	s_first_error_time;	/* first time an error happened */
 	__le32	s_first_error_ino;	/* inode involved in first error */
-	__le64	s_first_error_block;	/* block involved of first error */
-	__u8	s_first_error_func[32];	/* function where the error happened */
-	__le32	s_first_error_line;	/* line number where error happened */
+/*1a0*/	__le64	s_first_error_block;	/* block involved of first error */
+/*1a8*/	__u8	s_first_error_func[32];	/* function where the error happened */
+/*1c8*/	__le32	s_first_error_line;	/* line number where error happened */
 	__le32	s_last_error_time;	/* most recent time of an error */
-	__le32	s_last_error_ino;	/* inode involved in last error */
+/*1d0*/	__le32	s_last_error_ino;	/* inode involved in last error */
 	__le32	s_last_error_line;	/* line number where error happened */
 	__le64	s_last_error_block;	/* block involved of last error */
-	__u8	s_last_error_func[32];	/* function where the error happened */
+/*1e0*/	__u8	s_last_error_func[32];	/* function where the error happened */
 #define EXT4_S_ERR_END offsetof(struct ext4_super_block, s_mount_opts)
-	__u8	s_mount_opts[64];
-	__le32	s_reserved[112];        /* Padding to the end of the block */
+/*200*/	__u8	s_mount_opts[64];
+/*240*/	__le32	s_reserved[112];        /* Padding to the end of the block */
 };
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)

--Apple-Mail-10--765473649--
