Return-Path: <SRS0=F8b5=2I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA3C43603
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Dec 2019 11:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE2F4206E0
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Dec 2019 11:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfLRLTl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:19:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfLRLTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Dec 2019 06:19:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A381DB1B5;
        Wed, 18 Dec 2019 11:19:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 9A65D1E0B2D; Wed, 18 Dec 2019 12:12:13 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Paul Richards <paul.richards@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Clarify impact of 'commit' mount option
Date:   Wed, 18 Dec 2019 12:12:10 +0100
Message-Id: <20191218111210.14161-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The description of 'commit' mount option dates back to ext3 times.
Update the description to match current meaning for ext4.

Reported-by: Paul Richards <paul.richards@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/admin-guide/ext4.rst | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index 059ddcbe769d..8d292f5aaea3 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -181,14 +181,17 @@ When mounting an ext4 filesystem, the following option are accepted:
         system after its metadata has been committed to the journal.
 
   commit=nrsec	(*)
-        Ext4 can be told to sync all its data and metadata every 'nrsec'
-        seconds. The default value is 5 seconds.  This means that if you lose
-        your power, you will lose as much as the latest 5 seconds of work (your
-        filesystem will not be damaged though, thanks to the journaling).  This
-        default value (or any low value) will hurt performance, but it's good
-        for data-safety.  Setting it to 0 will have the same effect as leaving
-        it at the default (5 seconds).  Setting it to very large values will
-        improve performance.
+	This setting limits the maximum age of the running transaction to
+	'nrsec' seconds.  The default value is 5 seconds.  This means that if
+	you lose your power, you will lose as much as the latest 5 seconds of
+	metadata changes (your filesystem will not be damaged though, thanks
+	to the journaling). This default value (or any low value) will hurt
+	performance, but it's good for data-safety.  Setting it to 0 will have
+	the same effect as leaving it at the default (5 seconds).  Setting it
+	to very large values will improve performance.  Note that due to
+	delayed allocation even older data can be lost on power failure since
+        writeback of those data begins only after time set in
+        /proc/sys/vm/dirty_expire_centisecs.  
 
   barrier=<0|1(*)>, barrier(*), nobarrier
         This enables/disables the use of write barriers in the jbd code.
-- 
2.16.4

