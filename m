From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7 v2] ext4: reclaim extents from extent status tree
Date: Mon, 21 Jan 2013 10:00:20 -0500
Message-ID: <20130121150020.GA5618@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
 <20130118051921.GC13785@thunk.org>
 <20130118053947.GD13785@thunk.org>
 <20130121072443.GA24053@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44601 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab3AUPA2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 10:00:28 -0500
Content-Disposition: inline
In-Reply-To: <20130121072443.GA24053@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2013 at 03:24:43PM +0800, Zheng Liu wrote:
> 
> Do we need to CC' linux-fsdevel mailling list to let other folks review
> this patch?

For this patch, yes.  And we'll need a commit description which
explains why it's needed.  Since I wrote the patch, I'm happy to
supply the commit description.  We can include it as a separate patch
in your patch series, and I'll cc linux-fsdevel.

As Jan mentioned, the only other user of it is Dave Chinner for the
XFS code, and I had alreday checked to make sure that it shouldn't
affect him --- but it would be good to cc him so he's in the loop.

Speaking of commit descriptions, I had made some other minor
adjustments to some of the commits in your last version of the patch
series, since I had already been assuming that I could take them until
I saw the potential problems with the memory shrinker patch.  So you
can just provide a new version of the memory shrinker patch --- or if
you have other changes you want to make to the earlier patches in that
patch series, let me know and I can extract out the various comments
and whitespace fixes that from the patches I have in my private tree,
so we can merge them with any additional updates to your patches.

Cheers, and thanks for working on this!

					- Ted

