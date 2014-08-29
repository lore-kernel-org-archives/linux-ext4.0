From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv3 0/3] new APIs to allocate buffer-cache with user specific
 flag
Date: Fri, 29 Aug 2014 09:22:55 +0900
Message-ID: <53FFC7DF.9030508@lge.com>
References: <53FE9357.6000505@lge.com> <20140828134804.GC21925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140828134804.GC21925@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-08-28 =EC=98=A4=ED=9B=84 10:48, Theodore Ts'o =EC=93=B4 =EA=B8=80:
> On Thu, Aug 28, 2014 at 11:26:31AM +0900, Gioh Kim wrote:
>>
>> I have 3 patchs:
>>
>> 1. Patch 1/3: introduce a new API that create page cache with alloca=
tion flag
>> 2. Patch 2/3: have ext4 use the new API to read superblock
>> 3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of su=
perblock
>>
>> This patchset is based on linux-next-20140814.
>
> Looks good.  Unless there are any objections from the mm folks, since
> the nearly all of the changes are in fs/buffer.c and in ext4/jbd2
> code, I plan to carry this in the ext4 tree.
>
> I do plan to clean up the patch titles a little; from:
>
> fs/buffer.c: allocate buffer cache with user specific flag
> ext4: allocate buffer-cache for superblock in, non-movable area
> jbd/jbd2: allocate buffer-cache for superblock inode in non-movable a=
rea
>
> to:
>
> fs.c: support buffer cache allocations with gfp modifiers
> ext4: use non-movable memory for the ext4 superblock
> jbd/jbd2: use non-movable memory for the jbd superblock
>
> And do some minor english grammar/spelling cleanups in the commit
> description when I apply the patch.
>
> Thanks for this work; I'm going to need to use the interfaces you
> introduced in fs/buffer.c to guarantee that certain directory reads
> can be done with GFP_NOFAIL (since under heavy memory pressure,
> allocation failures there can currently lead to the file system
> getting declared corrupt.  Interestingly, this bug has been around fo=
r
> a long time, and hasn't been noticed in over two cycles of enterprise
> distro qualifications by either RHEL or SLES, which leads me to wonde=
r
> if there are other places where the error paths for GFP_NOFS
> allocations haven't been well tested....)
>
> 						- Ted
>

Thanks a lot. It's my honor.
I'm not good at English, so please feel free to fix it.

Jan Kara requested me some changes for the interfaces.
I'm going to send v4 soon with new titles you recommend and some change=
 for the interfaces.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
