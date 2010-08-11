From: Christoph Fritz <chf.fritz@googlemail.com>
Subject: [PATCH] jbd2: fix warning if CONFIG_JBD2_DEBUG is not used
Date: Wed, 11 Aug 2010 03:39:02 +0200
Message-ID: <1281490742.4423.10.camel@lovely.krouter>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	dingdinghua <dingdinghua@nrchpc.ac.cn>,
	Joel Becker <joel.becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>, linux-ext4@vger.kernel.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34581 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab0HKBfd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2010 21:35:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 8dd420466c7bfc459fa04680bd5690bfc41a4553 makes variable ts unuse=
d
when CONFIG_JBD2_DEBUG is not used. This patch ifdefs it too.

fs/jbd2/transaction.c: In function =A1start_this_handle=A2:
fs/jbd2/transaction.c:98: warning: unused variable =A1ts=A2

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 fs/jbd2/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index d95cc9d..745d3b2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -95,7 +95,9 @@ static int start_this_handle(journal_t *journal, hand=
le_t *handle,
 	int needed;
 	int nblocks =3D handle->h_buffer_credits;
 	transaction_t *new_transaction =3D NULL;
+#ifdef CONFIG_JBD2_DEBUG
 	unsigned long ts =3D jiffies;
+#endif
=20
 	if (nblocks > journal->j_max_transaction_buffers) {
 		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
--=20
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
