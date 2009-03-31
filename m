From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next] ext4: fix printk format warning in inode.c
Date: Tue, 31 Mar 2009 15:54:51 +0400
Message-ID: <20090331115451.GA3475@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:10615 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZCaLzB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 07:55:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/inode.c:385: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'long int'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1d37d14..2fda129 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -382,7 +382,7 @@ static int __ext4_check_blockref(const char *function, struct inode *inode,
 				   "block reference %u >= max (%u) "
 				   "in inode #%lu, offset=%u",
 				   *bref, maxblocks,
-				   inode->i_ino, bref-p);
+				   inode->i_ino, (unsigned)(bref-p));
  			return -EIO;
  		}
 		bref++;
