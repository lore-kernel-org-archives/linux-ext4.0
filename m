From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Sun, 5 Oct 2008 22:50:06 -0400
Message-ID: <20081006025006.GA9289@mit.edu>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52139 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbYJFCuJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Oct 2008 22:50:09 -0400
Content-Disposition: inline
In-Reply-To: <20081005161214.GA2985@goelette.ens.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 05, 2008 at 06:12:15PM +0200, Quentin Godfroy wrote:
> For the two fs the only inode which shows up is the inode 8 (this
> seems to be the journal. According to 'stat <8>' in debugfs it looks
> like the journal is 134Megs long. I don't remember exactly how I
> created the fs, but i'm sure I did not specified the journal
> size. Does it seem reasonable for a 6,6G fs?

134 Megs sounds wrong.  What does dumpe2fs -h say?  I'm guessing you
didn't calculate it quite correctly.

I did some poking around myself, and noticed that a lot of in-use
buffers hanging around from the journal inode.  The following patch
should fix that problem.  I'm still doing some more testingto make
sure there aren't any other buffer head leaks, but this is seems to
fix the worst of the problems.  Can you let me know how this works for
you?

							- Ted

jbd2: Fix buffer head leak when writing the commit block

Also make sure the buffer heads are marked clean before submitting bh
for writing.  The previous code was marking the buffer head dirty,
which would have forced an unneeded write (and seek) to the journal
for no good reason.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index e91f051..c2b04cd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -127,8 +127,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-	get_bh(bh);
-	set_buffer_dirty(bh);
+	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
@@ -157,7 +156,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 		/* And try again, without the barrier */
 		lock_buffer(bh);
-		set_buffer_uptodate(bh);
+		clear_buffer_uptodate(bh);
 		set_buffer_dirty(bh);
 		ret = submit_bh(WRITE, bh);
 	}
