From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Mon, 28 Sep 2015 13:45:32 -0400
Message-ID: <20150928174532.GA29925@thunk.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <20150927072421.GA23102@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150927072421.GA23102@xo-6d-61-c0.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 27, 2015 at 09:24:21AM +0200, Pavel Machek wrote:
> 
> Nice to see sources getting smaller... but how much bigger do the binaries get
> for someone only using ext3?

The difference in object size between ext3 and ext4 is about 200k.
Most of the efforts to use really tiny kernels are looking at kernels
way smaller than even ext3, so this isn't something I'm terribly
worried about.  (That is, they'll be using ext2, or squashfs, or
jffs2, etc.)

						- Ted
