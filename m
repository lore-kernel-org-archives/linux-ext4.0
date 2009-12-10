From: tytso@mit.edu
Subject: Re: [GIT PULL] ext4 updates for v2.6.33
Date: Wed, 9 Dec 2009 22:38:53 -0500
Message-ID: <20091210033853.GA7215@thunk.org>
References: <E1NIP7h-0002Tv-AP@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52311 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490AbZLJDir (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 22:38:47 -0500
Content-Disposition: inline
In-Reply-To: <E1NIP7h-0002Tv-AP@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 09, 2009 at 11:10:41AM -0500, Theodore Ts'o wrote:
> Hi Linus,
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab the following changes for v2.6.33.
> 
> Lots of bug fixes, plus some cleanup work.
> 

Hi Linus, it looks like you haven't pulled from the ext4 tree yet.

FYI, I've since added three more patches to the for_linus branch to
fix a few more bugs:

Theodore Ts'o (3):
      jbd2: Export jbd2_log_start_commit to fix ext4 build
      ext4: Do not override ext2 or ext3 if built they are built as modules
      ext4: Fix potential fiemap deadlock (mmap_sem vs. i_data_sem)

 fs/ext4/Kconfig   |    2 +-
 fs/ext4/extents.c |    4 ++--
 fs/ext4/super.c   |    4 ++--
 fs/jbd2/journal.c |    1 +
 4 files changed, 6 insertions(+), 5 deletions(-)

							- Ted
