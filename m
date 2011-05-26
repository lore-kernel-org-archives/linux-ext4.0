From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: Add MAINTAINERS entry
Date: Thu, 26 May 2011 09:53:54 -0400
Message-ID: <1306418034-31252-1-git-send-email-tytso@mit.edu>
References: <20110523223207.GL4716@quack.suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57198 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab1EZNx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 09:53:57 -0400
In-Reply-To: <20110523223207.GL4716@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a separate MAINTAINERS entry for jbd2

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 MAINTAINERS |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649600c..0682c0e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3552,9 +3552,16 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
-F:	fs/jbd*/
-F:	include/linux/ext*jbd*.h
-F:	include/linux/jbd*.h
+F:	fs/jbd/
+F:	include/linux/ext3_jbd.h
+F:	include/linux/jbd.h
+
+JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
+M:	"Theodore Ts'o" <tytso@mit.edu>
+L:	linux-ext4@vger.kernel.org
+S:	Maintained
+F:	fs/jbd2/
+F:	include/linux/jbd2.h
 
 JSM Neo PCI based serial card
 M:	Breno Leitao <leitao@linux.vnet.ibm.com>
-- 
1.7.3.1

