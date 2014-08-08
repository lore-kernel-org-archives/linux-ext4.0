From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Fri, 8 Aug 2014 17:47:32 -0400
Message-ID: <20140808214732.GN25145@thunk.org>
References: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51462 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759137AbaHHVre (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Aug 2014 17:47:34 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 03:31:12PM -0400, TR Reardon wrote:
> Kernel 3.16, e2fsprogs 1.43-WIP (1.42.11 compiled with metadata_csum
> support), filesystems mounted with journal_async_commit.
> 
> This may be an fsck problem, hard to tell.  I consistently have
> problems with journal recovery after hard reboot when filesystem has
> metadata_csum.   Interestingly, no problems with 64-bit filesystems.

These are test file systems I hope.  metadata_csum is something where
we're still working out some of the bugs.  (Obviously)

So metadata_csum works fine with 64-bit file systems, but it is
failing with journal recovery if the 64-bit file system feature is not
enabled?  Is that a correct summary of what you are seeing?

Also, with e2fsprogs 1.43-WIP releases, it's important that you
specify the git commit id you are using, since the next branch in
particular is quite fast moving.

						- Ted
