From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Update documentation about quota mount options
Date: Thu, 17 Sep 2009 17:43:24 +0200
Message-ID: <1253202204-1510-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbZIQPnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 11:43:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/ext4.txt |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 7be02ac..e7ec3ad 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -263,10 +263,18 @@ resuid=n		The user ID which may use the reserved blocks.
 
 sb=n			Use alternate superblock at this location.
 
-quota
-noquota
-grpquota
-usrquota
+quota			These options are ignored by the filesystem. They
+noquota			are used only by quota tools to recognize volumes
+grpquota		where quota should be turned on. See documentation
+usrquota		in the quota-tools package for more details
+			(http://sourceforge.net/projects/linuxquota).
+
+jqfmt=<quota type>	These options tell filesystem details about quota
+usrjquota=<file>	so that quota information can be properly updated
+grpjquota=<file>	during journal replay. They replace the above
+			quota options. See documentation in the quota-tools
+			package for more details
+			(http://sourceforge.net/projects/linuxquota).
 
 bh		(*)	ext4 associates buffer heads to data pages to
 nobh			(a) cache disk block mapping information
-- 
1.6.0.2

