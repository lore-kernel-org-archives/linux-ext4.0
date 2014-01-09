From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Fix up workarounds for dietlibc breakage
Date: Thu, 9 Jan 2014 10:25:55 -0500
Message-ID: <20140109152555.GA6192@thunk.org>
References: <1389238019-18921-1-git-send-email-tytso@mit.edu>
 <18FF1403-0799-4877-88F2-31FC6D960F03@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47093 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaAIPZ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jan 2014 10:25:57 -0500
Content-Disposition: inline
In-Reply-To: <18FF1403-0799-4877-88F2-31FC6D960F03@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 08:59:54PM -0700, Andreas Dilger wrote:
> Before e2fsprogs used posix_memalign() the MMP code just allocated a
> 2x sized buffer, and then picked the region in the middle that was
> page aligned.  I'd be fine going back to this to reduce the dependency
> on this interface.

Yeah, I've considered doing that.  It's only a single block, so we'd
only be wasting 4k of memory.

OTOH, there are patches floating around that add posix_memalign()
support to dietlibc.  IIRC, they are included in Fedora at the very
least.  What I don't know is why they aren't in the upstream
distribution.  Did someone not bother to send them upstream, or did
Felix nix them for some reason?  I have on my low priority todo list
to try to follow up on this, and that's why I haven't tried doing the
2x sized buffer thing.

BTW, if we are going to do the 2x buffer thing, we should be doing
that in unix_io.c, which already has direct I/O support.  There's a
lot of duplicate code ext2fs_mmp_read() and ext2fs_mmp_write(); my bad
for noticing this when I accepted the MMP patches.

	 					- Ted

P.S.  BTS, there is an e-mail trail of Felix refusing to fix the
"dietlibc ignores the TZ environment variable" complaint.  I think he
thought the timezone code that they were using was too hairy already,
and the primary use case of dietlibc was one where it was unlikely
that the TZ variable would be used.
