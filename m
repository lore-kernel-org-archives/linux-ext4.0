From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/2 v2] Improve orphan list scaling
Date: Mon, 19 May 2014 10:50:32 -0400
Message-ID: <20140519145032.GA4012@thunk.org>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49251 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbaESOuh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 10:50:37 -0400
Content-Disposition: inline
In-Reply-To: <1400185026-3972-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2014 at 10:17:04PM +0200, Jan Kara wrote:
>   this is my version of patches to improve orphan list scaling by
> reducing amount of work done under global s_orphan_mutex. We are
> in disagreement with Thavatchai whose patches are better (see thread
> http://www.spinics.net/lists/linux-ext4/msg43220.html) so I guess it's
> up to Ted or other people on this list to decide.

I've started testing Jan's patches, mainly because of the simplicity
issue, and becase I agree with him that it's not clear that the hashed
mutexes is worth the extra complexity, even though it's a vanishingly
small number of systems that would show any benefit for them, and even
then it's not clear the changes are that much greater.

For the purposes of doing further optimizations, I'd prefer to start
with Jan's changes as a starting point and as a performance baseline
for further improvements.

If adding more mutexes or spinlocks, even 128 more mutexes per
filesystem, can be justified by a really huge improvement, it's
something that I won't completely rule out at this stage.  But I'd
rather avoid that unless the comparative benchmarks and lock_stat
reports make for an extremely convincing case.

Cheers,

					- Ted
