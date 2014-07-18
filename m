From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/24] e4defrag: backwards-allocated files should be
 defragmented too
Date: Fri, 18 Jul 2014 15:52:09 -0700
Message-ID: <20140718225209.31374.76567.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35344 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbaGRWwZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:25 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, e4defrag avoids increasing file fragmentation by comparing
the number of runs of physical extents of both the original and the
donor files.  Unfortunately, there is a bug in the routine that counts
physical extents, since it doesn't look at the logical block offsets
of the extents.  Therefore, a file whose blocks were allocated in
reverse order will be seen as only having one big physical extent, and
therefore will not be defragmented.

Fix the counting routine to consider logical extent offset so that we
defragment backwards-allocated files.  This could be problematic if we
ever gain the ability to lay out logically sparse extents in a
physically contiguous manner, but presumably one wouldn't call defrag
on such a file.

Reported-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e4defrag.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index a204793..d0eac60 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -888,7 +888,9 @@ static int get_physical_count(struct fiemap_extent_list *physical_list_head)
 
 	do {
 		if ((ext_list_tmp->data.physical + ext_list_tmp->data.len)
-				!= ext_list_tmp->next->data.physical) {
+				!= ext_list_tmp->next->data.physical ||
+		    (ext_list_tmp->data.logical + ext_list_tmp->data.len)
+				!= ext_list_tmp->next->data.logical) {
 			/* This extent and next extent are not continuous. */
 			ret++;
 		}

