From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 03/50] debugfs: Optionally ignore bad checksums
Date: Mon, 28 Nov 2011 16:28:17 -0800
Message-ID: <20111129002817.17953.11012.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57299 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1K2A2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:28:55 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:28:55 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0SKO53248380
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:28:20 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0SIW0030105
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:28:20 -0500
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If someone is debugging a badly damaged filesystem, it might be useful to
disable the checksum verifications that will otherwise prevent the filesystem
from loading.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.8.in |    7 ++++++-
 debugfs/debugfs.c    |    7 +++++--
 2 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 70c8326..310dae2 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -8,7 +8,7 @@ debugfs \- ext2/ext3/ext4 file system debugger
 .SH SYNOPSIS
 .B debugfs
 [
-.B \-DVwci
+.B \-DVwcin
 ]
 [
 .B \-b
@@ -48,6 +48,11 @@ file system (e.g /dev/hdXX).
 Specifies that the file system should be opened in read-write mode.
 Without this option, the file system is opened in read-only mode.
 .TP
+.I \-n
+Disables metadata checksum verification.  This should only be used if
+you believe the metadata to be correct despite the complaints of
+e2fsprogs.
+.TP
 .I \-c
 Specifies that the file system should be opened in catastrophic mode, in
 which the inode and group bitmaps are not read initially.  This can be
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index b7ff00d..419c76c 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2300,9 +2300,9 @@ int main(int argc, char **argv)
 	int		catastrophic = 0;
 	char		*data_filename = 0;
 #ifdef READ_ONLY
-	const char	*opt_string = "icR:f:b:s:Vd:D";
+	const char	*opt_string = "nicR:f:b:s:Vd:D";
 #else
-	const char	*opt_string = "iwcR:f:b:s:Vd:D";
+	const char	*opt_string = "niwcR:f:b:s:Vd:D";
 #endif
 
 	if (debug_prog_name == 0)
@@ -2329,6 +2329,9 @@ int main(int argc, char **argv)
 		case 'i':
 			open_flags |= EXT2_FLAG_IMAGE_FILE;
 			break;
+		case 'n':
+			open_flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			break;
 #ifndef READ_ONLY
 		case 'w':
 			open_flags |= EXT2_FLAG_RW;

