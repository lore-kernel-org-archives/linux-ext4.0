From: Theodore Tso <tytso@mit.edu>
Subject: Re: can not find some patches from patch queue on ext4 git tree
Date: Thu, 18 Oct 2007 14:26:36 -0400
Message-ID: <20071018182635.GA13504@thunk.org>
References: <47179AAC.1030402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59767 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJRS0j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 14:26:39 -0400
Content-Disposition: inline
In-Reply-To: <47179AAC.1030402@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 19, 2007 at 01:41:00AM +0800, Coly Li wrote:
>
> Hi, my local ext4 git tree is from git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git,
> with commit commit d85714d81cc0408daddb68c10f7fd69eafe7c213.
>
> It seems some of patchese of patch queue are not in current tree,
> which were there 1 - 2 days ago.  Is it because we are merging ext4
> tree to 2.6.23 ? and after the merge, the patches will in pached in
> the tree again ?  Should I generate my patch based on current
> version, or wait for some day ? Indeed, I try to add my patch to
> current version, but some patches missing from ext4 tree.

You're apparently looking at the master branch of ext4.git.  There are
multiple branch heads, and the master branch head moves around a lot.
If you look at the web page, it might be clearer:

http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

At the bottom of the page, there is a list of branch heads.
2.6.23-ext4-1 was the last ext4 snapshot that we published.  The
"for_linus" branch contains the stable version of the patch queue that
I have requested that Linus pull from.

The master branch is one that I haven't been careful about maintaining
stably, although maybe I should be more careful about that, since it's
one people tend to use by default.  OK, it's fixed.  I've repointed
the master pointer to point at 2.6.23-ext4-1.  Sorry about any
confusion that this might have caused.

Right now, during the merge window, things are a little crazy, just
because patches are flowing in from the -mm tree as well as from the
ext4 tree.  So it's probably easier to do your development against
2.6.23-ext4-1 and then after the merge carnage settles down, we can
fix up the patch.   

If it's easier, you can also see the ext4 patches as a quilt stack here:

http://repo.or.cz/w/ext4-patch-queue.git
git://repo.or.cz/ext4-patch-queue.git

It's currently in a state of flux as well as we're waiting for patches
to get merged, but hopefully that will settle down within a day or
two.  To explain how things work, a number of people have write access
into the ext4-patch-queue, and it gets run through an automated test
system located at IBM (both the whole patch queue, as well as the
first part up to the "stable boundary", which is the list of patches
we plan to push to Linus).  This allows us to work in parallel
cleaning up varoius patches, and periodically I'll generate an ext4
patch series which is what gets pulled into the -mm tree for testing.
This all works pretty well, except during the merge window; but
fortunately that's a relaively short period of time.

Regards,

							- Ted
