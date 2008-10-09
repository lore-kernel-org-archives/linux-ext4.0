From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 40/42] Update ext4 MAINTAINERS file
Date: Thu,  9 Oct 2008 00:05:58 -0400
Message-ID: <1223525160-9887-41-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
 <1223525160-9887-24-git-send-email-tytso@mit.edu>
 <1223525160-9887-25-git-send-email-tytso@mit.edu>
 <1223525160-9887-26-git-send-email-tytso@mit.edu>
 <1223525160-9887-27-git-send-email-tytso@mit.edu>
 <1223525160-9887-28-git-send-email-tytso@mit.edu>
 <1223525160-9887-29-git-send-email-tytso@mit.edu>
 <1223525160-9887-30-git-send-email-tytso@mit.edu>
 <1223525160-9887-31-git-send-email-tytso@mit.edu>
 <1223525160-9887-32-git-send-email-tytso@mit.edu>
 <1223525160-9887-33-git-send-email-tytso@mit.edu>
 <1223525160-9887-34-git-send-email-tytso@mit.edu>
 <1223525160-9887-35-git-send-email-tytso@mit.edu>
 <1223525160-9887-36-git-send-email-tytso@mit.edu>
 <1223525160-9887-37-git-send-email-tytso@mit.edu>
 <1223525160-9887-38-git-send-email-tytso@mit.edu>
 <1223525160-9887-39-git-send-email-tytso@mit.edu>
 <1223525160-9887-40-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54507 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757572AbYJIEGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:12 -0400
In-Reply-To: <1223525160-9887-40-git-send-email-tytso@mit.edu>
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
index 8dae455..dce9cb9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1639,9 +1639,10 @@ L:	linux-ext4@vger.kernel.org
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

