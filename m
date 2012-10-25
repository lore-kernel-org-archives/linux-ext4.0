From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: revert "jbd2: don't write superblock when if its empty"
Date: Thu, 25 Oct 2012 16:01:00 -0400
Message-ID: <1351195261-31258-2-git-send-email-tytso@mit.edu>
References: <1351195261-31258-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>,
	stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57597 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934218Ab2JYUBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 16:01:03 -0400
In-Reply-To: <1351195261-31258-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reverts commit eeecef0af5ea4efd763c9554cf2bd80fc4a0efd3.

Two users have reported an increased number of file system corruptions
after v3.6.2 (which had this patch backported).  The instances of
corruptions seem to be related to unclean shutdowns as the file system
was being unmounted or by the unexpected disconnection of external
disks.  So let's back out this change while do more investigation...

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Nix <nix@esperi.org.uk>
Reported-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
Cc: stable@vger.kernel.org
---
 fs/jbd2/journal.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0f16edd..bd23f2e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1354,11 +1354,6 @@ static void jbd2_mark_journal_empty(journal_t *j=
ournal)
=20
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	read_lock(&journal->j_state_lock);
-	/* Is it already empty? */
-	if (sb->s_start =3D=3D 0) {
-		read_unlock(&journal->j_state_lock);
-		return;
-	}
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
=20
--=20
1.7.12.rc0.22.gcdd159b

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
