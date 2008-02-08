From: akpm@linux-foundation.org
Subject: - ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:16 -0800
Message-ID: <200802082020.m18KKvsN011272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: neilb@suse.de, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3 can fail badly when device stops accepting BIO_RW_BARRIER requests
has been removed from the -mm tree.  Its filename was
     ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3 can fail badly when device stops accepting BIO_RW_BARRIER requests
From: Neil Brown <neilb@suse.de>

Some devices - notably dm and md - can change their behaviour in response
to BIO_RW_BARRIER requests.  They might start out accepting such requests
but on reconfiguration, they find out that they cannot any more.

ext3 (and other filesystems) deal with this by always testing if
BIO_RW_BARRIER requests fail with EOPNOTSUPP, and retrying the write
requests without the barrier (probably after waiting for any pending writes
to complete).

However there is a bug in the handling for this for ext3.

When ext3 (jbd actually) decides to submit a BIO_RW_BARRIER request, it
sets the buffer_ordered flag on the buffer head.  If the request completes
successfully, the flag STAYS SET.

Other code might then write the same buffer_head after the device has been
reconfigured to not accept barriers.  This write will then fail, but the
"other code" is not ready to handle EOPNOTSUPP errors and the error will be
treated as fatal.

This can be seen without having to reconfigure a device at exactly the
wrong time by putting:

		if (buffer_ordered(bh))
			printk("OH DEAR, and ordered buffer\n");

in the while loop in "commit phase 5" of journal_commit_transaction.

If it ever prints the "OH DEAR ..." message (as it does sometimes for
me), then that request could (in different circumstances) have failed
with EOPNOTSUPP, but that isn't tested for.

My proposed fix is to clear the buffer_ordered flag after it has been
used, as in the following patch.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd/commit.c~ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests fs/jbd/commit.c
--- a/fs/jbd/commit.c~ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests
+++ a/fs/jbd/commit.c
@@ -131,6 +131,8 @@ static int journal_write_commit_record(j
 		barrier_done = 1;
 	}
 	ret = sync_dirty_buffer(bh);
+	if (barrier_done)
+		clear_buffer_ordered(bh);
 	/* is it possible for another commit to fail at roughly
 	 * the same time as this one?  If so, we don't want to
 	 * trust the barrier flag in the super, but instead want
@@ -148,7 +150,6 @@ static int journal_write_commit_record(j
 		spin_unlock(&journal->j_state_lock);
 
 		/* And try again, without the barrier */
-		clear_buffer_ordered(bh);
 		set_buffer_uptodate(bh);
 		set_buffer_dirty(bh);
 		ret = sync_dirty_buffer(bh);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
