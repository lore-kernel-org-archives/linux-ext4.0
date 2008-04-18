From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers
Date: Fri, 18 Apr 2008 22:38:12 +0900
Message-ID: <4808A444.1080507@hitachi.com>
References: <48089B86.5020108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755520AbYDRNic@vger.kernel.org>
In-Reply-To: <48089B86.5020108@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

Index: linux-2.6.25/fs/jbd/commit.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/commit.c
+++ linux-2.6.25/fs/jbd/commit.c
@@ -716,6 +716,9 @@ wait_for_iobuf:
 		__brelse(bh);
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
 	jbd_debug(3, "JBD: commit phase 5\n");
