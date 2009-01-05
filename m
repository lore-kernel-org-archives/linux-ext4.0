From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] jbd2: fix printk format warning
Date: Mon, 5 Jan 2009 12:11:58 -0800
Message-ID: <20090105121158.94d990c3.randy.dunlap@oracle.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	akpm <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:51895 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZAEUMr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 15:12:47 -0500
In-Reply-To: <20090105173517.deeff918.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix jbd2 printk format:

fs/jbd2/journal.c:848: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'uint32_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/jbd2/journal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090105.orig/fs/jbd2/journal.c
+++ linux-next-20090105/fs/jbd2/journal.c
@@ -845,7 +845,8 @@ static int jbd2_seq_info_show(struct seq
 	seq_printf(seq, "  %ums logging transaction\n",
 	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
 	seq_printf(seq, "  %luus average transaction commit time\n",
-		   do_div(s->journal->j_average_commit_time, 1000));
+		   (unsigned long)do_div(s->journal->j_average_commit_time,
+					1000));
 	seq_printf(seq, "  %lu handles per transaction\n",
 	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
 	seq_printf(seq, "  %lu blocks per transaction\n",
