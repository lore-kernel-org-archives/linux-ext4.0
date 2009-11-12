From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [BUILD FAILURE][PATCH] Export symbol log_start_commit. ext3 needs it.
Date: Thu, 12 Nov 2009 11:06:52 +0530
Message-ID: <200911121106.52555.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZKLFeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 00:34:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The linus git fails to build with the message
ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
Top commit id: aa021baa3295fa6e3f367d80f8955dd5176656eb

Export log_start_commit to modules. ext3 needs it to be built
as a module.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 49d5cd6..2e13cf3 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -72,6 +72,7 @@ EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
 EXPORT_SYMBOL(journal_clear_err);
+EXPORT_SYMBOL(log_start_commit);
 EXPORT_SYMBOL(log_wait_commit);
 EXPORT_SYMBOL(journal_start_commit);
 EXPORT_SYMBOL(journal_force_commit_nested);
