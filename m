From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/7] e2fsck: add SIGABRT to list of signals processed by sigcatcher
Date: Mon, 30 Jul 2012 17:47:36 -0400
Message-ID: <1343684862-13181-1-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42141 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab2G3Vro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:44 -0400
In-Reply-To: <20120628024356.GB17989@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/sigcatcher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/sigcatcher.c b/e2fsck/sigcatcher.c
index 10b9328..bd56c3f 100644
--- a/e2fsck/sigcatcher.c
+++ b/e2fsck/sigcatcher.c
@@ -387,6 +387,7 @@ void sigcatcher_setup(void)
 	sigaction(SIGILL, &sa, 0);
 	sigaction(SIGBUS, &sa, 0);
 	sigaction(SIGSEGV, &sa, 0);
+	sigaction(SIGABRT, &sa, 0);
 }	
 
 
-- 
1.7.12.rc0.22.gcdd159b

