From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 fixes
Date: Sat, 28 Feb 2009 12:55:28 -0500
Message-ID: <20090228175528.GC6935@mit.edu>
References: <E1LdQQ5-0004kd-OD@closure.thunk.org> <49A95B1C.9060008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58733 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZB1Rzc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 12:55:32 -0500
Content-Disposition: inline
In-Reply-To: <49A95B1C.9060008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 28, 2009 at 09:41:16AM -0600, Eric Sandeen wrote:
> 
> Ted, might be good to get my nojournal fix in too?  It's an easy oopser.
> 

Good point.  Linus, I've added Eric's nojournal to the for_linus
branch.   Here's the updated pull request:

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks!!

						- Ted

Eric Sandeen (1):
      ext4: don't call jbd2_journal_force_commit_nested without journal

Theodore Ts'o (2):
      ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
      ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2

 fs/Makefile      |    6 ++++--
 fs/ext4/balloc.c |    4 +++-
 fs/ext4/inode.c  |    2 +-
 fs/ext4/super.c  |    1 -
 4 files changed, 8 insertions(+), 5 deletions(-)
