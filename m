From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Wed, 6 Feb 2008 09:05:59 -0500
Message-ID: <20080206140559.GJ27119@mit.edu>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20080206125651.GD558@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>, util-linux-ng@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48224 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYBFOGo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 09:06:44 -0500
Content-Disposition: inline
In-Reply-To: <20080206125651.GD558@petra.dvoda.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:56:51PM +0100, Karel Zak wrote:
> It would be nice to add a note
> 
>     "fsck is deprecated in favor of fsck from util-linux-ng"
> 
> to RELEASE-NOTES in e2fsprogs.

I don't want to deprecate fsck quite yet from e2fsprogs, because there
are some ext4 issues with fsck (or more accurately, fsck's use of
vol_id instead of blkid), where it is more convenient if at least for
distros that are being aggressive with ext4 testing, if we don't try
to move fsck just now.

I'm working with Eric Sandeen from Red Hat to make sure that we can
get usable ext4 support for FC9 in rawhide, and making sure that
vol_id is doing the right thing with ext4 support is one more moving
part that I'd rather not have to coordinate with.  So it's going to be
much simpler for now if we keep fsck in e2fsprogs, and what I'm
telling people who want to play with ext4 is that life will be much
simpler if they use the latest e2fsprogs and build mount so that it
uses blkid, and NOT vol_id.

Kay and I have had philosophical differences about how hard to try to
make in-line detection of filesystems work, and when I've tried to
submit patches that fine-tune filesystem id detection, by rejiggering
the order in which various filesystems types are tried (based on how
thoroughly their mkfs commands scrub the disk to remove false
positives for previous filesystems on the disk), they've been rejected
by Kay.

So these days, while I'll take any patches to improve blkid's
filesystem detection, I've largely stopped trying to send patches in
the other direction.  And there are some rather delicate tests that
have been encoded into blkid to coordinate with ext4 and ext4dev
(since at some point when the code is production ready we will be
changing the filesystem name from ext4dev to ext4), it's just much
simpler if I tell people that in order to support ext4, the only
approach I've validated uses fsck from e2fsprogs, and mount compiled
to use libblkid.

I'd love to try to work on merging the functionality between vol_id
and blkid, and at some point that's great, but I just don't have the
time right now to try to coordinate yet another moving part.

     	       	      	 	    		- Ted
