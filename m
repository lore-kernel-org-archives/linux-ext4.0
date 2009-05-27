From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/11] vfs: Export wakeup_pdflush
Date: Wed, 27 May 2009 15:01:07 +0200
Message-ID: <1243429268-3028-11-git-send-email-jack@suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
Cc: npiggin@suse.de, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763400AbZE0NBO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 09:01:14 -0400
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we are running out of free space on a filesystem, we want to flush dirty
pages in the filesystem so that blocks reserved via delayed allocation get
written and unnecessary block reservation is released. Export wakeup_pdflush()
so that filesystem can start such writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bb553c3..43af1cf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -730,6 +730,7 @@ int wakeup_pdflush(long nr_pages)
 				global_page_state(NR_UNSTABLE_NFS);
 	return pdflush_operation(background_writeout, nr_pages);
 }
+EXPORT_SYMBOL(wakeup_pdflush);
 
 static void wb_timer_fn(unsigned long unused);
 static void laptop_timer_fn(unsigned long unused);
-- 
1.6.0.2

