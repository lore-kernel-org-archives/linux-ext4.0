From: Dave Jones <davej@redhat.com>
Subject: [PATCH] Add missing brelse to xattr code.
Date: Wed, 6 Nov 2013 10:45:46 -0500
Message-ID: <20131106154546.GA27255@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3KFPpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Nov 2013 10:45:54 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rA6Fjrtv022608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Nov 2013 10:45:54 -0500
Received: from gelk.kernelslacker.org (ovpn-113-175.phx2.redhat.com [10.3.113.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id rA6Fjl5F021241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Nov 2013 10:45:53 -0500
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id rA6Fjlua027501
	for <linux-ext4@vger.kernel.org>; Wed, 6 Nov 2013 10:45:47 -0500
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id rA6Fjkb8027500
	for linux-ext4@vger.kernel.org; Wed, 6 Nov 2013 10:45:46 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This code was recently patched to not leak memory on the retry path,
but it seems we are also forgetting to brelse the bufferhead.
   
Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 03e9bebba198..1423c4816a47 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1352,6 +1352,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;
