From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even
 with internal journal
Date: Fri, 10 Feb 2012 14:58:12 +0100
Message-ID: <20120210135812.GJ10509@quack.suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
 <1326241872-20142-2-git-send-email-jack@suse.cz>
 <20120111124918.GD26337@quack.suse.cz>
 <20120209030551.GH18461@thunk.org>
 <4BF54606-BF0E-4CA8-98F7-25B16BCDA497@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab2BJN6N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 08:58:13 -0500
Content-Disposition: inline
In-Reply-To: <4BF54606-BF0E-4CA8-98F7-25B16BCDA497@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 09-02-12 00:26:11, Ted Tso wrote:
> One more thought.   I wonder if we should be trying to call a version of
> journal_cleanup_tail after we do a commit, since at that point we will
> have done a flush so updating the journal superblock should be "cheap".
  Yes. That is in patch 6/6 ;). I just put it in a separate patch because
the first patch is a correctness fix which was complex enough and this is
just an optional optimization...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
