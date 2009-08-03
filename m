From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Update MAINTAINERS for ext3 and JBD
Date: Mon,  3 Aug 2009 23:06:55 +0200
Message-ID: <1249333616-23442-2-git-send-email-jack@suse.cz>
References: <1249333616-23442-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Stephen Tweedie <sct@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZHCVG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 17:06:56 -0400
In-Reply-To: <1249333616-23442-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Stephen agreed that he's unlikely to find time for working on ext3/JBD in the
near future and is not working on it for some time already. So remove him.
Added myself to JBD since after Andrew I'm probably the second most sensible
contact ;).

CC: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..31dd9b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1933,7 +1933,6 @@ F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-M:	Stephen Tweedie <sct@redhat.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
@@ -2848,8 +2847,8 @@ F:	fs/jffs2/
 F:	include/linux/jffs2.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-M:	Stephen Tweedie <sct@redhat.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd*/
-- 
1.6.0.2

