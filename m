From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH][e2fsprogs] Allow user to disable Undo manager through
	MKE2FS_SCRATCH_DIR
Date: Fri, 04 Apr 2008 09:02:35 -0500
Message-ID: <20080404140235.28080.97243.stgit@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36422 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYDDOCy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 10:02:54 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m34E2rUB019491
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 10:02:53 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m34E2ruo163646
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 08:02:53 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m34E2h6f019984
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 08:02:43 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Allow user to disable Undo manager through MKE2FS_SCRATCH_DIR

Undo manager is a bit annoying when doing e2fsprogs testing since it
makes mke2fs significatly slower.  Use the MKE2FS_SCRATCH_DIR=disable
enviroment value to disable undo manager for those of us that blow up
filesystems on a regular basis.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 misc/mke2fs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c8170f0..3f9cbe2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1802,6 +1802,13 @@ static int filesystem_exist(const char *name)
 	__u16	s_magic;
 	struct ext2_super_block super;
 	io_manager manager = unix_io_manager;
+	char *tdb_dir;
+
+	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
+	if (tdb_dir && !strcmp(tdb_dir, "disable")) {
+		retval = 0;
+		goto open_err_out;
+	}
 
 	retval = manager->open(name, IO_FLAG_EXCLUSIVE,  &channel);
 	if (retval) {

