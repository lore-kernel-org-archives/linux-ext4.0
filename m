From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] ext4: Pack ioend structure better
Date: Fri, 19 Feb 2016 16:59:37 +0100
Message-ID: <1455897582-13292-2-git-send-email-jack@suse.cz>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947678AbcBSP71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 10:59:27 -0500
In-Reply-To: <1455897582-13292-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 64-bit architectures we have two 4-byte holes in struct ext4_io_end.
Order entries better to avoid this and thus make the structure occupy
64 instead of 72 bytes for 64-bit architectures.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0662b285dc8a..1046621ef64d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -182,9 +182,9 @@ typedef struct ext4_io_end {
 	struct bio		*bio;		/* Linked list of completed
 						 * bios covering the extent */
 	unsigned int		flag;		/* unwritten or not */
+	atomic_t		count;		/* reference counter */
 	loff_t			offset;		/* offset in the file */
 	ssize_t			size;		/* size of the extent */
-	atomic_t		count;		/* reference counter */
 } ext4_io_end_t;
 
 struct ext4_io_submit {
-- 
2.6.2

