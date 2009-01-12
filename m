From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: [PATCH] jbd2: fix wrong use of do_div
Date: Mon, 12 Jan 2009 02:44:40 +0100
Message-ID: <1231724680.3094.3.camel@odie.local>
References: <1231701393.17759.30.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.cs.aau.dk ([130.225.194.6]:37588 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZALBnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 20:43:15 -0500
In-Reply-To: <1231701393.17759.30.camel@odie.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[I got a simpler version 2 of the patch here]

the following warning:

fs/jbd2/journal.c: In function =E2=80=98jbd2_seq_info_show=E2=80=99:
fs/jbd2/journal.c:850: warning: format =E2=80=98%lu=E2=80=99 expects ty=
pe =E2=80=98long
unsigned int=E2=80=99, but argument 3 has type =E2=80=98uint32_t=E2=80=99

is caused by wrong usage of do_div that modifies the dividend in-place
and returns the quotient. So not only would an incorrect value be
displayed, but s->journal->j_average_commit_time would also be changed
to a wrong value!

=46ix it by using div_u64 instead.

Signed-off-by: Simon Holm Th=C3=B8gersen <odie@cs.aau.dk>
---
 fs/jbd2/journal.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5667530..eb34300 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -37,10 +37,10 @@
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/math64.h>
=20
 #include <asm/uaccess.h>
 #include <asm/page.h>
-#include <asm/div64.h>
=20
 EXPORT_SYMBOL(jbd2_journal_start);
 EXPORT_SYMBOL(jbd2_journal_restart);
@@ -846,8 +846,8 @@ static int jbd2_seq_info_show(struct seq_file *seq,
void *v)
 	    jiffies_to_msecs(s->stats->u.run.rs_flushing / s->stats->ts_tid))=
;
 	seq_printf(seq, "  %ums logging transaction\n",
 	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
-	seq_printf(seq, "  %luus average transaction commit time\n",
-		   do_div(s->journal->j_average_commit_time, 1000));
+	seq_printf(seq, "  %lluus average transaction commit time\n",
+		   div_u64(s->journal->j_average_commit_time, 1000));
 	seq_printf(seq, "  %lu handles per transaction\n",
 	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
 	seq_printf(seq, "  %lu blocks per transaction\n",
--=20
1.6.0.2.526.g5c283

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
