From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Wed, 4 Feb 2009 10:32:05 -0500
Message-ID: <20090204153205.GF14762@mit.edu>
References: <49829A1D.5090002@rs.jp.nec.com> <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com> <49894CD4.4060000@rs.jp.nec.com> <20090204140911.GB14762@mit.edu> <87f94c370902040651v388db0aak46d7843872d312ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36056 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZBDPcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2009 10:32:08 -0500
Content-Disposition: inline
In-Reply-To: <87f94c370902040651v388db0aak46d7843872d312ce@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 04, 2009 at 09:51:07AM -0500, Greg Freemyer wrote:
> 
> If the OHSM team implements a similar ioctl for ext2 and ext3 and
> submits them for mainline at some point, do they have a chance of
> being accepted or are ext2 and ext3 feature frozen?

It seems unlikely it would be accepted.  If the patch could be done in
a way that seriously minimized the chances of destablizing the code,
maybe --- but consider also that the OHSM design is a pretty terrible
hack.  I'm not at all conviced they will be able to stablize it for
production use, and a scheme that involves using dmapi across multiple
block devices.

Note that they apparently need to make other changes to the core
filesystem code besides just the ioctl --- to the block allocation
code, at the very least.

The right answer is really to use a stackable filesystem, and to use
separate filesystems for each different tier, and then build on top of
unionfs to give it its policy support.  I suspect that OHSM will be a
cute student project, but it won't become anything serious given its
architecture/design, unfortunately.

						- Ted
