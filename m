From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] jbd2: free bh when descriptor block checksum fails
Date: Sun, 14 Sep 2014 10:33:05 -0700
Message-ID: <20140914173305.31996.71172.stgit@birch.djwong.org>
References: <20140914173252.31996.86784.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40558 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaINRdK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2014 13:33:10 -0400
In-Reply-To: <20140914173252.31996.86784.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Free the buffer head if the journal descriptor block fails checksum
verification.

This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
verify error in do_one_pass".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9b329b5..bcbef08 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -525,6 +525,7 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
+				brelse(bh);
 				goto failed;
 			}
 

