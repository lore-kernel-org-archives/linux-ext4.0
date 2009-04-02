From: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 2 Apr 2009 10:54:36 -0400
Message-ID: <20090402145436.GF10642@mit.edu>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com> <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu> <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com> <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com> <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com> <49D4BDF2.2070102@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53186 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZDBOyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2009 10:54:45 -0400
Content-Disposition: inline
In-Reply-To: <49D4BDF2.2070102@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2009 at 03:30:26PM +0200, Thiemo Nagel wrote:
> When I added the block range checks, initially I was assuming that
> when EXTENTS_FL is not set, the inode->i_data *always* contains
> references to further blocks.  Ted showed me wrong and added the condition
>
> 	ISREG() || ISDIR() || ( ISLNK() && !is_fast_symlink() )
>
> before that assumption can be made.  But maybe we need some further
> restraints?

It's a endian-problem; we're missing le32_to_cpu() in that patch.
Sparc is big-endian. 

Alexander, thanks for pointing this out.  We'll have to get this fixed
and pushed to Linus ASAP.

						- Ted
