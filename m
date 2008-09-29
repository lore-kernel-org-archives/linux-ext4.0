From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re:
	jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch
Date: Mon, 29 Sep 2008 17:51:13 +0100
Message-ID: <20080929165113.GA1360@dastardly.home.dghda.com>
References: <20080922140851.bc3f9319.akpm@linux-foundation.org> <e9e943910809230956n3f36e544hc46a80c00ff9804a@mail.gmail.com> <20080929022426.GL8711@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Stephen C. Tweedie" <sct@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2246 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYI2Q6A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2008 12:58:00 -0400
Content-Disposition: inline
In-Reply-To: <20080929022426.GL8711@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 28, 2008 at 10:24:26PM -0400, Theodore Tso wrote:
> On Tue, Sep 23, 2008 at 05:56:27PM +0100, Duane Griffin wrote:
> > Stephen suggested that it would be better to sanity check the journal
> > start/end pointers on mount, rather than catching the error later like
> > this. I never quite convinced myself I'd worked out the right way to
> > do that, sorry. Perhaps someone would like to confirm (or otherwise)
> > whether or not the following is correct:
> > 
> > In journal_reset (?) check that:
> > 
> > journal->j_first == 1 (this seems to be the only valid value)
> > 
> > and
> > 
> > journal->j_last >= JFS_MIN_JOURNAL_BLOCKS
> 
> Yes, for all existing currently created, j_first will be 1.  I can't
> think of a good reason for why we might want to reserve some space at
> the beginning of the journal, but the safest check would be:
> 
>     (journal->j_last - journal->j_first +1) >= JFS_MIN_JOURNAL_BLOCKS

Fair enough.

> > Additionally, it should be possible to check the journal->j_last more
> > precisely. For internal journals it seems straight-forward, we can
> > just check that journal->j_last == inode->i_size >>
> > inode->i_sb->s_blocksize_bits. For external journals we'd need to load
> > the device's superblock and check journal->j_last == s_blocks_count.
> 
> Yep, agreed.

OK, great. See patch below. I'll send the ext3/jbd version once you're
happy with it.

> > Regardless, I think the original patch may be a good idea. It improves
> > robustness and matches the other locations where we call
> > jbd2_log_do_checkpoint. They are all in loops that test that
> > journal->j_checkpoint_transactions != NULL.
> 
> Agreed.  I've included it in the ext4 patch queue, and will be soon
> putting out a new ext4 patchset consisting of the patches I plan to
> push during the next merge window.

Great, thanks. The original patch was for ext3/jbd patch, but I'm not
sure whether that has been accepted anywhere or not. I'll check after
the ext3 patches are merged and resend it if needed.

> 						- Ted

Cheers,
Duane.

-- 

Subject: [PATCH] jbd2: sanity check block range

Invalid journal start/end block values can cause BUGs. Do some sanity
checking on them when we load the journal.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8207a01..bb926e4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -41,6 +41,8 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
+#include "../ext4/ext4.h"
+
 EXPORT_SYMBOL(jbd2_journal_start);
 EXPORT_SYMBOL(jbd2_journal_restart);
 EXPORT_SYMBOL(jbd2_journal_extend);
@@ -1120,6 +1122,34 @@ static void journal_fail_superblock (journal_t *journal)
 	journal->j_sb_buffer = NULL;
 }
 
+static int validate_last_block(journal_t *journal, unsigned long last)
+{
+	if (journal->j_inode) {
+		return last == journal->j_inode->i_size >>
+			journal->j_inode->i_sb->s_blocksize_bits;
+	} else {
+		struct buffer_head *bh;
+		struct ext4_super_block *es;
+		ext4_fsblk_t sb_block;
+		ext4_fsblk_t count;
+		unsigned long offset;
+
+		sb_block = EXT4_MIN_BLOCK_SIZE / journal->j_blocksize;
+		offset = EXT4_MIN_BLOCK_SIZE % journal->j_blocksize;
+		bh = __getblk(journal->j_dev, sb_block, journal->j_blocksize);
+		if (bh) {
+			es = (struct ext4_super_block *) bh->b_data + offset;
+			count = ext4_blocks_count(es);
+			brelse(bh);
+			return count == last;
+		} else {
+			printk(KERN_WARNING
+				"JBD2: IO error reading journal's ext3 sb\n");
+			return 0;
+		}
+	}
+}
+
 /*
  * Given a journal_t structure, initialise the various fields for
  * startup of a new journaling session.  We use this both when creating
@@ -1134,6 +1164,16 @@ static int journal_reset(journal_t *journal)
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
+	if (last - first + 1 < JBD2_MIN_JOURNAL_BLOCKS) {
+		printk(KERN_ERR "JBD2: Bad journal block range: %llu-%llu\n",
+			first, last);
+		return -EIO;
+	}
+
+	if (!validate_last_block(journal, last)) {
+		printk(KERN_ERR "JBD2: Bad last journal block: %llu\n", last);
+		return -EIO;
+	}
 
 	journal->j_first = first;
 	journal->j_last = last;
