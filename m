From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Thu, 16 Jul 2015 09:27:33 +0200
Message-ID: <20150716072733.GF22847@quack.suse.cz>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <1436972465.16262.16.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436972465.16262.16.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 15-07-15 08:01:05, Joe Perches wrote:
> On Wed, 2015-07-15 at 12:26 +0200, Jan Kara wrote:
> > I have created this patch set which removes ext3 driver (and some related support
> > code) from the kernel. See changelog of patch 2/3 for more details.
> 
> It'd be nice if you regenerate 2/3 using
> git format-patch -M and resend it.

Good idea, thanks. Will do with the next submission.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
