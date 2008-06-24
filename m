From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem compiling 2.6.260rc6 with updated ext4-patch-queue
Date: Tue, 24 Jun 2008 18:18:45 -0400
Message-ID: <20080624221845.GK7639@mit.edu>
References: <3.0.6.32.20080624102659.02429f60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52194 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbYFXWSv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 18:18:51 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080624102659.02429f60@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 24, 2008 at 10:26:59AM +0000, Gary Hawco wrote:
> Recently pulled and updated my ext4-patch-queue. Tried to compile
> the 2.6.26-rc6 after it patched cleanly. During make received the
> following error.

Hmm.... I just tested the latest commit on the ext4 patch queue
(14581cb30), and it compiled just fine on 2.6.26-rc6.

Based on what you listed as your latest patch, it looks like you are
using the previous commit (commit ID e2121926), and I just tried it
applied to 2.6.26-rc6, and it worked just fine for me.  So I'm not sure
why it's failing for you...

>fs/ext4/inode.c: In function 'ext4_journal_dirty_data':
>fs/ext4/inode.c:1297: error:  implicit declaration of function
>'jbd2_journal_dirty_data'
>fs/ext4/inode.c: In function 'ext4_da_writepages':
>fs/ext4/inode.c:1759: error:  implicit declaration of function
>'ext4_jbd2_file_inode'

When I look at my version of 2.6.26-rc6 with what I think was your
version of the patch queue (commit ID e2121926), fs/ext4/inode.c line
1297 is in the middle of a C comment, and line 1759 doesn't refer to
the function ext4_jbd2_file_inode at all.  So I'm wondering if
something went wrong with how you applied the ext4 patch queue.

Note: how I normally apply the patch queue is to use the "guilt" tool
--- http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt --- and
I drop the ext4 patch queue in .git/patches/ext4dev in the Linux git
repository.  So then I'll create the ext4dev branch as starting at the
2.6.26-rc6 (i.e., "git checkout -b ext4dev 2.6.26-rc6") or if the
ext4dev branch is already created, then magic incantation is (git
checkout ext4dev; guilt pop -a; git reset --hard 2.6.26-rc6).  Then
the entire patch queue can be applied via: "guilt push -a".

If I want to update to the latest version of the patch queue, I do:

   (cd .git/patches/ext4dev; git pull)
   guilt pop -a
   guilt push -a

If I want to rebase to 2.6.26-rc7, then what I'll do is:

   git checkout origin 		   	# In the Linux tree
   guilt pull				# Update to the latest from Linus
   git checkout ext4dev
   guilt pop -a
   git reset --hard 2.6.26-rc7
   guilt push -a

I then build and test the ext4 patch, and if it is successful, I'll
edit .git/patches/ext4dev/series so that it states that it's based off
of 2.6.26-rc7, and then do a git commit, followed by a git push to
publish the latest version of the ext4 patch queue.

I find this is the easist way of applying the patch queue, and to see
what's is going on.  By using gitk I can get a nice visual image of
the commits that are applied.  If you have problems, and the patch
queue is applied via git, it's much easier for us to check what is up
with you if you send us the output of "git log --decorate
ext4dev_bottom^^..HEAD".  I can also ask you to send the output of
"git status" to make sure there aren't local modifications so we know
it's exactly 2.6.26-rc6 plus the ext4 patch queue.

Regards,

							- Ted
