From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/8 v3] Checkpointing fixes and cleanups
Date: Wed, 29 Feb 2012 12:03:42 +0100
Message-ID: <20120229110342.GC18846@quack.suse.cz>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab2B2LDp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 06:03:45 -0500
Content-Disposition: inline
In-Reply-To: <1329330854-14237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 15-02-12 19:34:06, Jan Kara wrote:
>   Hello,
> 
>   this is a third round of my checkpointing fixes. The patch set is primarily
> aimed at fixing filesystem corruption happening occasionally (rather rarely)
> after power failure. First three patches should fix the issue. Patches 4-7 are
> assorted checkpointing cleanups I've gathered when inspecting checkpointing
> code. Finally patch 8 is a possible speedup of checkpoining - we can use cache
> flushes happening during transaction commits for pushing the journal tail
> safely. The observable speedup is disputable since jbd2_cleanup_journal_tail()
> is called rather rarely (for metadata heavy load I saw about one
> jbd2_cleanup_journal_tail() for about 200 commits) so the cost of additional
> cache flush will be likely in the noise. But the patch is simple enough so I
> send it for others to judge whether it makes sense or not.
> 
> Changes since v2:
> Rewrote the code pushing log tail to fix race described by Ted.
> Improved some comments
  Ted, do you plan to have a look at this? It would be nice to get these
fixes in for the next merge window...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
