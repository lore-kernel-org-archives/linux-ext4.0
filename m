From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 regression and bug fixes for 2.6.38
Date: Thu, 10 Feb 2011 19:02:54 -0500
Message-ID: <20110211000254.GI16597@thunk.org>
References: <E1PmaYB-0001aV-RQ@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39457 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab1BKAC4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Feb 2011 19:02:56 -0500
Content-Disposition: inline
In-Reply-To: <E1PmaYB-0001aV-RQ@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 07, 2011 at 06:31:19PM -0500, Theodore Ts'o wrote:
> Hi Linus,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to get regression and bug fixes for 2.6.38.
> 
> Thanks,

Hi Linus, it looks like you haven't pulled this tree yet.  It turns
out there's one more patch (from Dan Carpenter) which I need to send
you, so I've updated for_linus branch with an additional commit.  The
shortlog and diff should now be as shown below.

Please pull when you have a chance, thanks!!

	       	  	     	      	  - Ted

Curt Wohlgemuth (1):
      ext4: Fix data corruption with multi-block writepages support

Dan Carpenter (1):
      ext4: off by one check in ext4_groupinfo_create_slab()

Eric Sandeen (3):
      ext4: fix panic on module unload when stopping lazyinit thread
      ext4: make grpinfo slab cache names static
      ext4: serialize unaligned asynchronous DIO

Lukas Czerner (1):
      ext4: unregister features interface on module unload

Theodore Ts'o (2):
      ext4: fix up ext4 error handling
      jbd2: call __jbd2_log_start_commit with j_state_lock write locked

 fs/ext4/ext4.h        |    8 ++++
 fs/ext4/extents.c     |   10 +++--
 fs/ext4/file.c        |   60 +++++++++++++++++++++++++++++-
 fs/ext4/mballoc.c     |  100 +++++++++++++++++++++++++++++-------------------
 fs/ext4/page-io.c     |   36 +++++++++--------
 fs/ext4/super.c       |   66 ++++++++++++++++++++++----------
 fs/jbd2/journal.c     |    9 +++-
 fs/jbd2/transaction.c |   21 +++++++---
 8 files changed, 219 insertions(+), 91 deletions(-)
