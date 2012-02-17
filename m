From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] e2image: fix logic bug which could cause a raw image not to be extended
Date: Fri, 17 Feb 2012 09:32:42 -0500
Message-ID: <1329489163-21918-1-git-send-email-tytso@mit.edu>
References: <20120217143026.GA19606@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55882 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2BQOcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 09:32:46 -0500
In-Reply-To: <20120217143026.GA19606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the size of the last "hole" in the raw file was an exact multiple
of a megabyte, then we wouldn't write a null at the end of the file in
order to extend the size of the raw image to correspond with the file
system size.  Thanks to Lukas Czerner for suggesting the fix, and
Phillip Susi for pointing out the problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index d888e5a..3cb92fe 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -504,10 +504,9 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 				continue;
 			}
 			sparse += fs->blocksize;
-			if (sparse >= 1024*1024) {
