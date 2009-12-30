From: tytso@mit.edu
Subject: Re: [GIT PULL] ext4 updates for v2.6.33
Date: Wed, 30 Dec 2009 16:06:22 -0500
Message-ID: <20091230210622.GE828@thunk.org>
References: <E1NOdOL-0001s1-4J@closure.thunk.org>
 <alpine.LFD.2.00.0912301249520.11961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45098 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZL3VG1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2009 16:06:27 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912301249520.11961@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 30, 2009 at 12:51:11PM -0800, Linus Torvalds wrote:
> 
> I don't get the diffstat you claim, so I'm unpulling. I've got a lot of 
> extra work in fs/ext4/inode.c, and fewer lines in fs/ext4/extents.c, for a 
> total of
> 
>   15 files changed, 189 insertions(+), 94 deletions(-)
> 
> instead of you claimed
> 
> >  15 files changed, 108 insertions(+), 24 deletions(-)
> 
> Hmm?

Sorry, I was going to send you a note about it just now, but I hadn't
gotten around to hitting the send button yet.

I had updated the for_linus branch to fix a regression that had shown
up in -rc2 due to an quota/ext4 journal fix that turned out to cause a
BUG_ON to trip in fs/ext4/inode.c:1063 (kernel bug #14936, on Rafael's
regression list) when mounting unconverted ext3 file systems using the
ext4 file system driver.  It was hitting a lot of users who had been
playing with ext4, so I wanted to get the fix to you as soon as
possible.

Here's the updated summary:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

						- Ted

 Documentation/filesystems/ext4.txt |    2 +-
 fs/ext4/Kconfig                    |    1 +
 fs/ext4/block_validity.c           |    1 -
 fs/ext4/extents.c                  |   28 ++++++-
 fs/ext4/fsync.c                    |   16 +++-
 fs/ext4/inode.c                    |  171 ++++++++++++++++++++----------------
 fs/ext4/mballoc.h                  |    1 -
 fs/ext4/super.c                    |    6 +-
 fs/ext4/xattr.c                    |    2 +
 fs/fs-writeback.c                  |   17 ++++
 fs/jbd2/checkpoint.c               |   15 +++
 fs/jbd2/commit.c                   |   19 +++--
 fs/jbd2/journal.c                  |    2 +-
 include/linux/jbd2.h               |    1 +
 include/linux/writeback.h          |    1 +
 15 files changed, 189 insertions(+), 94 deletions(-)

Andrew Morton (2):
      ext4: fix unsigned long long printk warning in super.c
      jbd2: don't use __GFP_NOFAIL in journal_init_common()

Aneesh Kumar K.V (1):
      ext4: Ensure zeroout blocks have no dirty metadata

David Howells (1):
      ext4: Don't ask about supporting ext2/3 in ext4 if ext4 is not configured

Eric Sandeen (2):
      fs-writeback: Add helper function to start writeback if idle
      ext4: flush delalloc blocks when space is low

Fang Wenqi (1):
      ext4: Update documentation to correct the inode_readahead_blks option name

Huang Weiyi (1):
      ext4: remove unused #include <linux/version.h>

Julia Lawall (1):
      ext4: Eliminate potential double free on error path

Richard Kennedy (1):
      ext4: return correct wbc.nr_to_write in ext4_da_writepages

Surbhi Palande (1):
      ext4: replace BUG() with return -EIO in ext4_ext_get_blocks

Theodore Ts'o (3):
      ext4: add module aliases for ext2 and ext3
      ext4, jbd2: Add barriers for file systems with exernal journals
      ext4: Patch up how we claim metadata blocks for quota purposes

