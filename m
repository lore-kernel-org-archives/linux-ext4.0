From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bugfixes/cleanups
Date: Sun, 3 Aug 2008 14:45:35 -0400
Message-ID: <20080803184534.GE8402@mit.edu>
References: <E1KPShM-0007Ks-M0@closure.thunk.org> <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55693 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752270AbYHCSph (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Aug 2008 14:45:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 03, 2008 at 10:52:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 2 Aug 2008, Theodore Ts'o wrote:
> > 
> > Please pull from:
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> Could you please include the expected diffstat too?

Oops, sorry.  Here you go.

 fs/ext4/acl.c     |  188 ++++++++++++++++----------------
 fs/ext4/balloc.c  |   11 +-
 fs/ext4/ext4.h    |    1 -
 fs/ext4/extents.c |   55 ++++++----
 fs/ext4/ialloc.c  |   56 ++++++----
 fs/ext4/inode.c   |  164 +++++++++++++++++++---------
 fs/ext4/mballoc.c |  254 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/mballoc.h |   10 ++-
 fs/ext4/resize.c  |   79 +++++++-------
 fs/ext4/super.c   |  316 ++++++++++++++++++++++++++++-------------------------
 fs/ext4/xattr.c   |    2 +-
 fs/jbd2/commit.c  |   24 ++++-
 fs/jbd2/journal.c |    1 -
 13 files changed, 728 insertions(+), 433 deletions(-)

						- Ted
