From: Karel Zak <kzak@redhat.com>
Subject: Re: rawhide's init/nash segfaults in libblkid
Date: Tue, 24 Feb 2009 08:59:23 +0100
Message-ID: <20090224075923.GE6020@nb.net.home>
References: <87ab8dds1z.fsf@meyering.net> <20090223224219.GB3199@webber.adilger.int> <49A328B2.7090503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Jim Meyering <jim@meyering.net>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBXH7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 02:59:32 -0500
Content-Disposition: inline
In-Reply-To: <49A328B2.7090503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 23, 2009 at 04:52:34PM -0600, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On Feb 23, 2009  17:41 +0100, Jim Meyering wrote:
> >> FYI, I've just filed this against the kernel:
> >>
> >>   http://bugzilla.redhat.com/486997
> >>
> >> Perhaps it should be reassigned to e2fsprogs...
> >> ---------
> >>
> >> Normally I track rawhide pretty closely, but for the last few weeks
> >> new kernels haven't booted on the system I use for that, so I stuck
> >> with the most recent one that worked,
> > 
> > Is rawhide using util-linux-ng that included the libblkid code?  It
> > seems we probably need to add a configure check to e2fsprogs not to
> > build libblkid if util-linux-ng has it.
> 
> Karel just sent a patch to do so (more or less), I think.
> 
> [PATCH] blkid: add --disable-libblkid to build with external libblkid
> 
> but AFAIK rawhide is still using e2fsprogs' blkid.  I'll look into it.

 Right, Fedora rawhide is using the latest stable util-linux-ng
 without libblkid.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
