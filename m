From: curtw@google.com (Curt Wohlgemuth)
Subject: PATCH ext4: fix to call_filldir
Date: Mon, 24 Nov 2008 10:18:36 -0800 (PST)
Message-ID: <20081124181836.683D48C977@localhost>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:25964 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYKXSSi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:18:38 -0500
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id mAOIIb2I003608
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 10:18:37 -0800
Received: from localhost (astroman.corp.google.com [172.22.64.115])
	by wpaz37.hot.corp.google.com with ESMTP id mAOIIaM9030516
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 10:18:36 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Curt Wohlgemuth <curtw@google.com>

diff -Naur ext4/fs/ext4/dir.c b/fs/ext4/dir.c
--- ext4/fs/ext4/dir.c	2008-11-13 14:51:58.000000000 -0800
+++ b/fs/ext4/dir.c	2008-11-24 08:23:05.000000000 -0800
@@ -417,7 +417,7 @@
 				get_dtype(sb, fname->file_type));
 		if (error) {
 			filp->f_pos = curr_pos;
-			info->extra_fname = fname;
+			info->extra_fname = fname->next;
 			return error;
 		}
 		fname = fname->next;
