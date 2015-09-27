From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Sun, 27 Sep 2015 09:24:21 +0200
Message-ID: <20150927072421.GA23102@xo-6d-61-c0.localdomain>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 2015-07-15 12:26:24, Jan Kara wrote:
>   Hello,
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

Nice to see sources getting smaller... but how much bigger do the binaries get
for someone only using ext3?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
