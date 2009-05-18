From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: don't try to resize below calculated minimum
Date: Mon, 18 May 2009 17:11:28 -0500
Message-ID: <4A11DD10.2060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZERWL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 18:11:29 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4IMBVmP006549
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:11:31 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4IMBUAU008993
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:11:30 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4IMBSXZ032176
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:11:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Without a force flag, don't allow resize2fs to even start resizing
below what it thinks the minimum safe value is.

This may stop resizes which could otherwise proceed with a bit
of space still left, but seems like a reasonably safe thing to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(sorry, this should have been [PATCH 3/3] I guess, I did this
too iteratively)

Index: e2fsprogs/resize/main.c
===================================================================
--- e2fsprogs.orig/resize/main.c
+++ e2fsprogs/resize/main.c
@@ -160,6 +160,7 @@ int main (int argc, char ** argv)
 	int		fd, ret;
 	blk_t		new_size = 0;
 	blk_t		max_size = 0;
+	blk_t		min_size = 0;
 	io_manager	io_ptr;
 	char		*new_size_str = 0;
 	int		use_stride = -1;
@@ -341,9 +342,11 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
+	min_size = calculate_minimum_resize_size(fs);
+
 	if (print_min_size) {
 		printf(_("Estimated minimum size of the filesystem: %u\n"),
-		       calculate_minimum_resize_size(fs));
+		       min_size);
 		exit(0);
 	}
 
@@ -388,6 +391,11 @@ int main (int argc, char ** argv)
 			new_size &= ~((sys_page_size / fs->blocksize)-1);
 	}
 
+	if (!force && new_size < min_size) {
+		com_err(program_name, 0,
+			_("New size smaller than minimum (%u)\n"), min_size);
+		exit(1);
+	}
 	if (use_stride >= 0) {
 		if (use_stride >= (int) fs->super->s_blocks_per_group) {
 			com_err(program_name, 0,

