From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sun, 24 Feb 2008 21:20:50 -0700
Message-ID: <20080225042050.GH3534@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
 <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu>
 <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com>
 <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com>
 <20080222231434.GG3029@webber.adilger.int> <20080223001539.GD20118@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56321 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYBYEUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Feb 2008 23:20:54 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1P4KrV1014741
	for <linux-ext4@vger.kernel.org>; Sun, 24 Feb 2008 20:20:53 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWS003011DBQO00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 24 Feb 2008 20:20:53 -0800 (PST)
In-reply-to: <20080223001539.GD20118@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 22, 2008  19:15 -0500, Theodore Ts'o wrote:
> So before the recent patch were we actually creating long symlinks in
> extents format?  Or were we just setting the flag but still treating
> them as a block number?  If it was the latter, I guess we can put in
> code into e2fsck to detect that case, and convert it back to a
> singleton block number.  

Eric informed me that the long symlinks were actually stored in extent
mapped blocks.  That is not harmful, because it can only be a single
block and it will always fit into the inode.  The other thing to note
is that extent mapping is REQUIRED for > 32-bit blocknumbers, so we
may as well fix e2fsprogs to allow these symlinks to be handled normally.

> > I'd say when e2fsprogs has an official release with extents support,
> > and there are no show-stopping bugs in the existing code...  I don't
> > think that is too far off anymore.
> 
> I guess I'd be a *bit* more cautious.  We still have some code patches
> such as the delayed allocation and to a lesser extent the online
> defrag patches which have the possibility of introducing bugs.  Once
> all of those get merged and we have a full kernel release cycle to fix
> the last remaining bugs, that's when I would drop the -dev from the
> name.

Well, there isn't any hard requirement to include delalloc into the
first non-dev ext4 release.  Yes, it would be desirable, but I don't
think we HAVE to have it.  I think the important thing is that the
on-disk format is no longer changing.

One thing that still needs to be done (AFAIK) is the removal of the
"auto-setting" of filesystem feature flags, and allow tune2fs/e2fsck
to set/leave the flags that we currently set automatically.  I'd
hazard that for feature flags which have been around a LONG time (like
EAs and LARGEFILE) that these should be enabled by default.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
