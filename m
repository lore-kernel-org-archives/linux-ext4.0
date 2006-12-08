From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] ext4 calls journal_stop
Date: Thu, 7 Dec 2006 22:17:41 -0800
Message-ID: <20061207221741.2012ad20.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: akpm <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:49555 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424755AbWLHGRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Dec 2006 01:17:04 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

journal_stop() is not defined for ext4; change to ext4_journal_stop().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19-git11.orig/fs/ext4/inode.c
+++ linux-2.6.19-git11/fs/ext4/inode.c
@@ -1232,7 +1232,7 @@ retry:
 				from, to, NULL, do_journal_get_write_access);
 		if (ret)
 			/* fatal error, just put the handle and return */
-			journal_stop(handle);
+			ext4_journal_stop(handle);
 	}
 	return ret;
 


---
