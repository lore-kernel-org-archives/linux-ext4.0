From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] Re: [PATCH] ext4: fix a bug when we try to open a file
 with O_TMPFILE flag
Date: Sat, 20 Jul 2013 22:45:11 -0400
Message-ID: <20130721024511.GC21484@thunk.org>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130719233613.GH4165@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 20, 2013 at 12:36:13AM +0100, Al Viro wrote:
> 
> Nice catch, and you have my ACK.  Which tree do you prefer that to go
> through?  vfs and ext4 are the obvious candidates...

On second thought, to avoid an "After you, Alphonse" moment, and
because it would be really good to make sure these patches make it to
Linus before -rc2, I thought get these patches set up for a pull
request.  Al, if you'd prefer that they go through the vfs tree, feel
free to NACK this, and I'll happily drop these from the ext4 tree.

Cheers,

						- Ted


The following changes since commit 36231d255b8df9cb4698e9a3902c16067d5c1398:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-07-20 10:50:01 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to dda5690defe4af62ee120f055e98e40d97e4c760:

  ext3: fix a BUG when opening a file with O_TMPFILE flag (2013-07-20 22:03:20 -0400)

----------------------------------------------------------------
Fix regression caused by commit af51a2ac36d1f which added ->tmpfile()
support (along with a similar fix for ext3)

----------------------------------------------------------------
Zheng Liu (2):
      ext4: fix a BUG when opening a file with O_TMPFILE flag
      ext3: fix a BUG when opening a file with O_TMPFILE flag

 fs/ext3/namei.c | 2 +-
 fs/ext4/namei.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
