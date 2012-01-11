From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] jbd2: Checkpointing fix and cleanups
Date: Wed, 11 Jan 2012 01:31:06 +0100
Message-ID: <1326241872-20142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab2AKAbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  I'm chasing for some time occasional reports of filesystem corruption
demonstrated most often by 'bit already cleared' errors. I'm seeing such
reports for several years with a rate of about 1 - 2 per year. At first I
attributed those to memory errors (and some of those reports indeed might
be due to HW problems) but some of them probably are not. Recently I've got
one such report and user was nice enough to get me e2image of corrupted
filesystem from which it was more or less obvious that during a crash we lost
writes to some blocks (bitmap was among them).

I think the problem is due to a missing cache flush in checkpointing code
(see patch 1 for details). I've tweaked Chris Mason's barrier-test IO
scheduler to be evil in reordering requests in the right way and indeed I
was able to trigger the fs corruption after a crash.

When I was inspecting checkpointing code, I also found several things that
deserve a cleanup so patches 2-5 are a result of that. Finally patch 6 is
a possible speedup - we can use barriers happening during transaction commits
for pushing the journal tail safely. The observable speedup is disputable
since jbd2_cleanup_journal_tail() is called rather rarely (for metadata heavy
load I saw about one jbd2_cleanup_journal_tail() for about 200 commits) so
the cost of additional cache flush will be likely in the noise. But the patch
is simple enough so I send it for others to judge whether it makes sense or
not.

Review is highly welcome.

								Honza
