From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
Date: Thu, 21 Aug 2014 09:38:10 +0900
Message-ID: <53F53F72.9050305@lge.com>
References: <53F2F3E6.1030901@lge.com> <53F2F436.4070307@lge.com> <20140819130324.GB27553@quack.suse.cz> <53F3DFA3.6040303@lge.com> <20140820021623.GB3271@quack.suse.cz> <53F40A12.6040506@lge.com> <20140820220224.GA5752@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140820220224.GA5752@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-08-21 =EC=98=A4=EC=A0=84 7:02, Jan Kara =EC=93=B4 =EA=B8=80:
> On Wed 20-08-14 11:38:10, Gioh Kim wrote:
>>
>>>>>> @@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
>>>>>>   struct buffer_head *
>>>>>>   __getblk(struct block_device *bdev, sector_t block, unsigned s=
ize)
>>>>>>   {
>>>>>> -       struct buffer_head *bh =3D __find_get_block(bdev, block,=
 size);
>>>>>> -
>>>>>> -       might_sleep();
>>>>>> -       if (bh =3D=3D NULL)
>>>>>> -               bh =3D __getblk_slow(bdev, block, size);
>>>>>> -       return bh;
>>>>>> +       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>>>>>>   }
>>>>>>   EXPORT_SYMBOL(__getblk);
>>>>>    Why did you remove the __find_get_block() call? That looks lik=
e a bug.
>>>    I'm not sure if you didn't miss this comment....
>>
>> I'm sorry I missed it.
>> I think calling __find_get_block() in __getblk_gfp() can replace it.
>> I'm not sure about it.
>>
>> If anybody disagree with it, I'll change it as the original code.
>    OK, I see. Thanks for explanation. I agree we can remove
> __find_get_block() from __getblk() but please make this change a sepa=
rate
> patch and also please put the might_sleep() check __getblk_gfp().
>
> 								Honza
>

I got it.
I'm going to report v3 patch that reverts __getblk() and adds sb_bread_=
unmovable(),
if Andrew give me a feedback about the other codes.
I can wait ;-)

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
