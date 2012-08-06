From: Jim Keniston <jkenisto@us.ibm.com>
Subject: [PATCH] e2fsprogs: e2fsck_handle_read_error - pass along negative
	count
Date: Mon, 06 Aug 2012 13:05:53 -0700
Message-ID: <20120806200553.9312.52751.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: ddstreet@us.ibm.com, mcao@us.ibm.com, alexfr@il.ibm.com
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40466 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2HFUIy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 16:08:54 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <jkenisto@us.ibm.com>;
	Mon, 6 Aug 2012 16:08:52 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 26DAE38C80C0
	for <linux-ext4@vger.kernel.org>; Mon,  6 Aug 2012 16:05:57 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q76K5uP8340204
	for <linux-ext4@vger.kernel.org>; Mon, 6 Aug 2012 16:05:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q76K5tYC027625
	for <linux-ext4@vger.kernel.org>; Mon, 6 Aug 2012 17:05:55 -0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When passed a negative count (indicating a byte count rather than
a block count) e2fsck_handle_read_error() treats the data as a full
block, causing unix_write_blk64() (which can handle negative counts
just fine) to try to write too much.  Given a faulty block device,
this resulted in a SEGV when unix_write_blk64() read past the bottom
of the stack copying the data to cache.  (check_backup_super_block ->
unix_read_blk64 -> raw_read_blk -> e2fsck_handle_read_error)

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Dan Streetman <ddstreet@us.ibm.com>
Reviewed-by: Mingming Cao <mcao@us.ibm.com>
Reported-by: Alex Friedman <alexfr@il.ibm.com>
---

 e2fsck/ehandler.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/ehandler.c b/e2fsck/ehandler.c
index 6eecf33..6dddf9c 100644
--- a/e2fsck/ehandler.c
+++ b/e2fsck/ehandler.c
@@ -60,7 +60,7 @@ static errcode_t e2fsck_handle_read_error(io_channel channel,
 	preenhalt(ctx);
 	if (ask(ctx, _("Ignore error"), 1)) {
 		if (ask(ctx, _("Force rewrite"), 1))
-			io_channel_write_blk64(channel, block, 1, data);
+			io_channel_write_blk64(channel, block, count, data);
 		return 0;
 	}
 

