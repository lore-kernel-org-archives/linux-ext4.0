From: Jan Kara <jack@suse.cz>
Subject: Re: memory leak: data=journal and {collapse,insert,zero}_range
Date: Mon, 23 Nov 2015 14:53:42 +0100
Message-ID: <20151123135342.GJ23418@quack.suse.cz>
References: <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
 <20151020155443.GM2972@thunk.org>
 <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
 <20151021145214.GC2165@thunk.org>
 <004301d11aae$72683a40$5738aec0$@samsung.com>
 <20151110144946.GB3156@quack.suse.cz>
 <005901d120f3$1d880410$58980c30$@samsung.com>
 <20151118213651.GI6097@quack.suse.cz>
 <20151119094240.GB18581@quack.suse.cz>
 <000001d1234c$c37079b0$4a516d10$@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Cc: 'Jan Kara' <jack@suse.cz>, 'Theodore Ts'o' <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbKWNxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2015 08:53:46 -0500
Content-Disposition: inline
In-Reply-To: <000001d1234c$c37079b0$4a516d10$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 20-11-15 13:34:36, Namjae Jeon wrote:
> Actually, I can quickly create memleak with simple testcase like:
> while(1000)
> {
> Random seek(max 500M) -> write 1M -> fsync ->truncate(random size)
> }
> 
> As there is significant memleak in this situation also, I started focusing
> on this simple testcase only. When use this testcase, I never saw EBUSY path
> in jbd2_journal_invalidatepage() -> journal_unmap_buffer().
> 
> On the other hand(), for memleak pages jbd2_journal_invalidatepage() ->
> journal_unmap_buffer() was almost bailing out every time from
>                 if (!buffer_dirty(bh)) {
>                         /* bdflush has written it.  We can drop it now */
>                         goto zap_buffer;
>                 }
> 
> As per debugging, NULL mapping page or buffer is created in below scenario:
> Write(or Kjournald) -> jbd2_journal_commit_transaction
>                     -> BH_JBDDirty buffer is added to forget list.
>                     -> Buffer is added to new checkpoint,
>                        additional reference count is taken on b_jcount which
>                        keeps buffer busy until remove checkpoint.
>                     -> Buffer is unfiled, removed from forget list, BH_JBDDirty
>                        is cleared and BH_Dirty is set, it is exposed to VM. 

Ah, I see! Thanks for the easy reproduction testcase and for the debugging.
Attached patch fixes the issue (at least the simple truncate case) for me.
Can you check whether it fixes the issue for you as well? Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--AqsLC8rIMeq19msA
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Fix-unreclaimed-pages-after-truncate-in-data-jo.patch"

>From 29e43b5691866e8eb363c1ef64e1fc89b2792e86 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 23 Nov 2015 13:34:30 +0100
Subject: [PATCH] jbd2: Fix unreclaimed pages after truncate in data=journal
 mode

Ted and Namjae have reported that truncated pages don't get timely
reclaimed after being truncated in data=journal mode. The following test
triggers the issue easily:

for (i = 0; i < 1000; i++) {
	pwrite(fd, buf, 1024*1024, 0);
	fsync(fd);
	fsync(fd);
	ftruncate(fd, 0);
}

The reason is that journal_unmap_buffer() finds that truncated buffers
are not journalled (jh->b_transaction == NULL), they are part of
checkpoint list of a transaction (jh->b_cp_transaction != NULL) and have
been already written out (!buffer_dirty(bh)). We clean such buffers but
we leave them in the checkpoint list. Since checkpoint transaction holds
a reference to the journal head, these buffers cannot be released until
the checkpoint transaction is cleaned up. And at that point we don't
call release_buffer_page() anymore so pages detached from mapping are
lingering in the system waiting for reclaim to find them and free them.

Fix the problem by removing buffers from transaction checkpoint lists
when journal_unmap_buffer() finds out they don't have to be there
anymore.

Reported-by: Namjae Jeon <namjae.jeon@samsung.com>
Fixes: de1b794130b130e77ffa975bb58cb843744f9ae5
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 89463eee6791..daa1514259e0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2152,6 +2152,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 
 		if (!buffer_dirty(bh)) {
 			/* bdflush has written it.  We can drop it now */
+			__jbd2_journal_remove_checkpoint(jh);
 			goto zap_buffer;
 		}
 
@@ -2181,6 +2182,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 				/* The orphan record's transaction has
 				 * committed.  We can cleanse this buffer */
 				clear_buffer_jbddirty(bh);
+				__jbd2_journal_remove_checkpoint(jh);
 				goto zap_buffer;
 			}
 		}
-- 
2.1.4


--AqsLC8rIMeq19msA--
