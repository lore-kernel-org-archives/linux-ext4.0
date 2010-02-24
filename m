From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: Fix bug which can cause e2fsck -fD to corrupt
 non-indexed directories
Date: Wed, 24 Feb 2010 10:11:03 -0500
Message-ID: <20100224151103.GB5166@thunk.org>
References: <1266903821-20800-1-git-send-email-tytso@mit.edu>
 <56B4B314-CBF3-495B-96BD-FCD524D539DA@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44125 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab0BXPLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 10:11:07 -0500
Content-Disposition: inline
In-Reply-To: <56B4B314-CBF3-495B-96BD-FCD524D539DA@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 24, 2010 at 01:25:16AM -0700, Andreas Dilger wrote:
> Do you have a regression test for this case?  e2fsck itself will
> detect the corruption ("." and ".." not at the start of the
> directory) after the fact, but I guess it means that there are no
> existing tests where there is a directory entry that sorts before
> "." or it would have been noticed earlier.

Yes, I'll add a regression test; binary files just don't work well in
patch sets, so I tend to put those in separate commits, for ease in
cherry picking.  Basically it's just a 100k ext2 filesystem with a
directory which happens to contain a name that begins with a open
parenthesis, i.e., "(oops)".

> Have you pulled this release from Sourceforge and any downstream
> releases already (Debian, FC, etc)?  It seems like a pretty serious
> problem, even though "-fD" is likely not run very often.

I was just going to accelerate getting 1.41.11 out the door, as
opposed to going to the effort of trying to deprecate 1.41.10.  In the
case of Debian, and Ubuntu, it's too late already since 1.41.10 has
already propagated out to bleeding-edge users.  So the only way to
pull it back would be to get a new release out the door, quickly...

I guess I can easily enough pull it from kernel.org and make
1.41.9 the default release to download on sourceforge.net.

       	   	   	      	       	  - Ted
