From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user
 specific flag
Date: Thu, 21 Aug 2014 00:02:24 +0200
Message-ID: <20140820220224.GA5752@quack.suse.cz>
References: <53F2F3E6.1030901@lge.com>
 <53F2F436.4070307@lge.com>
 <20140819130324.GB27553@quack.suse.cz>
 <53F3DFA3.6040303@lge.com>
 <20140820021623.GB3271@quack.suse.cz>
 <53F40A12.6040506@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53F40A12.6040506@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 20-08-14 11:38:10, Gioh Kim wrote:
> 
> >>>>@@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
> >>>>  struct buffer_head *
> >>>>  __getblk(struct block_device *bdev, sector_t block, unsigned size)
> >>>>  {
> >>>>-       struct buffer_head *bh = __find_get_block(bdev, block, size);
> >>>>-
> >>>>-       might_sleep();
> >>>>-       if (bh == NULL)
> >>>>-               bh = __getblk_slow(bdev, block, size);
> >>>>-       return bh;
> >>>>+       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
> >>>>  }
> >>>>  EXPORT_SYMBOL(__getblk);
> >>>   Why did you remove the __find_get_block() call? That looks like a bug.
> >   I'm not sure if you didn't miss this comment....
> 
> I'm sorry I missed it.
> I think calling __find_get_block() in __getblk_gfp() can replace it.
> I'm not sure about it.
> 
> If anybody disagree with it, I'll change it as the original code.
  OK, I see. Thanks for explanation. I agree we can remove
__find_get_block() from __getblk() but please make this change a separate
patch and also please put the might_sleep() check __getblk_gfp().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
