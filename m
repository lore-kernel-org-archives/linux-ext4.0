From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [PATCH] ext3 sequential read regression fix
Date: Fri, 15 Sep 2006 09:07:18 -0700
Message-ID: <1158336439.31501.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:47034 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751532AbWIOQDv
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 12:03:51 -0400
To: akpm@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext3-get-blocks support caused ~20% degrade in Sequential read
performance (tiobench). Problem is with marking the buffer boundary
so IO can be submitted right away. Here is the patch to fix it.

2.6.18-rc6:
-----------
# ./iotest
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB) copied, 75.2726 seconds, 57.1 MB/s

real    1m15.285s
user    0m0.276s
sys     0m3.884s


2.6.18-rc6 + fix:
-----------------
[root@elm3a241 ~]# ./iotest
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB) copied, 62.9356 seconds, 68.2 MB/s


The boundary block check in ext3_get_blocks_handle needs to be adjusted
against the count of blocks mapped in this call, now that it can map
more than one block.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Tested-by: Badari Pulavarty <pbadari@us.ibm.com>

 linux-2.6.18-rc5-suparna/fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-multiblock-boundary-fix fs/ext3/inode.c
--- linux-2.6.18-rc5/fs/ext3/inode.c~ext3-multiblock-boundary-fix	2006-09-15 10:53:12.000000000 +0530
+++ linux-2.6.18-rc5-suparna/fs/ext3/inode.c	2006-09-15 10:54:30.000000000 +0530
@@ -925,7 +925,7 @@ int ext3_get_blocks_handle(handle_t *han
 	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
-	if (blocks_to_boundary == 0)
+	if (count > blocks_to_boundary)
 		set_buffer_boundary(bh_result);
 	err = count;
 	/* Clean up and exit */



