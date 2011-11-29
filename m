From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 43/50] libext2fs: Add feature flags for jbd2 v2 checksums
Date: Mon, 28 Nov 2011 16:32:51 -0800
Message-ID: <20111129003251.17953.25950.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56178 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab1K2Adh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:33:37 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:33:35 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0WxQh349158
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:32:59 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0Wrav016860
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:32:59 -0500
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the necessary structure fields, flags, and constants that are needed to
extend checksum coverage to all journal metadata blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/e2p/feature.c       |    2 ++
 lib/ext2fs/kernel-jbd.h |   12 ++++++++----
 misc/dumpe2fs.c         |   29 +++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 4 deletions(-)


diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index dc52ba7..f85ed14 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -98,6 +98,8 @@ static struct feature jrnl_feature_list[] = {
                        "journal_incompat_revoke" },
        {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_ASYNC_COMMIT,
                        "journal_async_commit" },
+       {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_CSUM_V2,
+                       "journal_checksum_v2" },
        {       0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 066c031..08479d3 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -114,6 +114,7 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 
@@ -205,7 +206,10 @@ typedef struct journal_superblock_s
 	__u32	s_max_trans_data;	/* Limit of data blocks per trans. */
 
 /* 0x0050 */
-	__u32	s_padding[44];
+	__u8	s_checksum_type;	/* checksum type */
+	__u8	s_padding2[3];
+	__u32	s_padding[42];
+	__u32	s_checksum;		/* crc32c(superblock) */
 
 /* 0x0100 */
 	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
@@ -224,18 +228,18 @@ typedef struct journal_superblock_s
 
 #define JFS_FEATURE_COMPAT_CHECKSUM	0x00000001
 
-#define JFS_FEATURE_INCOMPAT_REVOKE	0x00000001
-
 #define JFS_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JFS_FEATURE_INCOMPAT_64BIT		0x00000002
 #define JFS_FEATURE_INCOMPAT_ASYNC_COMMIT	0x00000004
+#define JFS_FEATURE_INCOMPAT_CSUM_V2		0x00000008
 
 /* Features known to this kernel version: */
 #define JFS_KNOWN_COMPAT_FEATURES	0
 #define JFS_KNOWN_ROCOMPAT_FEATURES	0
 #define JFS_KNOWN_INCOMPAT_FEATURES	(JFS_FEATURE_INCOMPAT_REVOKE|\
 					 JFS_FEATURE_INCOMPAT_ASYNC_COMMIT|\
-					 JFS_FEATURE_INCOMPAT_64BIT)
+					 JFS_FEATURE_INCOMPAT_64BIT|\
+					 JFS_FEATURE_INCOMPAT_CSUM_V2)
 
 #ifdef __KERNEL__
 
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 33c0933..a9cec88 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -313,6 +313,16 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 	ext2fs_badblocks_list_free(bb_list);
 }
 
+static char *journal_checksum_type_str(__u8 type)
+{
+	switch (type) {
+	case JBD2_CRC32C_CHKSUM:
+		return "crc32c";
+	default:
+		return "unknown";
+	}
+}
+
 static void print_inline_journal_information(ext2_filsys fs)
 {
 	journal_superblock_t	*jsb;
@@ -379,6 +389,15 @@ static void print_inline_journal_information(ext2_filsys fs)
 	       (unsigned int)ntohl(jsb->s_maxlen),
 	       (unsigned int)ntohl(jsb->s_sequence),
 	       (unsigned int)ntohl(jsb->s_start));
+	if (jsb->s_feature_compat &
+	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
+		printf(_("Journal checksum type:    crc32\n"));
+	if (jsb->s_feature_incompat &
+	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
+		printf(_("Journal checksum type:    %s\n"
+			 "Journal checksum:         0x%08x\n"),
+		       journal_checksum_type_str(jsb->s_checksum_type),
+		       ext2fs_be32_to_cpu(jsb->s_checksum));
 }
 
 static void print_journal_information(ext2_filsys fs)
@@ -404,6 +423,16 @@ static void print_journal_information(ext2_filsys fs)
 		exit(1);
 	}
 
+	if (jsb->s_feature_compat &
+	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
+		printf(_("Journal checksum type:    crc32\n"));
+	if (jsb->s_feature_incompat &
+	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
+		printf(_("Journal checksum type:    %s\n"
+			 "Journal checksum:         0x%08x\n"),
+		       journal_checksum_type_str(jsb->s_checksum_type),
+		       ext2fs_be32_to_cpu(jsb->s_checksum));
+
 	printf(_("\nJournal block size:       %u\n"
 		 "Journal length:           %u\n"
 		 "Journal first block:      %u\n"

