From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 43/51] libext2fs: Dump feature flags for jbd2 v2 checksums
Date: Sat, 07 Jan 2012 00:37:31 -0800
Message-ID: <20120107083731.25788.56216.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e35.co.us.ibm.com ([32.97.110.153]:40138 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2AGIiI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2012 03:38:08 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 01:38:07 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078bYda144894
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:37:34 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078bWA7029144
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:37:34 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Modify the dump code to print information about jbd2 v2 checksum data.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/e2p/feature.c |    2 ++
 misc/dumpe2fs.c   |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)


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
 
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 23dec30..b8f386e 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -311,6 +311,16 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
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
@@ -377,6 +387,15 @@ static void print_inline_journal_information(ext2_filsys fs)
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
@@ -402,6 +421,16 @@ static void print_journal_information(ext2_filsys fs)
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

