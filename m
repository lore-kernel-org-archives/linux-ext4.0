From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/10] Fs: ext4: acl.h: whitespace cleanup
Date: Sat, 25 Sep 2010 14:31:53 -0400
Message-ID: <1285439521-2557-2-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0IYScx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Sep 2010 14:32:53 -0400
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tracey Dent <Tdent48227@gmail.com>

I cleaned up whitespaces that was having an issue with checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/acl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 9d843d5..bb225cf 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -1,7 +1,7 @@
 /*
-  File: fs/ext4/acl.h
+	File: fs/ext4/acl.h
 
-  (C) 2001 Andreas Gruenbacher, <a.gruenbacher@computer.org>
+	(C) 2001 Andreas Gruenbacher, <a.gruenbacher@computer.org>
 */
 
 #include <linux/posix_acl_xattr.h>
-- 
1.7.3

