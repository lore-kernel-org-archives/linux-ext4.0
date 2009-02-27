From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 64-bit e2fsprogs patch queue
Date: Thu, 26 Feb 2009 19:10:08 -0500
Message-ID: <20090227001008.GA6706@shell>
References: <20090203155231.GP14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZB0AKu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 19:10:50 -0500
Content-Disposition: inline
In-Reply-To: <20090203155231.GP14762@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 10:52:31AM -0500, Theodore Tso wrote:
> 
> It is a patch series because some of the patches clearly need cleanup
> and refactorization.  For example, you had fixed some bugs in Jose's
> 64-bit_mke2fs_cleanup patch, that should be merged into his patch.
> For another, what's up with "0031-temporary-check-about-to-checksum-
> conversion.patch"?  :-)

I've fixed the above and redid the progress meter patches as you
requested.  I made some attempt to work with the guilt patch queue but
gave up, so the patch set is in the git branch "shared-64bit-handover"
at:

git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

I need you (or Jose) to take the lead on these from here on out; I
have to do things other than work on e2fsprogs in order to justify my
existence at Red Hat. :)

-VAL
