From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 1/4] ext3: Fix ext3_dx_readdir hash collision handling
Date: Sat, 13 Sep 2008 11:32:48 -0400
Message-ID: <1221319971-29879-1-git-send-email-tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Eugene Dashevsky <eugene@ibrix.com>,
	Mike Snitzer <msnitzer@ibrix.com>, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50913 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYIMPc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 11:32:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a bug where readdir() would return a directory entry twice
if there was a hash collision in an hash tree indexed directory.

Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/dir.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 2eea96e..42c5391 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -410,7 +410,7 @@ static int call_filldir(struct file * filp, void * dirent,
 				get_dtype(sb, fname->file_type));
 		if (error) {
 			filp->f_pos = curr_pos;
-			info->extra_fname = fname->next;
+			info->extra_fname = fname;
 			return error;
 		}
 		fname = fname->next;
@@ -449,11 +449,21 @@ static int ext3_dx_readdir(struct file * filp,
 	 * If there are any leftover names on the hash collision
 	 * chain, return them first.
 	 */
-	if (info->extra_fname &&
-	    call_filldir(filp, dirent, filldir, info->extra_fname))
-		goto finished;
