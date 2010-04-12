From: tytso@mit.edu
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative
 metadata blocks
Date: Mon, 12 Apr 2010 09:42:28 -0400
Message-ID: <20100412134228.GL1849@thunk.org>
References: <4BBCFD10.3030504@redhat.com>
 <87sk76tkx9.fsf@openvz.org>
 <4BBDF610.8030906@redhat.com>
 <87eiimtjne.fsf@openvz.org>
 <20100412131530.GB12238@atrey.karlin.mff.cuni.cz>
 <87iq7whk2t.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab0DLO0p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 10:26:45 -0400
Content-Disposition: inline
In-Reply-To: <87iq7whk2t.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 12, 2010 at 05:33:14PM +0400, Dmitry Monakhov wrote:
> BTW I'm too familiar with cross-devel-tree process
> If tytso@ will get the patchset will you get an quota-related patches
> to linux-fs tree too? Otherwise everybody have to wait for ext4-tree
> push to linus's tree and when to linux-fs.

I've already asked Jan if he would mind my carrying the quota patches
in the ext4 tree, since I believe there's less chance of patch
collisions with upcoming changes in the quota tree than if they were
carried in the quota tree and we had to worry about changes to the
ext4 tree.

These patches are also low-risk enough (they'll either work or they
won't, and it's not hard to desk-check them for correctness) that we
could push them to Linus now before the merge window, and see if he's
willing to take them.  I have some data corruption bugfixes I need to
push to Linus anyway....  I dunno if Linus will be willing to take
them, but that's the other approach.

					- Ted
