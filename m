From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Update ext4 MAINTAINERS file
Date: Mon,  6 Oct 2008 20:59:19 -0400
Message-ID: <1223341159-12880-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57045 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760128AbYJGA7V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 20:59:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4 entry was copied from ext3 and was never correct.  Update it
so that Theodore Ts'o is listed as the maintainer, and point the
website to http://ext4.wiki.kernel.org.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..e10ebd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1641,9 +1641,10 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 EXT4 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
+P:	Theodore Ts'o
+M:	tytso@mit.edu, adilger@sun.com
 L:	linux-ext4@vger.kernel.org
+W:	http://ext4.wiki.kernel.org
 S:	Maintained
 
 F71805F HARDWARE MONITORING DRIVER
-- 
1.5.6.1.205.ge2c7.dirty

