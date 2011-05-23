From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH] xfsprogs: Fix for xfstest 252 hang on ext4
Date: Mon, 23 May 2011 13:34:58 -0700
Message-ID: <4DDAC4F2.9090909@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37257 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1EWUfQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 16:35:16 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4NKWHt7021579
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:32:18 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4NKZ907179226
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:35:09 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4NKZ9SS001988
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:35:09 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xfstests 252 hangs on ext4 due to a loop in xfsprogs that does not exit.  

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 fa990cc... 81fc92c... M	io/fiemap.c
 io/fiemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index fa990cc..81fc92c 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -246,7 +246,7 @@ fiemap_f(
 		       flg_w, _("FLAGS"));
 	}
 
-	while (!last && ((cur_extent + 1) != max_extents)) {
+	while (!last && (cur_extent <= max_extents)) {
 		if (max_extents)
 			num_extents = min(num_extents,
 					  max_extents - (cur_extent + 1));
-- 
1.7.1
