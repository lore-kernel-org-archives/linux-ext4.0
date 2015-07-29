From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 29 Jul 2015 15:49:23 +0200
Message-ID: <20150729134923.GA7593@quack.suse.cz>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <55B8C4F6.2050502@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B8C4F6.2050502@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 29-07-15 15:20:06, Konstantin Khlebnikov wrote:
> On 15.07.2015 13:26, Jan Kara wrote:
> >   Hello,
> >
> >   so I have created this patch set which removes ext3 driver (and some related support
> >code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> >I will queue the series in my tree for the next merge window.
> >
> >Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> >the first two patches get merged?
> >
> >Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> >from you would be nice.
> >
> >									Honza
> >
> 
> This means some ext3-specific kludges in mm/ could be dropped.
> Like page cleanup in try_to_free_buffers() and couple in vmscan.

Almost. There are still some cases (like block device mappings or even
standard inode mappings in ext4 data=journal mode) where the page cleanup
hack is needed. See
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg933319.html

Both issues look fixable although with block device mappings it won't be
trivial.
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
