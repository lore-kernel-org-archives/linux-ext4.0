From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] add the b_cow_tid field to journal_head struct
Date: Tue, 1 Mar 2011 15:52:15 +0200
Message-ID: <AANLkTikduxunBSq0z6BuXJVHXJMzeTUfexz2H71_J6BR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50307 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1CANwQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 08:52:16 -0500
Received: by qyk7 with SMTP id 7so3261702qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 05:52:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The field is used by ext4 snapshots code to store the transaction id
in which the buffer was last cowed.

Merging this patch to kernel 2.6.39, will allow users to test ext4
snapshots as a standalone module, without the need to patch and
install a development kernel.

On a 64bit machine the field is using an aliged memory padding space
and does not increase the size of the struct.

On a 32bit machine this patch increases the size of the struct from
60 to 64 bytes:

Before:
jbd2_journal_head     57    126     60   63    1 : tunables  120   60
 0 : slabdata      2      2      0

After:
jbd2_journal_head     61    118     64   59    1 : tunables  120   60
 0 : slabdata      2      2      0

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 include/linux/journal-head.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index 525aac3..44e95d0 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -41,6 +41,13 @@ struct journal_head {
 	unsigned b_modified;

 	/*
+	 * This feild tracks the last transaction id in which this buffer
+	 * has been cowed
+	 * [jbd_lock_bh_state()]
+	 */
+	unsigned b_cow_tid;
+
+	/*
 	 * Copy of the buffer data frozen for writing to the log.
 	 * [jbd_lock_bh_state()]
 	 */
-- 
1.7.0.4
