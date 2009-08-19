From: Theodore Tso <tytso@mit.edu>
Subject: Re: Block allocation failed
Date: Wed, 19 Aug 2009 09:50:06 -0400
Message-ID: <20090819135006.GB17488@mit.edu>
References: <87iqgk8jal.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60887 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZHSNuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 09:50:16 -0400
Content-Disposition: inline
In-Reply-To: <87iqgk8jal.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 06:27:46AM +0100, Graham Murray wrote:
> Shortly after rebooting following an untidy shutdown due to an unrelated
> (to ext4 or the filesystem) Oops. Unmounting the partition and running
> e2fsck (version 1.41.8) just replayed the journal and stated the
> filesystem was clean but I did not believe it so ran 'e2fsck -f
> /dev/sdb3' and that showed several errors which I allowed it to correct.

What sort of errors did it find?

> Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 35: 3499 blocks in bitmap, 3243 in gd
> Aug 18 23:50:07 newton Aborting journal on device sdb3:8.

Was this right after you mounted the filesystem, or did some time
take place before these errors started showing up?

						- Ted
