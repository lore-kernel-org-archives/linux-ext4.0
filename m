From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers (rebased)
Date: Wed, 14 May 2008 13:49:51 +0900
Message-ID: <482A6F6F.20002@hitachi.com>
References: <482A6E00.6080303@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38483 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYENEt4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 00:49:56 -0400
In-Reply-To: <482A6E00.6080303@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc2/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc2.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc2/fs/jbd/commit.c
@@ -703,6 +703,9 @@ wait_for_iobuf:
 		__brelse(bh);
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
 	jbd_debug(3, "JBD: commit phase 5\n");


