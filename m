From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/6] jbd: use WRITE_SYNC for journal I/O
Date: Fri,  2 Jul 2010 15:58:17 -0400
Message-ID: <1278100699-24132-5-git-send-email-jmoyer@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In my fsync testing, journal I/O most definitely was sync I/O, since
another process was blocked waiting for the results.  By marking all
journal I/O as WRITE_SYNC, I can get better performance with CFQ.

If there is a way to mark this only for cases where it is blocking progress
in a dependent process, then that would be preferrable.  Is there such a
means for determining and flagging this?

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/jbd/commit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 28a9dda..d97a0c6 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -317,7 +317,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
-	int write_op = WRITE;
+	int write_op = WRITE_SYNC;
 
 	/*
 	 * First job: lock down the current transaction and wait for
-- 
1.6.5.2
