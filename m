From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 10:18:36 -0400
Message-ID: <20150715141836.GA18400@thunk.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 15, 2015 at 12:26:24PM +0200, Jan Kara wrote:
> 
>   so I have created this patch set which removes ext3 driver (and some related support
> code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> I will queue the series in my tree for the next merge window.
> 
> Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> the first two patches get merged?
> 
> Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> from you would be nice.

Got tired of maintaining ext3, eh?   :-)

As a minor nit, I wonder if it's worth while to put in some hackery in
fs/Kconfig so that if someone only has CONFIG_FS_EXT3 defined, but not
CONFIG_FS_EXT4 defined, that it will automatically enable
CONFIG_FS_EXT4 instead?  Otherwise someone upgrading their kernel
might accidentally end up getting a non-functional kernel.

i.e., something like this? (not tested!)

config FS_EXT3
       def_bool n
       select FS_EXT4


In any case, since the 2/3 patch didn't hit the list, here's my:

Acked-by: Theodore Ts'o <tytso@mit.edu>

For that patch.

    	 						- Ted
