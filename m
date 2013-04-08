From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/29] jbd2: Reduce journal_head size
Date: Mon,  8 Apr 2013 23:32:09 +0200
Message-ID: <1365456754-29373-5-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936270Ab3DHVdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:01 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
to be happening) and change b_modified and b_jlist to bitfields thus
saving 8 bytes in the structure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/journal-head.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index c18b46f..13a3da2 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -31,21 +31,14 @@ struct journal_head {
 	/*
 	 * Journalling list for this buffer [jbd_lock_bh_state()]
 	 */
-	unsigned b_jlist;
+	unsigned b_jlist:4;
 
 	/*
 	 * This flag signals the buffer has been modified by
 	 * the currently running transaction
 	 * [jbd_lock_bh_state()]
 	 */
-	unsigned b_modified;
