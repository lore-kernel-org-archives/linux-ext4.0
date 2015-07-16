From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Thu, 16 Jul 2015 10:53:47 +0200
Message-ID: <20150716085347.GG22847@quack.suse.cz>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <20150715141836.GA18400@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150715141836.GA18400@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 15-07-15 10:18:36, Ted Tso wrote:
> On Wed, Jul 15, 2015 at 12:26:24PM +0200, Jan Kara wrote:
> > 
> >   so I have created this patch set which removes ext3 driver (and some related support
> > code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> > I will queue the series in my tree for the next merge window.
> > 
> > Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> > the first two patches get merged?
> > 
> > Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> > from you would be nice.
> 
> Got tired of maintaining ext3, eh?   :-)

Not really. Maintaining ext3 has been pretty low-effort in last years. But
the releasepage trouble has made me reconsider whether it's worth keeping
ext3 codebase and I just came to conclusion that it may be the right time
to drop it.

> As a minor nit, I wonder if it's worth while to put in some hackery in
> fs/Kconfig so that if someone only has CONFIG_FS_EXT3 defined, but not
> CONFIG_FS_EXT4 defined, that it will automatically enable
> CONFIG_FS_EXT4 instead?  Otherwise someone upgrading their kernel
> might accidentally end up getting a non-functional kernel.
> 
> i.e., something like this? (not tested!)
> 
> config FS_EXT3
>        def_bool n
>        select FS_EXT4

Good point. Will add something like this, although the config will have to
have some prompt for this to work...

> In any case, since the 2/3 patch didn't hit the list, here's my:
> 
> Acked-by: Theodore Ts'o <tytso@mit.edu>

Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
