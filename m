From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] handle journal checksum errors via ext4_error()
Date: Sat, 14 Nov 2009 15:27:55 -0500
Message-ID: <20091114202755.GC4221@mit.edu>
References: <4AF1BBD0.3050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36608 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZKNU1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 15:27:53 -0500
Content-Disposition: inline
In-Reply-To: <4AF1BBD0.3050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 04, 2009 at 11:37:20AM -0600, Eric Sandeen wrote:
> As the code stands today, journal checksum errors on the root fs,
> resulting in only a partial journal replay, result in no kernel
> messages and no error condition, because it is all handled under
> a "!(sb->s_flags & MS_RDONLY)" test - and the root fs starts out
> life in RO mode.
> 
> It seems to me that just calling ext4_error() here is almost the
> right thing to do; it will unconditionally mark the fs with errors,
> and act according to the selected mount -o errors= behavior...
> 
> However, for the root fs, ext4_error will be short-circuited because
> the root is mounted readonly; and in fact these errors came into
> being while we were writing to a read-only fs during journal recovery.
> So we won't do a journal_abort or anything like that, and other than
> a printk and an error flag, not much action is taken for a
> partially-recovered fs.  Does this seem like enough?
> 
> Should we just let the root fs carry on if it's been partially-recovered,
> and therefore pretty well known to be corrupt?

I've been thinking about this some more, and I think we need to make
change to jbd2_journal_load() so that it checks for the failed journal
checksum, and then avoid resetting the journal.  This allows for a
userspace program like e2fsck to do something better about recovering
from this situation.

						- Ted

jbd2: don't wipe the journal on a failed journal checksum

If there is a failed journal checksum, don't reset the journal.  This
allows for userspace programs to decide how to recover from this
situation.  It may be that ignoring the journal checksum failure might
be a better way of recovering the file system.  Once we add per-block
checksums, we can definitely do better.  Until then, a system
administrator can try backing up the file system image (or taking a
snapshot) and and trying to determine experimentally whether ignoring
the checksum failure or aborting the journal replay results in less
data loss.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index fed8538..af60d98 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1248,6 +1248,13 @@ int jbd2_journal_load(journal_t *journal)
 	if (jbd2_journal_recover(journal))
 		goto recovery_error;
 
+	if (journal->j_failed_commit) {
+		printk(KERN_ERR "JBD2: journal transaction %u on %s "
+		       "is corrupt.\n", journal->j_failed_commit,
+		       journal->j_devname);
+		return -EIO;
+	}
+
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
 	 * and reset them on disk. */

