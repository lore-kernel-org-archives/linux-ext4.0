From: tytso@mit.edu
Subject: Re: [PATCH 2.6.27.y 04/11] ext4: Add percpu dirty block accounting.
Date: Tue, 16 Mar 2010 20:51:38 -0400
Message-ID: <20100317005138.GC4874@thunk.org>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
 <1268699165-17461-5-git-send-email-tytso@mit.edu>
 <FC682EC6-96F8-475B-9569-9E2A26454BF2@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "K. V K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55106 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab0CQAvn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Mar 2010 20:51:43 -0400
Content-Disposition: inline
In-Reply-To: <FC682EC6-96F8-475B-9569-9E2A26454BF2@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 16, 2010 at 12:48:03PM -0600, Andreas Dilger wrote:
> 
> Just looking at this old patch, and noticed this is still the same
> in newer versions.
> 
> This should probably be either an ext4_error(), since it affects
> data correctness, even though it isn't an on-disk error, or at least
> an ext4_msg() so that it also prints the block device and uses the
> standard ext4 error format.

Yeah, we should convert it to use ext4_msg(); using ext4_error()
doesn't seem appropriate since that will mark the file system as
corrupted, which isn't the case if this isn't an on-disk error.  Maybe
a WARN_ON(1) is appropriate so that we get a stack trace and
kerneloops.org tracking?

> In the first patch (ext4-claim-err.diff) the access to the
> superblock for ext4_msg() is a bit of a hack, but I think it isn't
> terrible.

Agreed, this isn't bad.

> The second patch (ext4-error-cleanup.diff, to be used instead of the
> first one) is a bit more thorough cleanup that changes the callers
> to pass a struct super_block, and also removes some single-use stack
> variables in related code.

I haven't looked closely at this one yet, I'm not entirely convinced
the cleanups are worth all of the changes, but I'm willing to be
convinced.

					- Ted

