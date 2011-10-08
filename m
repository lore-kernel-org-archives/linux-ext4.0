From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 03/47] debugfs: Optionally ignore bad checksums
Date: Sat, 08 Oct 2011 00:33:35 -0700
Message-ID: <20111008073335.17888.24215.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:56771 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1JHHgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:36:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987Ta6e010698
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:29:36 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987Xbud168836
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:37 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987Xa82009573
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:37 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If someone is debugging a badly damaged filesystem, it might be useful to
disable the checksum verifications that will otherwise prevent the filesystem
from loading.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.8.in |    7 ++++++-
 debugfs/debugfs.c    |    5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index fe07f34..b5d208f 100644
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
index dd1435b..32a5864 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2269,7 +2269,7 @@ int main(int argc, char **argv)
 	fprintf (stderr, "%s %s (%s)\n", debug_prog_name,
 		 E2FSPROGS_VERSION, E2FSPROGS_DATE);
 
-	while ((c = getopt (argc, argv, "iwcR:f:b:s:Vd:D")) != EOF) {
+	while ((c = getopt(argc, argv, "niwcR:f:b:s:Vd:D")) != EOF) {
 		switch (c) {
 		case 'R':
 			request = optarg;
@@ -2283,6 +2283,9 @@ int main(int argc, char **argv)
 		case 'i':
 			open_flags |= EXT2_FLAG_IMAGE_FILE;
 			break;
+		case 'n':
+			open_flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			break;
 		case 'w':
 			open_flags |= EXT2_FLAG_RW;
 			break;

