From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4, jbd2: add REQ_FUA flag when recording an error flag
Date: Thu, 23 Jul 2015 09:48:02 -0400
Message-ID: <20150723134802.GK2944@thunk.org>
References: <1153399123.83011435025959601.JavaMail.weblogic@ep2mlwas05d>
 <CAFKwG1g2_+XsdT0pQcNTEYg4SAxDtewYnMsJcS7Hop_FMoEQ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daeho.jeong@samsung.com, linux-ext4@vger.kernel.org
To: Daeho Jeong <daehojng@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41915 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbGWNsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2015 09:48:06 -0400
Content-Disposition: inline
In-Reply-To: <CAFKwG1g2_+XsdT0pQcNTEYg4SAxDtewYnMsJcS7Hop_FMoEQ5g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> @@ -4638,7 +4639,10 @@ static int ext4_commit_super(struct super_block *sb,
> int sync)
>   ext4_superblock_csum_set(sb);
>   mark_buffer_dirty(sbh);
>   if (sync) {
> -  error = sync_dirty_buffer(sbh);
> +  if (journal->j_flags & JBD2_BARRIER)
> +   error = __sync_dirty_buffer(sbh, WRITE_FUA);
> +  else
> +   error = sync_dirty_buffer(sbh);
>    if (error)
>     return error;

The problem with this is that the journal structure will not be
present in no-journal mode, so it will result in a NULL dereference.
So I've changed this to use test_opt(sb, BARRIER) instead.

   		     	    		 	  - Ted
						  
commit 564bc402526e437729ecafe3c3511f7cab9f0327
Author: Daeho Jeong <daeho.jeong@samsung.com>
Date:   Thu Jul 23 09:46:11 2015 -0400

    ext4, jbd2: add REQ_FUA flag when recording an error in the superblock
    
    When an error condition is detected, an error status should be recorded into
    superblocks of EXT4 or JBD2. However, the write request is submitted now
    without REQ_FUA flag, even in "barrier=1" mode, which is followed by
    panic() function in "errors=panic" mode. On mobile devices which make
    whole system reset as soon as kernel panic occurs, this write request
    containing an error flag will disappear just from storage cache without
    written to the physical cells. Therefore, when next start, even forever,
    the error flag cannot be shown in both superblocks, and e2fsck cannot fix
    the filesystem problems automatically, unless e2fsck is executed in
    force checking mode.
    
    [ Changed use test_opt(sb, BARRIER) of checking the journal flags -- TYT ]
    
    Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 14909cd..a51db9c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4667,7 +4667,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	ext4_superblock_csum_set(sb);
 	mark_buffer_dirty(sbh);
 	if (sync) {
-		error = sync_dirty_buffer(sbh);
+		error = __sync_dirty_buffer(sbh,
+			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
 		if (error)
 			return error;
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4ff3fad..fe1b4bd 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1456,7 +1456,7 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
 	read_unlock(&journal->j_state_lock);
 
-	jbd2_write_superblock(journal, WRITE_SYNC);
+	jbd2_write_superblock(journal, WRITE_FUA);
 }
 EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
