From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/4] jbd: abort when failed to log metadata buffers
Date: Thu, 24 Jul 2008 21:37:10 +0900
Message-ID: <48887776.4080504@hitachi.com>
References: <488876D3.80004@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	adilger@clusterfs.com, snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33899 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYGXMhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 08:37:23 -0400
In-Reply-To: <488876D3.80004@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc8-mm1/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc8-mm1/fs/jbd/commit.c
@@ -762,6 +762,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 6\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))


