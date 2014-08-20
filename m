From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
Date: Wed, 20 Aug 2014 11:38:10 +0900
Message-ID: <53F40A12.6040506@lge.com>
References: <53F2F3E6.1030901@lge.com> <53F2F436.4070307@lge.com> <20140819130324.GB27553@quack.suse.cz> <53F3DFA3.6040303@lge.com> <20140820021623.GB3271@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140820021623.GB3271@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>>>> @@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
>>>>   struct buffer_head *
>>>>   __getblk(struct block_device *bdev, sector_t block, unsigned size)
>>>>   {
>>>> -       struct buffer_head *bh = __find_get_block(bdev, block, size);
>>>> -
>>>> -       might_sleep();
>>>> -       if (bh == NULL)
>>>> -               bh = __getblk_slow(bdev, block, size);
>>>> -       return bh;
>>>> +       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>>>>   }
>>>>   EXPORT_SYMBOL(__getblk);
>>>    Why did you remove the __find_get_block() call? That looks like a bug.
>    I'm not sure if you didn't miss this comment....

I'm sorry I missed it.
I think calling __find_get_block() in __getblk_gfp() can replace it.
I'm not sure about it.

If anybody disagree with it, I'll change it as the original code.
