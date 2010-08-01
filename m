From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix freeze deadlock under IO
Date: Sun, 1 Aug 2010 17:41:32 -0400
Message-ID: <20100801214132.GA27573@thunk.org>
References: <4C1A2839.5010407@cfl.rr.com>
 <20100617142731.GA10071@redhat.com>
 <4C1A4A74.9070105@cfl.rr.com>
 <20100617162747.GA21336@redhat.com>
 <4C1ACBF1.3050603@cfl.rr.com>
 <4C1BC125.4090902@sandeen.net>
 <4C1BC6D0.2030203@sandeen.net>
 <4C1BC7AD.1060900@sandeen.net>
 <4C226277.4060505@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@cfl.rr.com>, Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Dave Chinner <dchinner@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36379 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0HAWnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Aug 2010 18:43:23 -0400
Content-Disposition: inline
In-Reply-To: <4C226277.4060505@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 23, 2010 at 02:37:27PM -0500, Eric Sandeen wrote:
> Commit 6b0310fbf087ad6 caused a regression resulting in deadlocks
> when freezing a filesystem which had active IO; the vfs_check_frozen
> level (SB_FREEZE_WRITE) did not let the freeze-related IO syncing
> through.  Duh.
> 
> Changing the test to FREEZE_TRANS should let the normal freeze
> syncing get through the fs, but still block any transactions from
> starting once the fs is completely frozen.
> 
> I tested this by running fsstress in the background while periodically
> snapshotting the fs and running fsck on the result.  I ran into
> occasional deadlocks, but different ones.  I think this is a
> fine fix for the problem at hand, and the other deadlocky things
> will need more investigation.
> 
> Reported-by: Phillip Susi <psusi@cfl.rr.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the ext4 patch queue.  Sorry for missing this earier.

	       	    	  	  	    - Ted
