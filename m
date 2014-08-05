From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/21] e2fsck: don't set prev after processing '..' on an
 inline dir
Date: Mon, 04 Aug 2014 18:07:09 -0700
Message-ID: <20140805010709.2611.18449.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44565 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHEBHO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:07:14 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In an inline directory, the '..' entry is compacted down to just the
inode number; there is no full '..' entry.  Therefore, it makes no
sense to assign 'prev' to the fake dotdot entry we put on the stack,
as this could confuse a salvage_directory call on a corrupted next
entry into modifying stack contents (the fake dotdot entry).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index ed2c4d7..fb98af5 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1330,8 +1330,19 @@ skip_checksum:
 		if (!inline_data_size || dot_state > 1) {
 			offset += rec_len;
 		} else {
-			if (dot_state == 1)
+			if (dot_state == 1) {
 				offset = 4;
+				/*
+				 * If we get here, we're checking an inline
+				 * directory and we've just checked a (fake)
+				 * dotdot entry that we created on the stack.
+				 * Therefore set 'prev' to NULL so that if we
+				 * call salvage_directory on the next entry,
+				 * it won't try to absorb the next entry into
+				 * the on-stack dotdot entry.
+				 */
+				prev = NULL;
+			}
 		}
 		dot_state++;
 	} while (is_last_entry(fs, inline_data_size, offset, de_csum_size));

