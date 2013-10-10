From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Thu, 10 Oct 2013 15:04:56 -0700
Message-ID: <20131010220456.GQ6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012649.28415.17225.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310031848270.1947@localhost.localdomain>
 <20131003190444.GA14971@birch.djwong.org>
 <20131007130328.GA4540@thunk.org>
 <20131009221028.GN6860@birch.djwong.org>
 <20131010002602.GA7035@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49472 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3JJWFH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Oct 2013 18:05:07 -0400
Content-Disposition: inline
In-Reply-To: <20131010002602.GA7035@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 09, 2013 at 08:26:02PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 09, 2013 at 03:10:28PM -0700, Darrick J. Wong wrote:
> > 
> > Any thoughts on patch #1?  It fixes bugs in the recently-landed patch "tune2fs:
> > zero inode table when removing checksums".
> 
> I haven't gotten to it yet since I've been focusing on patches which
> apply to the maint branch (i.e., for a 1.42.x release).
> 
> The metadata checksum patches are on the master/next branch, which
> will be for an eventual 1.43 release.
> 
> What I plan to do is to get all or most of the changes which are
> appropriate for the maint branch applied.  I'll then merge the maint
> branch into the next branch, and then start applying the patches which
> are specific for a future 1.43 release.

Ok.  Do you want me to hold off on reissuing changed patches and sending out
new patches until then?  Or should I just send 'em and we can deal with the
blizzard later?

Patches 2, 14-16, and 22 have changed, and there are now 9 more patches, mostly
to fix resize2fs bugs.

Eh, I'll move the ones you took to the start of my quilt, and hope they don't
change too much when they get merged in.  That'll help me keep the in-review
patches in a consecutive pile.

--D
> 
> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
