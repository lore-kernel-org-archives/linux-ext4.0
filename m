From: TR Reardon <thomas_reardon@hotmail.com>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Sun, 10 Aug 2014 18:35:33 -0400
Message-ID: <BLU437-SMTP891ACD0330C1C09A2EBB94FDEC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s27.hotmail.com ([65.55.116.38]:53642 "EHLO
	BLU004-OMC1S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbaHJWgR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:36:17 -0400
Received: by mail-yk0-f180.google.com with SMTP id 200so5425909ykr.39
        for <linux-ext4@vger.kernel.org>; Sun, 10 Aug 2014 15:36:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, I found the problem in jbd2, and have a solution, though it's
debatable what the ideal solution is.  For now, the simplest patch is
below, though a similar patch in lib/ext2fs/kernel-jbd.h is required
to get e2fsck back in sync.

The original c3900875 commit adding metadata_csum (ie
journal_checksum_v2) to jbd2 added 2 extra bytes for the block
checksums, in addition to re-allocating 2 bytes from the 4 bytes of
flags.  However, a decision was made to only retain the lower 16-bits
of the crc32c, and thus those extra 2 bytes were unneeded.  But those
2 extra bytes were never "deallocated" from journal_tag_bytes().

Unfortunately, different code relies on JBD_TAG_SIZE32/64 constants
directly rather than the journal_tag_bytes() utility function, in
particular the recovery code which is common to e2fsck and jbd2.  This
led different tools to think they were looking at a 64bit journal when
actually it was 32bit.  Code that relied on journal_tag_bytes()
remained safe, so the block iterators were fine, but any direct use of
those constants [including the hideous greater-than comparison in
read_tag_bytes()] went awry, and journal replay will fail.

As far as I can tell, metadata_csum + journal checksum has never
worked for 32bit filesystems. By a little bit of padding luck, 64bit
worked fine.

Now, as to the solution: depends on whether one feels that existing
in-the-wild journals matter. The original commit was May 2012, are we
past early-adopters now?  If this patch is taken, you shrink the
journal block tags to the intended size but in-the-wild journals will
be broken.  But they already are, so...?  This opens up the
possibility of now using those extra 2 bytes and retaining full 32-bit
crc32c for the block tags.  If going that route, debugs/logdump needs
a fix in addition to changes to jbd2.

FWIW, the "JBD2: Out of memory during recovery." error in
fs/jbd2/recovery.c was opaque at best and should be changed to always
include the block# that caused the problem.

+Reardon

---
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 67b8e30..dc27d09 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2166,15 +2166,11 @@ int jbd2_journal_blocks_per_page(struct inode *inode)
 size_t journal_tag_bytes(journal_t *journal)
 {
        journal_block_tag_t tag;
-       size_t x = 0;
