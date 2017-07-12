From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: in ext4_seek_{hole,data}, return -ENXIO for negative
 offsets
Date: Wed, 12 Jul 2017 10:32:32 -0700
Message-ID: <20170712173232.GB4212@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mateusz S <muttdini@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29733 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753913AbdGLRch (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jul 2017 13:32:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

NOTE: The pending iomap SEEK_HOLE/DATA conversion patch will make all this
obsolete; this is a fix more appropriate for pre-4.13 ext4.
---
In the ext4 implementations of SEEK_HOLE and SEEK_DATA, make sure we
return -ENXIO for negative offsets instead of banging around inside
the extent code and returning -EFSCORRUPTED.

Reported-by: Mateusz S <muttdini@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 02ce7e7..923e765 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -576,7 +576,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 	inode_lock(inode);
 
 	isize = i_size_read(inode);
-	if (offset >= isize) {
+	if (offset < 0 || offset >= isize) {
 		inode_unlock(inode);
 		return -ENXIO;
 	}
@@ -639,7 +639,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 	inode_lock(inode);
 
 	isize = i_size_read(inode);
-	if (offset >= isize) {
+	if (offset < 0 || offset >= isize) {
 		inode_unlock(inode);
 		return -ENXIO;
 	}
