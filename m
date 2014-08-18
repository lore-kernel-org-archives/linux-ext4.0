From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock
 in non-movable area
Date: Mon, 18 Aug 2014 13:44:38 +0900
Message-ID: <53F184B6.5080503@lge.com>
References: <53EC4531.1000904@lge.com> <20140814142610.6f0d4194c373fef188870772@linux-foundation.org> <20140816185208.GA1589@quack.suse.cz> <53F153B4.1060309@lge.com> <20140818032422.GD23084@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140818032422.GD23084@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-08-18 =EC=98=A4=ED=9B=84 12:24, Theodore Ts'o =EC=93=B4 =EA=B8=80:
> On Mon, Aug 18, 2014 at 10:15:32AM +0900, Gioh Kim wrote:
>>
>> My test platform has totally 1GB memory, 256MB for CMA and 768MB for=
 normal.
>> I applied Joonsoo's patch: https://lkml.org/lkml/2014/5/28/64, so th=
at
>> 3/4 of allocation take place in normal area and 1/4 allocation take =
place in CMA area.
>>
>> And my platform has 4 ext4 partitions. Each ext4 partition has 2 pag=
e caches for superblock that
>> are what this patch tries to move to out of CMA area.
>> Therefore there are 8 page caches (8 pages size) that can prevent pa=
ge migration.
>
> Yes, but are you actually *using* the ext4 partitions for anything?
> If this is a realistic real world use case, file systems are used to
> store, well, files, and that means there will be inodes and dentry
> cache entries that will also be allocated.  Does your test scenario
> reflect real world usage?

Yes. I'm working for LG Electronics.
My test platform is currently selling item in the market.
And also I test my patch when my platform is working as if real user us=
es it.

I think the page caches of the inodes and dentry are held for short tim=
e.
I can see pairs of get_bh and put_bh in inodes/dentry handling.

I think inodes is allocated by kmem_cache_alloc in ext4_alloc_inode().
It is non-movable area allocation.


>
> Cheers,
>
> 						- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
