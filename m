From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Wed, 9 Oct 2013 20:26:02 -0400
Message-ID: <20131010002602.GA7035@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012649.28415.17225.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310031848270.1947@localhost.localdomain>
 <20131003190444.GA14971@birch.djwong.org>
 <20131007130328.GA4540@thunk.org>
 <20131009221028.GN6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44321 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab3JJA0K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Oct 2013 20:26:10 -0400
Content-Disposition: inline
In-Reply-To: <20131009221028.GN6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 09, 2013 at 03:10:28PM -0700, Darrick J. Wong wrote:
> 
> Any thoughts on patch #1?  It fixes bugs in the recently-landed patch "tune2fs:
> zero inode table when removing checksums".

I haven't gotten to it yet since I've been focusing on patches which
apply to the maint branch (i.e., for a 1.42.x release).

The metadata checksum patches are on the master/next branch, which
will be for an eventual 1.43 release.

What I plan to do is to get all or most of the changes which are
appropriate for the maint branch applied.  I'll then merge the maint
branch into the next branch, and then start applying the patches which
are specific for a future 1.43 release.

Cheers,

					- Ted
