From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] mke2fs: fix crash when parsing "-E resize=NNN" with "-O 64bit"
Date: Sat, 29 Dec 2012 03:55:23 -0500
Message-ID: <1356771328-18196-2-git-send-email-tytso@mit.edu>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40803 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab2L2Izf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:55:35 -0500
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the 64-bit file system feature is enabled, then mke2fs would crash
due to a divide-by-zero error caused by s_desc_size not being
initialized yet.

Reported-by: George Spelvin <linux@horizon.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..0f9a299 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1873,6 +1873,14 @@ profile_error:
 
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
+	/*
+	 * Initialize s_desc_size so that the parse_extended_opts()
+	 * can correctly handle "-E resize=NNN" if the 64-bit option
+	 * is set.
+	 */
+	if (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
+
 	/* This check should happen beyond the last assignment to blocksize */
 	if (blocksize > sys_page_size) {
 		if (!force) {
-- 
1.7.12.rc0.22.gcdd159b

