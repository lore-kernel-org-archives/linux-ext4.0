From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck -y says "yes" to "Abort?"
Date: Sat, 18 Apr 2009 12:17:10 -0400
Message-ID: <20090418161710.GF19186@mit.edu>
References: <49E9DF6A.1090000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790AbZDRQRR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 12:17:17 -0400
Content-Disposition: inline
In-Reply-To: <49E9DF6A.1090000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 18, 2009 at 09:10:50AM -0500, Eric Sandeen wrote:
> I've got this bug filed against Fedora:
> 
> sh-3.2# e2fsck -y /dev/VolGroup00/VolVol02
> e2fsck 1.41.3 (12-Oct-2008)
> The filesystem size (according to the superblock) is 14090240 blocks
> The physical size of the device is 8847360 blocks
> Either the superblock or the partition table is likely to be corrupt!
> 
> Abort? yes
> 
> I'm reluctant to invert the logic of the Abort? question as suggested
> ("Are you sure you want to continue?") because this is a significant
> enough problem that we probably should really pause for consideration.
> 
> But it seems like perhaps stopping at "Abort?", allowing the user to say
> "n" to that and then let the "-y" flag take over from there would be
> reasonable.
> 
> If this sounds ok I'll whip up a patch, something like a way to flag the
> really serious questions (?) as unaffected by -y.

Seems reasonable to me; we'll have to update the documentation to
explain that -y really doesn't mean yes to _all_ questions, but that
seems like the best approach.

					- Ted
