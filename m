From: Jan Kara <jack@suse.cz>
Subject: [PATCH] MAINTAINERS: Update entries of ext2 and ext3
Date: Mon, 19 Jul 2010 15:05:44 +0200
Message-ID: <1279544744-21737-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <andreas.dilger@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab0GSNGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jul 2010 09:06:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I often handle ext2 and ext3 patches these days so add myself to MAINTAINERS.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andreas Dilger <andreas.dilger@oracle.com>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

 Guys, is this change OK with you?

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ff3d96..e04e9d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2222,6 +2222,7 @@ S:	Maintained
 F:	drivers/net/eth16i.c
 
 EXT2 FILE SYSTEM
+M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext2.txt
@@ -2229,6 +2230,7 @@ F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
+M:	Jan Kara <jack@suse.cz>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Andreas Dilger <adilger.kernel@dilger.ca>
 L:	linux-ext4@vger.kernel.org
-- 
1.6.4.2

