From: "Theodore Ts'o" <tytso@mit.edu>
Subject: The jbd_GFP_NORFAIL patch caused the jbd_kmalloc_kzalloc.patch fail
Date: Mon, 24 Sep 2007 10:14:33 -0400
Message-ID: <E1IZohl-0002K5-CT@tinytim.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58208 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbXIXOOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 10:14:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


While putting together 2.6.23-rc7-ext4-1 patchset, I noticed that the
jbd_GFP_NOFAIL patch caused a patch conflict with the kmalloc/kzalloc
patch.  I also fixed up the patch comments to make the git log look
prettier. 

						- Ted


    Fix up jbd k[mz]alloc patch so it applies and fix up GFP_NOFAIL comments

diff --git a/jbd_GFP_NOFAIL_flag_cleanup.patch b/jbd_GFP_NOFAIL_flag_cleanup.patch
index 8dec157..da02815 100644
--- a/jbd_GFP_NOFAIL_flag_cleanup.patch
+++ b/jbd_GFP_NOFAIL_flag_cleanup.patch
@@ -1,3 +1,8 @@
+jbd/jbd2: Journal initialization doesn't need __GFP_NOFAIL
+
+Signed-off-by: Mingming Cao <cmm@us.ibm.com>
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
+
 ---
  fs/jbd/journal.c  |    2 +-
  fs/jbd2/journal.c |    2 +-
diff --git a/jbd_kmalloc_kzalloc.patch b/jbd_kmalloc_kzalloc.patch
index a426d0e..8ca0469 100644
--- a/jbd_kmalloc_kzalloc.patch
+++ b/jbd_kmalloc_kzalloc.patch
@@ -22,7 +22,7 @@ Index: linux-2.6.23-rc6/fs/jbd/journal.c
  	journal_t *journal;
  	int err;
  
--	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+-	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 +	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
  	if (!journal)
  		goto fail;
@@ -51,7 +51,7 @@ Index: linux-2.6.23-rc6/fs/jbd2/journal.c
  	journal_t *journal;
  	int err;
  
--	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+-	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 +	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
  	if (!journal)
  		goto fail;
