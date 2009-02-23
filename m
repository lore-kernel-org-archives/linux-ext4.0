From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] * request_tbl.c (ss_add_request_table): Avoid leak upon failed realloc.
Date: Mon, 23 Feb 2009 18:26:05 +0100
Message-ID: <87ocwtcbf6.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33291 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZBWR0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 12:26:16 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id B491C81818B
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 18:26:08 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 8E03B8182BC
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 18:26:05 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Jim Meyering <meyering@redhat.com>
---
Here's another found via inspection.
It looks like it can only affect debugfs.

 lib/ss/request_tbl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/ss/request_tbl.c b/lib/ss/request_tbl.c
index 4027af8..4632d65 100644
--- a/lib/ss/request_tbl.c
+++ b/lib/ss/request_tbl.c
@@ -27,18 +27,19 @@ void ss_add_request_table(sci_idx, rqtbl_ptr, position, code_ptr)
 {
 	register ss_data *info;
 	register int i, size;
+	ssrt **t;

 	info = ss_info(sci_idx);
 	for (size=0; info->rqt_tables[size] != (ssrt *)NULL; size++)
 		;
 	/* size == C subscript of NULL == #elements */
 	size += 2;		/* new element, and NULL */
-	info->rqt_tables = (ssrt **)realloc(info->rqt_tables,
-					    (unsigned)size*sizeof(ssrt));
-	if (info->rqt_tables == (ssrt **)NULL) {
+	t = (ssrt **)realloc(info->rqt_tables, (unsigned)size*sizeof(ssrt));
+	if (t == (ssrt **)NULL) {
 		*code_ptr = errno;
 		return;
 	}
+	info->rqt_tables = t;
 	if (position > size - 2)
 		position = size - 2;

--
1.6.2.rc1.266.g4bdf
