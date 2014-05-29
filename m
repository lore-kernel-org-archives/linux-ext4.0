From: Eric Sandeen <sandeen@redhat.com>
Subject: {PATCH] e2fsprogs: fix printf format in print_blocks_proc()
Date: Thu, 29 May 2014 13:09:10 -0500
Message-ID: <538777C6.7080001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256AbaE2SJL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 14:09:11 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4TI9ASV008134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 14:09:10 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s4TI99dE009190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 14:09:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blockcnt is of type e2_blkcnt_t, which is:

typedef __s64 __bitwise         e2_blkcnt_t;

so use %lld not %d to print it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/tst_libext2fs.c b/lib/ext2fs/tst_libext2fs.c
index 1f63eb7..b4fb7f2 100644
--- a/lib/ext2fs/tst_libext2fs.c
+++ b/lib/ext2fs/tst_libext2fs.c
@@ -37,7 +37,7 @@ static int print_blocks_proc(ext2_filsys fs EXT2FS_ATTR((unused)),
 			     blk64_t ref_block, int ref_offset,
 			     void *private EXT2FS_ATTR((unused)))
 {
-	printf("%6d %8llu (%d %llu)\n", blockcnt, *blocknr,
+	printf("%6lld %8llu (%d %llu)\n", (long long)blockcnt, *blocknr,
 	       ref_offset, ref_block);
 	return 0;
 }	
