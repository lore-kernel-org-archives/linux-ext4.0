From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: [PATCH] jbd2: fix wrong use of do_div
Date: Sun, 11 Jan 2009 19:51:35 +0100
Message-ID: <1231699895.17759.19.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel@cs.aau.dk
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.cs.aau.dk ([130.225.194.6]:54714 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZAKTMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 14:12:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

the following warning:

fs/jbd2/journal.c: In function =E2=80=98jbd2_seq_info_show=E2=80=99:
fs/jbd2/journal.c:850: warning: format =E2=80=98%lu=E2=80=99 expects ty=
pe =E2=80=98long
unsigned int=E2=80=99, but argument 3 has type =E2=80=98uint32_t=E2=80=99

is caused by wrong usage of do_div that modifies the dividend in-place
and returns the quotient. So not only would an incorrect value be
displayed, but s->journal->j_average_commit_time would also be changed
to a wrong value! This patch fixes it.

Signed-off-by: Simon Holm Th=C3=B8gersen <odie@cs.aau.dk>
---
 fs/jbd2/journal.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5667530..f9620e3 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -828,6 +828,7 @@ static void *jbd2_seq_info_next(struct seq_file *se=
q, void *v, loff_t *pos)
 static int jbd2_seq_info_show(struct seq_file *seq, void *v)
 {
 	struct jbd2_stats_proc_session *s =3D seq->private;
+	u64 n;
=20
 	if (v !=3D SEQ_START_TOKEN)
 		return 0;
@@ -846,8 +847,11 @@ static int jbd2_seq_info_show(struct seq_file *seq=
, void *v)
 	    jiffies_to_msecs(s->stats->u.run.rs_flushing / s->stats->ts_tid))=
;
 	seq_printf(seq, "  %ums logging transaction\n",
 	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
-	seq_printf(seq, "  %luus average transaction commit time\n",
-		   do_div(s->journal->j_average_commit_time, 1000));
+
+	n =3D s->journal->j_average_commit_time;
+	do_div(n, 1000);
+	seq_printf(seq, "  %llus average transaction commit time\n", n);
+
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
