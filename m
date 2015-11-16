From: Jan Kara <jack@suse.com>
Subject: [PATCH] chattr: Fix typo in a manpage
Date: Mon, 16 Nov 2015 13:33:48 +0100
Message-ID: <1447677228-6340-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbbKPMd6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2015 07:33:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.com>
---
 misc/chattr.1.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 33ef9a20f591..1d6b057a45ac 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -93,7 +93,7 @@ set on new or empty files.  If it is set on a file which already has
 data blocks, it is undefined when the blocks assigned to the file will
 be fully stable.  If the 'C' flag is set on a directory, it will have no
 effect on the directory, but new files created in that directory will
-the No_COW attribute.)
+have the No_COW attribute set.)
 .PP
 A file with the 'd' attribute set is not candidate for backup when the
 .BR dump (8)
-- 
2.1.4

