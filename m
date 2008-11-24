From: curtw@google.com (Curt Wohlgemuth)
Subject: PATCH ext4: fix to call_filldir
Date: Mon, 24 Nov 2008 10:21:05 -0800 (PST)
Message-ID: <20081124182105.184338C977@localhost>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:26698 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYKXSVJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:21:09 -0500
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id mAOIL7sp022680
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 10:21:07 -0800
Received: from localhost (astroman.corp.google.com [172.22.64.115])
	by spaceape7.eur.corp.google.com with ESMTP id mAOIL5FE029424
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 10:21:06 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


[ Sorry: I mistakenly sent just the patch, with no explanation... ]

I happened to find a bug running bonnie++-1.03a on an ext4 filesystem, when
it complained about not being able to remove a file.

Further investigation showed a problem with call_filldir(), which is not
quite correct with respect to the same function in fs/ext3/dir.c.  The patch
below fixes this problem.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---

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
