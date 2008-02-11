From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sun, 10 Feb 2008 23:08:11 -0600
Message-ID: <47AFD83B.7060007@redhat.com>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYBKFIg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2008 00:08:36 -0500
In-Reply-To: <20080211045107.GB25089@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> I'ts been a while since I've pushed one of these out.  This updates pu
> against the latest "next" branch, so we can make sure all of the
> changes that had been folded into "maint" is included on the pu
> branch.  It also includes more work on the tt/extents patches.
> Tune2fs and e2image are now functional with extents, and e2fsck has
> more extents checking added.  Still a bit more work to be done there,
> and I also have to add code to deal with symlinks that have the
> EXTENTS_FL flag set.
> 
> I've dropped the js/flex-bg branch since it had conflicts with the
> on-disk bg flags, and it had conflicts with the exsting patches that
> caused me concern.  Jose, once you regenerate the patch and deal with
> comments, I'll add it back in.
> 
> My TODO list:
> 
>    finish e2fsck extents support
>    more flexible mke2fs.conf handling
>    EXT4 -- allow mke2fs 8TB without -f

ext3 should be fine as well, right?  And I think Josef sent a patch...

-Eric
