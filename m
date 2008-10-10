From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/4] jbd2: abort when failed to log metadata buffers
Date: Fri, 10 Oct 2008 17:57:38 +0900
Message-ID: <48EF1902.5050905@hitachi.com>
References: <48EF168A.4000705@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36150 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYJJI5s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 04:57:48 -0400
In-Reply-To: <48EF168A.4000705@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

We can also avoid this kind of corruption by using check-summing
feature because it can detect invalid metadata blocks in the
journal and avoid them from being replayed.  So we don't need to
care about asynchronous commit record writeout with a check sum.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd2/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/jbd2/commit.c
+++ linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
@@ -783,6 +783,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		jbd2_journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 5\n");
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,


