From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: fix I/O error when unmounting an ro file system
Date: Thu, 25 Oct 2012 16:01:01 -0400
Message-ID: <1351195261-31258-3-git-send-email-tytso@mit.edu>
References: <1351195261-31258-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>,
	Nix <nix@esperi.org.uk>,
	=?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57601 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934218Ab2JYUBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 16:01:06 -0400
In-Reply-To: <1351195261-31258-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This comment fixes commit eeecef0af5ea in a different way.  The
original bug was that the following sequence:

# truncate --size=3D1g fsfile
# mkfs.ext4 -F fsfile
# mount -o loop,ro fsfile /mnt
# umount /mnt
# dmesg | tail

results in an IO error when unmounting the RO filesystem:

[  318.020828] Buffer I/O error on device loop1, logical block 196608
[  318.027024] lost page write due to I/O error on loop1
[  318.032088] JBD2: Error -5 detected when updating journal superblock=
 for l

And this was a regression introduced by commit 24bcc89c7e7c: "jbd2:
split updating of journal superblock and marking journal empty".

Here, we fix this bug by explicitly checking to see if the journal's
block device is read-only.  If it is read-only, we then do a sanity
check to make sure that sb->s_start is zero.  If it is non-zero, that
implies that one or more transactions has been committed to the
journal, which is a "can't happen" scenario if the block device is
read-only.  So we will print a warning message and abort the journal
in that case.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Nix <nix@esperi.org.uk>
Cc: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 fs/jbd2/journal.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bd23f2e..dcea89f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1357,6 +1357,24 @@ static void jbd2_mark_journal_empty(journal_t *j=
ournal)
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
=20
+	if (bdev_read_only(journal->j_dev)) {
+		__be32 s_start =3D sb->s_start;
+
+		read_unlock(&journal->j_state_lock);
+		if (s_start !=3D 0) {
+			/*
+			 * should never happen, but aborting the
+			 * journal is nicer than a BUG_ON
+			 */
+			printk(KERN_ERR
+	"JBD2: trying to empty non-empty journal for r/o device %s\n",
+			       journal->j_devname);
+			WARN_ON(1);
+			jbd2_journal_abort(journal, -EROFS);
+		}
+		return;
+	}
+
 	sb->s_sequence =3D cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    =3D cpu_to_be32(0);
 	read_unlock(&journal->j_state_lock);
--=20
1.7.12.rc0.22.gcdd159b

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
