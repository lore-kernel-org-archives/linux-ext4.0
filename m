From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 14:47:09 +0200
Message-ID: <20150715124709.GA11446@quack.suse.cz>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <55A63DE0.9010902@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Nikolay Borisov <n.borisov@siteground.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A63DE0.9010902@kyup.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 15-07-15 14:02:56, Nikolay Borisov wrote:
> 
> 
> On 07/15/2015 01:26 PM, Jan Kara wrote:
> >   Hello,
> > 
> >   so I have created this patch set which removes ext3 driver (and some related support
> > code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> > I will queue the series in my tree for the next merge window.
> 
> Did you accidentally miss patch 2/3 ?

No, I did not but apparently it was too big for the list. Interested people
can have a look at my tree:
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git releasepage

The particular commit is:

https://git.kernel.org/cgit/linux/kernel/git/jack/linux-fs.git/commit/?h=releasepage&id=32c4b776ad2774aa0e8fdd8ad35f848b15b84f38

Thanks for the notice.

								Honza
> > 
> > Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> > the first two patches get merged?
> > 
> > Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> > from you would be nice.
> > 
> > 									Honza
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
