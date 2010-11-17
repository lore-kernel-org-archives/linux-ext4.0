From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ext4: missing unlock in ext4_clear_request_list()
Date: Wed, 17 Nov 2010 08:07:32 +0300
Message-ID: <20101117050732.GB31724@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0KQFIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Nov 2010 00:08:35 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the the li_request_list was empty then it returned with the lock
held.  Instead of adding a "goto unlock" I just removed that special
case and let it go past the empty list_for_each_safe().

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This is a static checker patch.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..ef09d14 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2799,9 +2799,6 @@ static void ext4_clear_request_list(void)
 	struct ext4_li_request *elr;
 
 	mutex_lock(&ext4_li_info->li_list_mtx);
-	if (list_empty(&ext4_li_info->li_request_list))
-		return;
