From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 43/51] libext2fs: Dump feature flags for jbd2 v2 checksums
Date: Tue, 13 Dec 2011 17:18:02 -0800
Message-ID: <20111214011802.20947.23937.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55969 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab1LNBSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:18:09 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:18:09 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1I5ZP3649618
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:18:05 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1I3gM019505
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 23:18:04 -0200
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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

